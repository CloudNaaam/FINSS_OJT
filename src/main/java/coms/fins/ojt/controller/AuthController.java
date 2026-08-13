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

            // 1. user_id 쿠키 설정 (HttpOnly=true, SameSite=Lax 적용)
            org.springframework.http.ResponseCookie userCookie = org.springframework.http.ResponseCookie
                    .from("user_id", String.valueOf(user.getUserId()))
                    .path("/")
                    .maxAge(60 * 60 * 24 * 7) // 7일 유지
                    .sameSite("Lax")          // SameSite=Lax 적용
                    .httpOnly(true)           // 💡 HttpOnly 적용
                    .build();
            response.addHeader(org.springframework.http.HttpHeaders.SET_COOKIE, userCookie.toString());

            // 구형 서블릿/브라우저 호환을 위한 서블릿 Cookie 객체 추가
            jakarta.servlet.http.Cookie stdCookie = new jakarta.servlet.http.Cookie("user_id", String.valueOf(user.getUserId()));
            stdCookie.setPath("/");
            stdCookie.setMaxAge(60 * 60 * 24 * 7);
            stdCookie.setHttpOnly(true);
            response.addCookie(stdCookie);

            // 2. HTTP 세션 생성 및 세션 전용 CSRF 토큰 발급
            jakarta.servlet.http.HttpSession session = httpRequest.getSession(true);
            String csrfToken = coms.fins.ojt.util.CsrfTokenManager.generateToken();
            session.setAttribute(coms.fins.ojt.util.CsrfTokenManager.SESSION_CSRF_KEY, csrfToken);

            // 3. RS256 서명 JWT 토큰 생성 (로컬스토리지 보관용)
            String jwtToken = coms.fins.ojt.util.JwtTokenProvider.generateAccessToken(user.getUserId(), user.getUsername());

            result.put("success", true);
            result.put("user_id", user.getUserId());
            result.put("access_token", jwtToken);
            result.put("token_type", "Bearer");
            result.put("csrfToken", csrfToken); // 세션 CSRF 토큰 반환
            return ResponseEntity.ok(result);
        } else {
            result.put("success", false);
            result.put("message", "아이디 또는 비밀번호가 올바르지 않습니다.");
            return ResponseEntity.ok(result);
        }
    }

    @PostMapping("/logout")
    public ResponseEntity<Map<String, Boolean>> logout(
            jakarta.servlet.http.HttpServletRequest httpRequest,
            jakarta.servlet.http.HttpServletResponse response) {

        // 1. user_id 쿠키 제거 (SameSite=Lax, HttpOnly=true)
        org.springframework.http.ResponseCookie userCookie = org.springframework.http.ResponseCookie
                .from("user_id", "")
                .path("/")
                .maxAge(0)
                .sameSite("Lax")
                .httpOnly(true)
                .build();
        response.addHeader(org.springframework.http.HttpHeaders.SET_COOKIE, userCookie.toString());

        // 2. 세션 및 세션 CSRF 토큰 완전 파기
        jakarta.servlet.http.HttpSession session = httpRequest.getSession(false);
        if (session != null) {
            session.invalidate();
        }

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
}
