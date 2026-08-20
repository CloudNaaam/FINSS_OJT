package coms.fins.ojt.controller;

import coms.fins.ojt.domain.UserVO;
import coms.fins.ojt.mapper.UserMapper;
import coms.fins.ojt.util.FileUtil;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

@RestController
@RequestMapping("/api")
public class ProfileController {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private coms.fins.ojt.service.UserService userService;

    /**
     * 내 프로필 정보 조회 API (GET /api/me 및 GET /api/profile/me)
     * [취약점/요구사항: 비밀번호 마스킹 없이 그대로 반환]
     */
    @GetMapping({"/me", "/profile/me"})
    public ResponseEntity<UserVO> getMyProfile(
            @CookieValue(value = "user_id", required = false) String userIdParam,
            HttpServletRequest request) {

        Long userId = null;
        if (userIdParam != null && !userIdParam.trim().isEmpty()) {
            try {
                userId = Long.parseLong(userIdParam.trim());
            } catch (NumberFormatException ignored) {}
        }
        if (userId == null && request.getSession(false) != null) {
            Object sUserId = request.getSession(false).getAttribute("userId");
            if (sUserId instanceof Number) {
                userId = ((Number) sUserId).longValue();
            } else if (sUserId instanceof String) {
                try { userId = Long.parseLong((String) sUserId); } catch (Exception ignored) {}
            }
            if (userId == null) {
                Object sUser = request.getSession(false).getAttribute("user");
                if (sUser instanceof UserVO) {
                    userId = ((UserVO) sUser).getUserId();
                }
            }
        }
        if (userId == null) {
            String authHeader = request.getHeader("Authorization");
            String token = (authHeader != null && authHeader.startsWith("Bearer ")) ? authHeader.substring(7).trim() : request.getParameter("access_token");
            if (token != null && !token.isBlank()) {
                userId = coms.fins.ojt.util.JwtTokenProvider.getUserIdFromToken(token);
            }
        }

        if (userId == null) {
            return ResponseEntity.status(401).build();
        }

        try {
            UserVO user = userMapper.selectUserById(userId);
            if (user == null) {
                return ResponseEntity.notFound().build();
            }

            /*
             * [요구사항 / 취약점 실습 포인트]
             * 비밀번호를 마스킹하거나 제거(null)하지 않고 DB 저장 값 그대로 노출
             */

            return ResponseEntity.ok(user);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping({"/imgup", "/profile/imgup"})
    public ResponseEntity<Map<String, Object>> uploadProfileImg(
            @RequestParam("profile_img") MultipartFile file,
            @CookieValue(value = "user_id", required = false) String userIdParam,
            HttpServletRequest request) {

        Map<String, Object> response = new LinkedHashMap<>();

        Long userId = null;
        if (userIdParam != null && !userIdParam.trim().isEmpty()) {
            try {
                userId = Long.parseLong(userIdParam.trim());
            } catch (NumberFormatException ignored) {}
        }
        if (userId == null && request.getSession(false) != null) {
            userId = (Long) request.getSession(false).getAttribute("userId");
        }

        if (userId == null) {
            response.put("profile_img", null);
            response.put("success", false);
            return ResponseEntity.status(401).body(response);
        }

        if (file == null || file.isEmpty()) {
            response.put("profile_img", null);
            response.put("success", false);
            return ResponseEntity.badRequest().body(response);
        }

        // 1. MIME Type 검증 (jpg, jpeg, png 만 허용)
        String contentType = file.getContentType();
        String contentTypeLower = (contentType != null) ? contentType.toLowerCase() : "";

        boolean isAllowedMime = contentTypeLower.contains("jpeg")
                || contentTypeLower.contains("jpg")
                || contentTypeLower.contains("png");

        // 2. 확장자 검증 (.jpg, .jpeg, .png 만 허용)
        String originalFilename = file.getOriginalFilename();
        String filenameLower = (originalFilename != null) ? originalFilename.toLowerCase() : "";

        boolean isAllowedExt = filenameLower.endsWith(".jpg")
                || filenameLower.endsWith(".jpeg")
                || filenameLower.endsWith(".png");

        if (!isAllowedMime || !isAllowedExt) {
            response.put("profile_img", null);
            response.put("success", false);
            return ResponseEntity.badRequest().body(response);
        }

        // 3. 매직 바이트 (파일 시그니처 바이너리) 검증
        if (!FileUtil.isValidMagicByte(file)) {
            response.put("profile_img", null);
            response.put("success", false);
            return ResponseEntity.badRequest().body(response);
        }

        try {
            // 업로드 폴더/profile 디렉터리 경로 설정
            String realUploadsPath = request.getServletContext().getRealPath("/uploads");
            Path profileDir = Paths.get(realUploadsPath, "profile");

            if (!Files.exists(profileDir)) {
                Files.createDirectories(profileDir);
            }

            // 확장자 추출 및 UUID 파일명 생성
            String savedFilename = FileUtil.generateSavedFilename(originalFilename);

            Path targetPath = profileDir.resolve(savedFilename);
            file.transferTo(targetPath.toFile());

            // upload부터 시작하는 경로 생성
            String profileImgPath = "/uploads/profile/" + savedFilename;

            // users 테이블 profile_img 컬럼 업데이트
            if (userMapper != null) {
                userMapper.updateUserProfileImg(userId, savedFilename);
            }

            response.put("profile_img", profileImgPath);
            response.put("success", true);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("profile_img", null);
            response.put("success", false);
            return ResponseEntity.internalServerError().body(response);
        }
    }

    @DeleteMapping({"/imagedel", "/profile/imagedel"})
    public ResponseEntity<Map<String, Boolean>> deleteProfileImg(
            @CookieValue(value = "user_id", required = false) String userIdParam,
            HttpServletRequest request) {

        Map<String, Boolean> response = new HashMap<>();

        Long userId = null;
        if (userIdParam != null && !userIdParam.trim().isEmpty()) {
            try {
                userId = Long.parseLong(userIdParam.trim());
            } catch (NumberFormatException ignored) {}
        }
        if (userId == null && request.getSession(false) != null) {
            Object sUserId = request.getSession(false).getAttribute("userId");
            if (sUserId instanceof Number) {
                userId = ((Number) sUserId).longValue();
            } else if (sUserId instanceof String) {
                try { userId = Long.parseLong((String) sUserId); } catch (Exception ignored) {}
            }
            if (userId == null) {
                Object sUser = request.getSession(false).getAttribute("user");
                if (sUser instanceof UserVO) {
                    userId = ((UserVO) sUser).getUserId();
                }
            }
        }

        if (userId == null) {
            response.put("success", false);
            return ResponseEntity.status(401).body(response);
        }

        try {
            UserVO user = userMapper.selectUserById(userId);
            if (user != null && user.getProfileImg() != null) {
                String profileImg = user.getProfileImg();
                String realUploadsPath = request.getServletContext().getRealPath("/uploads");
                Path filePath = Paths.get(realUploadsPath, "profile", profileImg);

                if (Files.exists(filePath)) {
                    Files.deleteIfExists(filePath);

                    // users 테이블 profile_img 컬럼 값 NULL 초기화
                    userMapper.updateUserProfileImg(userId, null);

                    response.put("success", true);
                    return ResponseEntity.ok(response);
                }
            }

            // 삭제 대상 이미지가 없거나 이미 삭제된 경우
            response.put("success", false);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            return ResponseEntity.internalServerError().body(response);
        }
    }

    /**
     * 회원 정보 수정 API (POST /api/profile/update 및 POST /api/update)
     */
    @PostMapping({"/update", "/profile/update"})
    public ResponseEntity<Map<String, Object>> updateProfile(
            @RequestBody(required = false) Map<String, Object> body,
            @CookieValue(value = "user_id", required = false) String userIdParam,
            HttpServletRequest request) {

        Map<String, Object> response = new LinkedHashMap<>();

        Long userId = null;
        if (userIdParam != null && !userIdParam.isBlank()) {
            try {
                userId = Long.parseLong(userIdParam.trim());
            } catch (NumberFormatException ignored) {}
        }
        if (userId == null && request.getSession(false) != null) {
            Object sUserId = request.getSession(false).getAttribute("userId");
            if (sUserId instanceof Number) {
                userId = ((Number) sUserId).longValue();
            } else if (sUserId instanceof String) {
                try { userId = Long.parseLong((String) sUserId); } catch (Exception ignored) {}
            }
            if (userId == null) {
                Object sUser = request.getSession(false).getAttribute("user");
                if (sUser instanceof UserVO) {
                    userId = ((UserVO) sUser).getUserId();
                }
            }
        }
        if (userId == null) {
            String authHeader = request.getHeader("Authorization");
            String token = (authHeader != null && authHeader.startsWith("Bearer ")) ? authHeader.substring(7).trim() : request.getParameter("access_token");
            if (token != null && !token.isBlank()) {
                userId = coms.fins.ojt.util.JwtTokenProvider.getUserIdFromToken(token);
            }
        }

        if (userId == null) {
            response.put("success", false);
            response.put("message", "로그인이 필요한 서비스입니다.");
            return ResponseEntity.status(401).body(response);
        }

        if (body == null || body.isEmpty()) {
            response.put("success", false);
            response.put("message", "수정할 데이터가 전달되지 않았습니다.");
            return ResponseEntity.badRequest().body(response);
        }

        try {
            UserVO user = new UserVO();
            user.setUserId(userId);

            if (body.containsKey("name")) {
                user.setName(String.valueOf(body.get("name")).trim());
            }

            if (body.containsKey("email")) {
                String newEmail = String.valueOf(body.get("email")).trim();
                user.setEmail(newEmail);

                // 기존 이메일과 달라진 경우: 변경 대상 이메일 인증 여부 검증
                UserVO currentUser = userMapper.selectUserById(userId);
                if (currentUser != null && currentUser.getEmail() != null && !currentUser.getEmail().equalsIgnoreCase(newEmail)) {
                    boolean isVerified = (userService != null) && userService.isEmailVerified(newEmail);
                    if (!isVerified) {
                        response.put("success", false);
                        response.put("message", "새 이메일 인증이 완료되지 않았습니다. 인증 코드를 먼저 확인해주세요.");
                        return ResponseEntity.badRequest().body(response);
                    }
                }
            }

            if (body.containsKey("phone_number")) {
                user.setPhoneNumber(String.valueOf(body.get("phone_number")).trim());
            }
            if (body.containsKey("age") && body.get("age") != null && !String.valueOf(body.get("age")).isBlank()) {
                try {
                    user.setAge(Integer.parseInt(String.valueOf(body.get("age")).trim()));
                } catch (NumberFormatException ignored) {}
            }
            if (body.containsKey("gender")) {
                user.setGender(String.valueOf(body.get("gender")).trim());
            }
            if (body.containsKey("password") && body.get("password") != null) {
                String pwd = String.valueOf(body.get("password")).trim();
                if (!pwd.isBlank()) {
                    user.setPassword(pwd);
                }
            }

            int rows = userMapper.updateUserProfile(user);
            if (rows > 0) {
                response.put("success", true);
                response.put("message", "회원 정보가 성공적으로 수정되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "회원 정보 수정에 실패했습니다.");
                return ResponseEntity.badRequest().body(response);
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "정보 수정 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }

    /**
     * 회원 정보 수정 - 이메일 변경 인증 코드 발송 API (POST /api/profile/send_code 및 POST /api/send_code)
     * [취약점/요구사항: 인증 코드 유효 기간 무제한 (제한 시간 없음)]
     */
    @PostMapping({"/send_code", "/profile/send_code"})
    public ResponseEntity<Map<String, Object>> sendEmailCode(
            @RequestBody(required = false) Map<String, String> requestBody,
            @CookieValue(value = "user_id", required = false) String userIdParam) {

        Map<String, Object> response = new LinkedHashMap<>();
        String email = requestBody != null ? requestBody.get("email") : null;

        if (email == null || email.isBlank()) {
            response.put("success", false);
            response.put("message", "이메일 주소를 입력해주세요.");
            return ResponseEntity.badRequest().body(response);
        }

        Long userId = null;
        if (userIdParam != null && !userIdParam.isBlank()) {
            try {
                userId = Long.parseLong(userIdParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        boolean success = (userService != null) && userService.sendProfileEmailCode(userId, email.trim());
        response.put("success", success);
        if (success) {
            response.put("message", "인증 코드가 입력하신 이메일로 발송되었습니다.");
        } else {
            response.put("message", "인증 코드 발송에 실패했습니다. 이메일 주소를 확인해주세요.");
        }
        return ResponseEntity.ok(response);
    }

    /**
     * 회원 정보 수정 - 이메일 변경 인증 코드 검증 API (POST /api/profile/valid_code 및 POST /api/valid_code)
     * [취약점/요구사항: 인증 코드 만료 시간 검증 생략]
     */
    @PostMapping({"/valid_code", "/profile/valid_code"})
    public ResponseEntity<Map<String, Object>> validEmailCode(
            @RequestBody(required = false) Map<String, String> requestBody) {

        Map<String, Object> response = new LinkedHashMap<>();
        String email = requestBody != null ? requestBody.get("email") : null;
        String code = requestBody != null ? (requestBody.containsKey("code") ? requestBody.get("code") : requestBody.get("auth_code")) : null;

        if (email == null || email.isBlank() || code == null || code.isBlank()) {
            response.put("success", false);
            response.put("message", "이메일과 인증 코드를 모두 입력해주세요.");
            return ResponseEntity.badRequest().body(response);
        }

        boolean success = (userService != null) && userService.verifyProfileEmailCode(email.trim(), code.trim());
        response.put("success", success);
        if (success) {
            response.put("message", "이메일 인증이 완료되었습니다.");
        } else {
            response.put("message", "인증 코드가 올바르지 않습니다.");
        }
        return ResponseEntity.ok(response);
    }

    /**
     * 회원 탈퇴 (계정 삭제) API
     * POST/DELETE /api/profile/withdraw 및 POST/DELETE /api/withdraw
     */
    @RequestMapping(value = {"/withdraw", "/delete", "/profile/withdraw", "/profile/delete"}, method = {RequestMethod.POST, RequestMethod.DELETE})
    public ResponseEntity<Map<String, Object>> withdrawAccount(
            @CookieValue(value = "user_id", required = false) String userIdParam,
            HttpServletRequest request,
            jakarta.servlet.http.HttpServletResponse response) {

        Map<String, Object> result = new LinkedHashMap<>();

        Long userId = null;
        if (userIdParam != null && !userIdParam.isBlank()) {
            try {
                userId = Long.parseLong(userIdParam.trim());
            } catch (NumberFormatException ignored) {}
        }
        if (userId == null) {
            String authHeader = request.getHeader("Authorization");
            String token = (authHeader != null && authHeader.startsWith("Bearer ")) ? authHeader.substring(7).trim() : request.getParameter("access_token");
            if (token != null && !token.isBlank()) {
                userId = coms.fins.ojt.util.JwtTokenProvider.getUserIdFromToken(token);
            }
        }
        if (userId == null && request.getSession(false) != null) {
            userId = (Long) request.getSession(false).getAttribute("userId");
        }

        if (userId == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요한 서비스입니다.");
            return ResponseEntity.status(401).body(result);
        }

        try {
            boolean deleted = (userService != null) && userService.deleteAccount(userId);
            if (deleted) {
                // 1. user_id 쿠키 삭제
                org.springframework.http.ResponseCookie userCookie = org.springframework.http.ResponseCookie
                        .from("user_id", "")
                        .path("/")
                        .maxAge(0)
                        .sameSite("Lax")
                        .httpOnly(true)
                        .build();
                response.addHeader(org.springframework.http.HttpHeaders.SET_COOKIE, userCookie.toString());

                // 2. 세션 무효화
                jakarta.servlet.http.HttpSession session = request.getSession(false);
                if (session != null) {
                    session.invalidate();
                }

                result.put("success", true);
                result.put("message", "회원 탈퇴가 성공적으로 완료되었습니다.");
                result.put("redirect_url", "/login");
                return ResponseEntity.ok(result);
            } else {
                result.put("success", false);
                result.put("message", "회원 탈퇴 처리에 실패했습니다.");
                return ResponseEntity.badRequest().body(result);
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "회원 탈퇴 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.internalServerError().body(result);
        }
    }

    /**
     * MFA(2단계 인증) 활성화/비활성화 설정 API (POST /api/profile/mfa 및 POST /api/mfa)
     */
    @PostMapping({"/mfa", "/profile/mfa"})
    public ResponseEntity<Map<String, Object>> toggleMfa(
            @RequestBody(required = false) Map<String, Object> body,
            @CookieValue(value = "user_id", required = false) String userIdParam,
            HttpServletRequest request) {

        Map<String, Object> result = new LinkedHashMap<>();

        Long userId = null;
        if (userIdParam != null && !userIdParam.isBlank()) {
            try {
                userId = Long.parseLong(userIdParam.trim());
            } catch (NumberFormatException ignored) {}
        }
        if (userId == null && request.getSession(false) != null) {
            Object sUserId = request.getSession(false).getAttribute("userId");
            if (sUserId instanceof Number) {
                userId = ((Number) sUserId).longValue();
            } else if (sUserId instanceof String) {
                try { userId = Long.parseLong((String) sUserId); } catch (Exception ignored) {}
            }
        }
        if (userId == null) {
            String authHeader = request.getHeader("Authorization");
            String token = (authHeader != null && authHeader.startsWith("Bearer ")) ? authHeader.substring(7).trim() : request.getParameter("access_token");
            if (token != null && !token.isBlank()) {
                userId = coms.fins.ojt.util.JwtTokenProvider.getUserIdFromToken(token);
            }
        }

        if (userId == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요한 서비스입니다.");
            return ResponseEntity.status(401).body(result);
        }

        int mfaEnabled = 0;
        if (body != null) {
            if (body.get("mfa_enabled") instanceof Number) {
                mfaEnabled = ((Number) body.get("mfa_enabled")).intValue();
            } else if (body.get("mfa_enabled") instanceof Boolean) {
                mfaEnabled = ((Boolean) body.get("mfa_enabled")) ? 1 : 0;
            } else if (body.get("mfa_enabled") instanceof String) {
                try {
                    mfaEnabled = Integer.parseInt((String) body.get("mfa_enabled"));
                } catch (Exception ignored) {
                    mfaEnabled = "true".equalsIgnoreCase((String) body.get("mfa_enabled")) ? 1 : 0;
                }
            }
        }

        boolean success = userService.setMfaEnabled(userId, mfaEnabled);
        if (success) {
            // 세션 내 user 객체 갱신
            if (request.getSession(false) != null) {
                Object sUser = request.getSession(false).getAttribute("user");
                if (sUser instanceof UserVO) {
                    ((UserVO) sUser).setMfaEnabled(mfaEnabled);
                }
            }
            result.put("success", true);
            result.put("mfa_enabled", mfaEnabled);
            result.put("message", mfaEnabled == 1 ? "2단계 인증(MFA)이 설정되었습니다." : "2단계 인증(MFA)이 해제되었습니다.");
            return ResponseEntity.ok(result);
        } else {
            result.put("success", false);
            result.put("message", "2단계 인증 설정 변경에 실패했습니다.");
            return ResponseEntity.badRequest().body(result);
        }
    }
}
