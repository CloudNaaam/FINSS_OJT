package coms.fins.ojt.controller;

import coms.fins.ojt.mapper.FileMapper;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
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

    @Autowired
    private FileMapper fileMapper;

    @PostMapping("/upload")
    public ResponseEntity<Map<String, Object>> uploadFile(
            @RequestParam("file") MultipartFile file,
            HttpServletRequest request) {

        Map<String, Object> response = new LinkedHashMap<>();

        if (file == null || file.isEmpty()) {
            response.put("success", false);
            response.put("file_uuid", null);
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
            response.put("file_uuid", null);
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
            response.put("file_uuid", null);
            return ResponseEntity.badRequest().body(response);
        }

        try {
            // 웹 애플리케이션 실제 배포 경로 하위의 /uploads
            String realPath = request.getServletContext().getRealPath("/uploads");
            Path uploadPath = Paths.get(realPath);

            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            // 확장자 추출 및 소문자 통일 (리눅스 대소문자 404 에러 방지)
            String extension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf(".")).toLowerCase();
            }
            String savedFilename = UUID.randomUUID().toString() + extension;

            Path targetPath = uploadPath.resolve(savedFilename);
            file.transferTo(targetPath.toFile());

            // DB files 테이블에 file_uuid 및 original_filename 저장
            if (fileMapper != null) {
                fileMapper.insertFile(savedFilename, originalFilename != null ? originalFilename : savedFilename);
            }

            // 성공 응답 (file_uuid 및 original_filename 반환)
            response.put("success", true);
            response.put("file_uuid", savedFilename);
            response.put("original_filename", originalFilename);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("file_uuid", null);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
}
