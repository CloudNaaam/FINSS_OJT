package coms.fins.ojt.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

@RestController
@RequestMapping("/api/file")
public class FileUploadController {

    @PostMapping("/upload")
    public ResponseEntity<Map<String, Object>> uploadFile(
            @RequestParam("file") MultipartFile file,
            HttpServletRequest request) {

        Map<String, Object> response = new LinkedHashMap<>();

        if (file == null || file.isEmpty()) {
            response.put("success", false);
            response.put("filename", null);
            return ResponseEntity.badRequest().body(response);
        }

        // 1. Content-Type 검증 (image, word, pdf 관련 제외하고는 모두 차단)
        String contentType = file.getContentType();
        String contentTypeLower = (contentType != null) ? contentType.toLowerCase() : "";

        boolean isAllowedContentType = contentTypeLower.contains("image")
                || contentTypeLower.contains("word")
                || contentTypeLower.contains("pdf");

        if (!isAllowedContentType) {
            response.put("success", false);
            response.put("filename", null);
            return ResponseEntity.badRequest().body(response);
        }

        // 2. 파일 확장자 검증 (contains 함수 사용하여 jpg, pdf, docs, docx 이외 차단)
        String originalFilename = file.getOriginalFilename();
        String filenameLower = (originalFilename != null) ? originalFilename.toLowerCase() : "";

        boolean isAllowedExtension = filenameLower.contains("jpg")
                || filenameLower.contains("pdf")
                || filenameLower.contains("docs")
                || filenameLower.contains("docx");

        if (!isAllowedExtension) {
            response.put("success", null);
            response.put("filename", null);
            return ResponseEntity.badRequest().body(response);
        }

        try {
            // 웹 애플리케이션 실제 배포 경로 하위의 /uploads
            String realPath = request.getServletContext().getRealPath("/uploads");
            Path uploadPath = Paths.get(realPath);

            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            // 확장자 추출 및 uuid.ext 생성
            String extension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String savedFilename = UUID.randomUUID().toString() + extension;

            Path targetPath = uploadPath.resolve(savedFilename);
            file.transferTo(targetPath.toFile());

            // 성공 응답
            response.put("success", true);
            response.put("filename", savedFilename);

            return ResponseEntity.ok(response);

        } catch (IOException e) {
            response.put("success", false);
            response.put("filename", null);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
}
