package coms.fins.ojt.controller;

import coms.fins.ojt.domain.UserVO;
import coms.fins.ojt.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    /**
     * 아이디 중복 체크 API (/api/auth/dup)
     * POST 요청: {"id": "입력ID"}
     * 응답: {"duplicate": true} 또는 {"duplicate": false}
     */
    @PostMapping("/dup")
    public ResponseEntity<Map<String, Boolean>> checkDuplicate(
            @RequestBody(required = false) Map<String, String> requestBody,
            @RequestParam(value = "id", required = false) String paramId) {

        Map<String, Boolean> response = new HashMap<>();

        String targetId = null;
        if (requestBody != null && requestBody.containsKey("id")) {
            targetId = requestBody.get("id");
        } else if (paramId != null) {
            targetId = paramId;
        }

        if (targetId == null || targetId.trim().isEmpty()) {
            response.put("duplicate", false);
            return ResponseEntity.ok(response);
        }

        boolean isDuplicate = userService.checkUsernameDuplicate(targetId.trim());
        response.put("duplicate", isDuplicate);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/register")
    public ResponseEntity<Map<String, String>> register(@RequestBody UserVO user) {
        Map<String, String> response = new HashMap<>();

        boolean success = userService.registerUser(user);

        if (success) {
            response.put("message", "success");
            return ResponseEntity.ok(response);
        } else {
            response.put("message", "error");
            return ResponseEntity.status(400).body(response);
        }
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(
            @RequestBody Map<String, String> loginRequest,
            jakarta.servlet.http.HttpServletRequest httpRequest,
            jakarta.servlet.http.HttpServletResponse response) {

        Map<String, Object> result = new HashMap<>();

        String username = loginRequest.get("username");
        String password = loginRequest.get("password");

        UserVO user = userService.loginUser(username, password);

        if (user != null) {
            // 페널티 만료일 유효성 체크 (현재 시간보다 미래인 경우 이용 제한)
            if (user.getPenaltyUntil() != null && user.getPenaltyUntil().after(new java.util.Date())) {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy.MM.dd");
                String formattedDate = sdf.format(user.getPenaltyUntil());
                String message = "현재 이용 제한 상태입니다! (" + formattedDate + "까지)";

                result.put("success", false);
                result.put("message", message);
                return ResponseEntity.ok(result);
            }

            // 🔐 2단계 인증(MFA) 활성화 여부 확인
            if (user.getMfaEnabled() != null && user.getMfaEnabled() == 1) {
                // 이메일로 4자리 OTP 발송 (제한 시간 없음)
                userService.sendMfaLoginCode(user.getUserId(), user.getEmail(), user.getUsername());

                /*
                 * [취약점 포인트: 2FA 세션 사전 생성 (Premature Session Creation / 2FA Direct Navigation Bypass)]
                 * 1단계 ID/PW 인증 성공 시점에 즉시 user_id 쿠키 및 정식 로그인 세션(JSESSIONID)을 발급하고
                 * 클라이언트를 /2fa 페이지로 리다이렉트시킴.
                 * -> 공격자가 2FA 인증 코드를 입력하지 않고 다른 탭에서 /profile 이나 /mypage 를 접속/새로고침하면
                 *    이미 브라우저에 구워진 세션 쿠키로 인해 2FA가 강제로 우회(Bypass)되어 로그인이 완료됨.
                 */
                applyFullLogin(user, httpRequest, response);

                String emailMasked = maskEmail(user.getEmail());
                String jwtToken = coms.fins.ojt.util.JwtTokenProvider.generateAccessToken(user.getUserId(), user.getUsername());

                result.put("success", true);
                result.put("mfa_required", true);
                result.put("message", "2단계 인증 코드가 이메일로 전송되었습니다.");
                result.put("user_id", user.getUserId());
                result.put("email", emailMasked);
                result.put("access_token", jwtToken);
                result.put("redirect_url", "/2fa");
                return ResponseEntity.ok(result);
            }

            // MFA 비활성화 상태: 즉시 로그인 완료 처리
            return applyFullLogin(user, httpRequest, response);
        } else {
            result.put("success", false);
            result.put("message", "아이디 또는 비밀번호가 올바르지 않습니다.");
            return ResponseEntity.ok(result);
        }
    }

    @RequestMapping(value = "/logout", method = {RequestMethod.POST, RequestMethod.GET})
    public ResponseEntity<Map<String, Boolean>> logout(
            jakarta.servlet.http.HttpServletRequest httpRequest,
            jakarta.servlet.http.HttpServletResponse response) {

        // 1. user_id 쿠키 제거 (Max-Age=0)
        org.springframework.http.ResponseCookie userCookie = org.springframework.http.ResponseCookie
                .from("user_id", "")
                .path("/")
                .maxAge(0)
                .sameSite("Lax")
                .httpOnly(true)
                .build();
        response.addHeader(org.springframework.http.HttpHeaders.SET_COOKIE, userCookie.toString());

        /*
         * [취약점: 로그아웃 시 서버 세션 미파기 (Session Not Invalidated)]
         * 클라이언트 쿠키만 제거하고, 서버 측 HttpSession(JSESSIONID)은 파기하지 않고 그대로 유지
         */

        Map<String, Boolean> result = new HashMap<>();
        result.put("success", true);
        return ResponseEntity.ok(result);
    }

    /**
     * 회원가입 이메일 코드 전송 API (/api/auth/send_code)
     */
    @PostMapping("/send_code")
    public ResponseEntity<Map<String, Object>> sendCode(@RequestBody(required = false) Map<String, String> requestBody) {
        Map<String, Object> response = new HashMap<>();
        String email = requestBody != null ? requestBody.get("email") : null;

        boolean success = userService.sendRegisterCode(email);
        response.put("success", success);
        if (success) {
            response.put("message", "인증 코드가 이메일로 발송되었습니다.");
        } else {
            response.put("message", "이메일 발송 실패. 이메일 주소를 확인해주세요.");
        }
        return ResponseEntity.ok(response);
    }

    /**
     * 이메일 코드 검증 API (/api/auth/valid_code)
     */
    @PostMapping("/valid_code")
    public ResponseEntity<Map<String, Object>> validCode(@RequestBody(required = false) Map<String, String> requestBody) {
        Map<String, Object> response = new HashMap<>();
        String email = requestBody != null ? requestBody.get("email") : null;
        String code = requestBody != null ? (requestBody.containsKey("code") ? requestBody.get("code") : requestBody.get("auth_code")) : null;

        boolean success = userService.verifyEmailCode(email, code);
        response.put("success", success);
        if (success) {
            response.put("message", "이메일 인증이 완료되었습니다.");
        } else {
            response.put("message", "인증 코드가 올바르지 않거나 만료되었습니다.");
        }
        return ResponseEntity.ok(response);
    }

    /**
     * 2단계 로그인(MFA) OTP 검증 API (POST /api/auth/mfa/verify)
     * [요구사항: 4자리 코드, 제한 시간 없음]
     */
    @PostMapping("/mfa/verify")
    public ResponseEntity<Map<String, Object>> verifyMfa(
            @RequestBody(required = false) Map<String, String> mfaRequest,
            jakarta.servlet.http.HttpServletRequest httpRequest,
            jakarta.servlet.http.HttpServletResponse response) {

        Map<String, Object> result = new HashMap<>();

        String code = mfaRequest != null ? mfaRequest.get("code") : null;
        String userIdStr = mfaRequest != null ? mfaRequest.get("user_id") : null;

        Long userId = null;
        if (userIdStr != null && !userIdStr.isBlank()) {
            try { userId = Long.parseLong(userIdStr.trim()); } catch (Exception ignored) {}
        }
        if (userId == null && httpRequest.getSession(false) != null) {
            Object pendingId = httpRequest.getSession(false).getAttribute("MFA_PENDING_USER_ID");
            if (pendingId instanceof Number) {
                userId = ((Number) pendingId).longValue();
            } else if (pendingId instanceof String) {
                try { userId = Long.parseLong((String) pendingId); } catch (Exception ignored) {}
            }
        }

        if (userId == null || code == null || code.isBlank()) {
            result.put("success", false);
            result.put("message", "인증 정보가 올바르지 않습니다.");
            return ResponseEntity.badRequest().body(result);
        }

        UserVO user = userService.getUserById(userId);
        if (user == null) {
            result.put("success", false);
            result.put("message", "존재하지 않는 회원입니다.");
            return ResponseEntity.badRequest().body(result);
        }

        boolean verified = userService.verifyMfaLoginCode(user.getEmail(), code.trim());
        if (!verified) {
            result.put("success", false);
            result.put("message", "인증 코드가 일치하지 않습니다.");
            return ResponseEntity.ok(result);
        }

        // 인증 성공 -> 정식 로그인 세션 및 쿠키 발급
        return applyFullLogin(user, httpRequest, response);
    }

    /**
     * 2단계 로그인(MFA) OTP 재발송 API (POST /api/auth/mfa/resend)
     */
    @PostMapping("/mfa/resend")
    public ResponseEntity<Map<String, Object>> resendMfa(
            @RequestBody(required = false) Map<String, String> body,
            jakarta.servlet.http.HttpServletRequest httpRequest) {

        Map<String, Object> result = new HashMap<>();
        String userIdStr = body != null ? body.get("user_id") : null;
        Long userId = null;
        if (userIdStr != null && !userIdStr.isBlank()) {
            try { userId = Long.parseLong(userIdStr.trim()); } catch (Exception ignored) {}
        }
        if (userId == null && httpRequest.getSession(false) != null) {
            Object pendingId = httpRequest.getSession(false).getAttribute("MFA_PENDING_USER_ID");
            if (pendingId instanceof Number) {
                userId = ((Number) pendingId).longValue();
            } else if (pendingId instanceof String) {
                try { userId = Long.parseLong((String) pendingId); } catch (Exception ignored) {}
            }
        }

        if (userId == null) {
            result.put("success", false);
            result.put("message", "인증 요청 정보가 존재하지 않습니다.");
            return ResponseEntity.badRequest().body(result);
        }

        UserVO user = userService.getUserById(userId);
        if (user != null) {
            userService.sendMfaLoginCode(user.getUserId(), user.getEmail(), user.getUsername());
            result.put("success", true);
            result.put("message", "인증 코드가 재발송되었습니다.");
            return ResponseEntity.ok(result);
        }

        result.put("success", false);
        result.put("message", "회원 정보를 찾을 수 없습니다.");
        return ResponseEntity.badRequest().body(result);
    }

    private ResponseEntity<Map<String, Object>> applyFullLogin(
            UserVO user,
            jakarta.servlet.http.HttpServletRequest httpRequest,
            jakarta.servlet.http.HttpServletResponse response) {

        Map<String, Object> result = new HashMap<>();

        // 1. user_id 쿠키 설정 (HttpOnly=true, SameSite=Lax 적용)
        org.springframework.http.ResponseCookie userCookie = org.springframework.http.ResponseCookie
                .from("user_id", String.valueOf(user.getUserId()))
                .path("/")
                .maxAge(60 * 60 * 24 * 7) // 7일 유지
                .sameSite("Lax")          // SameSite=Lax 적용
                .httpOnly(true)           // XSS 방지 (HttpOnly 적용)
                .build();
        response.addHeader(org.springframework.http.HttpHeaders.SET_COOKIE, userCookie.toString());

        // 2. HTTP 세션 (JSESSIONID) 생성 및 사용자 정보, 권한(role), CSRF 토큰 세션 저장
        jakarta.servlet.http.HttpSession session = httpRequest.getSession(true);
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("username", user.getUsername());
        session.setAttribute("name", user.getName());
        session.setAttribute("isAdmin", user.getIsAdmin() != null && user.getIsAdmin() == 1);
        session.setAttribute("isManager", user.getIsManager() != null && user.getIsManager() == 1);
        String role = (user.getIsAdmin() != null && user.getIsAdmin() == 1) ? "ROLE_ADMIN" 
                    : ((user.getIsManager() != null && user.getIsManager() == 1) ? "ROLE_MANAGER" : "ROLE_USER");
        session.setAttribute("role", role);
        session.setAttribute("user", user);

        String csrfToken = coms.fins.ojt.util.CsrfTokenManager.generateToken();
        session.setAttribute(coms.fins.ojt.util.CsrfTokenManager.SESSION_CSRF_KEY, csrfToken);

        // 3. RS256 서명 JWT 토큰 생성 (로컬스토리지 보관용)
        String jwtToken = coms.fins.ojt.util.JwtTokenProvider.generateAccessToken(user.getUserId(), user.getUsername());

        result.put("success", true);
        result.put("mfa_required", false);
        result.put("user_id", user.getUserId());
        result.put("role", role);
        result.put("access_token", jwtToken);
        result.put("token_type", "Bearer");
        result.put("csrfToken", csrfToken);
        result.put("redirect_url", "/mypage");
        return ResponseEntity.ok(result);
    }

    private String maskEmail(String email) {
        if (email == null || !email.contains("@")) return email;
        int atIndex = email.indexOf("@");
        String name = email.substring(0, atIndex);
        String domain = email.substring(atIndex);
        if (name.length() <= 2) {
            return name.charAt(0) + "*" + domain;
        }
        return name.substring(0, 2) + "***" + domain;
    }
}
