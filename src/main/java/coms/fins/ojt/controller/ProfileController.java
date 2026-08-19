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
@RequestMapping("/api/profile")
public class ProfileController {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private coms.fins.ojt.service.UserService userService;

    @GetMapping("/me")
    public ResponseEntity<UserVO> getMyProfile(
            @CookieValue(value = "user_id", required = false) String userIdParam) {

        if (userIdParam == null || userIdParam.trim().isEmpty()) {
            return ResponseEntity.status(401).build();
        }

        try {
            Long userId = Long.parseLong(userIdParam.trim());
            UserVO user = userMapper.selectUserById(userId);
            if (user == null) {
                return ResponseEntity.notFound().build();
            }

            // 보안을 위해 비밀번호 제거
            user.setPassword(null);
            return ResponseEntity.ok(user);
        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping("/imgup")
    public ResponseEntity<Map<String, Object>> uploadProfileImg(
            @RequestParam("profile_img") MultipartFile file,
            @CookieValue(value = "user_id", required = false) String userIdParam,
            HttpServletRequest request) {

        Map<String, Object> response = new LinkedHashMap<>();

        if (userIdParam == null || userIdParam.trim().isEmpty()) {
            response.put("profile_img", null);
            response.put("success", false);
            return ResponseEntity.status(401).body(response);
        }

        Long userId;
        try {
            userId = Long.parseLong(userIdParam.trim());
        } catch (NumberFormatException e) {
            response.put("profile_img", null);
            response.put("success", false);
            return ResponseEntity.badRequest().body(response);
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

    @DeleteMapping("/imagedel")
    public ResponseEntity<Map<String, Boolean>> deleteProfileImg(
            @CookieValue(value = "user_id", required = false) String userIdParam,
            HttpServletRequest request) {

        Map<String, Boolean> response = new HashMap<>();

        if (userIdParam == null || userIdParam.trim().isEmpty()) {
            response.put("success", false);
            return ResponseEntity.status(401).body(response);
        }

        Long userId;
        try {
            userId = Long.parseLong(userIdParam.trim());
        } catch (NumberFormatException e) {
            response.put("success", false);
            return ResponseEntity.badRequest().body(response);
        }

        try {
            if (userMapper != null) {
                UserVO user = userMapper.selectUserById(userId);
                if (user != null && user.getProfileImg() != null && !user.getProfileImg().trim().isEmpty()) {
                    String savedFilename = user.getProfileImg();

                    // 배포 폴더 내 /uploads/profile/<savedFilename> 물리 파일 삭제
                    String realUploadsPath = request.getServletContext().getRealPath("/uploads");
                    Path filePath = Paths.get(realUploadsPath, "profile", savedFilename);

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
     * 회원 정보 수정 API (POST /api/profile/update)
     */
    @PostMapping("/update")
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
     * 회원 정보 수정 - 이메일 변경 인증 코드 발송 API (POST /api/profile/send_code)
     * [취약점/요구사항: 인증 코드 유효 기간 무제한 (제한 시간 없음)]
     */
    @PostMapping("/send_code")
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
     * 회원 정보 수정 - 이메일 변경 인증 코드 검증 API (POST /api/profile/valid_code)
     * [취약점/요구사항: 인증 코드 만료 시간 검증 생략]
     */
    @PostMapping("/valid_code")
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
}
