package coms.fins.ojt.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.UriUtils;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@RestController
@RequestMapping("/api/file")
public class FileDownloadController {

    @GetMapping("/download")
    public ResponseEntity<Resource> downloadFile(
            @RequestParam("file_path") String filePath,
            HttpServletRequest request) {

        // Path Traversal 방지: ../ 문자열 필터링 (차단 시 400 Bad Request 반환)
        if (filePath == null || filePath.contains("../")) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }

        try {
            // 1. 전달받은 file_path로 파일 위치 탐색
            Path path = Paths.get(filePath);

            // 입력값이 파일명만 있거나 상대 경로인 경우 /uploads 배포 폴더 기준으로 조회
            if (!path.isAbsolute() || !Files.exists(path)) {
                String realUploadsPath = request.getServletContext().getRealPath("/uploads");
                path = Paths.get(realUploadsPath).resolve(filePath).normalize();
            }

            File file = path.toFile();

            // 파일 존재 여부 검증
            if (!file.exists() || !file.isFile()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }

            // 2. Spring Resource 객체 생성
            Resource resource = new FileSystemResource(file);

            // 3. 한글 파일명 브라우저 다운로드 깨짐 방지 인코딩
            String encodedFilename = UriUtils.encode(file.getName(), StandardCharsets.UTF_8);

            // 4. 다운로드를 위한 Content-Disposition 헤더 생성
            ContentDisposition contentDisposition = ContentDisposition.builder("attachment")
                    .filename(encodedFilename)
                    .build();

            // 5. Content-Type 감지
            String contentType = Files.probeContentType(path);
            if (contentType == null) {
                contentType = MediaType.APPLICATION_OCTET_STREAM_VALUE;
            }

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .header(HttpHeaders.CONTENT_DISPOSITION, contentDisposition.toString())
                    .contentLength(file.length())
                    .body(resource);

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
