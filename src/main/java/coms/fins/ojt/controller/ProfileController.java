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
}
