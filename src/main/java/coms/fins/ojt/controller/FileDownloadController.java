package coms.fins.ojt.controller;

import coms.fins.ojt.domain.FileVO;
import coms.fins.ojt.mapper.FileMapper;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
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

    @Autowired
    private FileMapper fileMapper;

    @GetMapping("/download")
    public ResponseEntity<Resource> downloadFile(
            @RequestParam(value = "file", required = false) String fileParam,
            @RequestParam(value = "file_path", required = false) String filePathParam,
            HttpServletRequest request) {

        String fileUuid = (fileParam != null && !fileParam.isEmpty()) ? fileParam : filePathParam;

        if (fileUuid == null || fileUuid.trim().isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }

        // 1. 절대경로 검증 및 차단 (절대경로일 경우 HTTP 400 반환)
        Path inputPath = Paths.get(fileUuid);
        boolean isAbsolutePath = inputPath.isAbsolute()
                || fileUuid.startsWith("/")
                || fileUuid.startsWith("\\")
                || fileUuid.matches("^[a-zA-Z]:[\\\\/].*");

        if (isAbsolutePath) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }

        // 2. "../" 문자열 1회 치환 (python의 path.replace("../", "") 방식)
        fileUuid = fileUuid.replace("../", "");

        try {
            // 3. /uploads/board 배포 폴더 기준으로 파일 위치 탐색
            String realUploadsPath = request.getServletContext().getRealPath("/uploads");
            Path path = Paths.get(realUploadsPath, "board").resolve(fileUuid).normalize();

            File file = path.toFile();

            // 파일 존재 여부 검증
            if (!file.exists() || !file.isFile()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }

            // 4. DB에서 원본 파일명(original_filename) 조회
            String downloadFilename = file.getName();
            if (fileMapper != null) {
                FileVO fileVo = fileMapper.selectFileByUuid(fileUuid);
                if (fileVo != null && fileVo.getOriginalFilename() != null && !fileVo.getOriginalFilename().isEmpty()) {
                    downloadFilename = fileVo.getOriginalFilename();
                }
            }

            // 5. Spring Resource 객체 생성
            Resource resource = new FileSystemResource(file);

            // 6. 한글 파일명 브라우저 다운로드 깨짐 방지 인코딩
            String encodedFilename = UriUtils.encode(downloadFilename, StandardCharsets.UTF_8);

            // 7. 다운로드를 위한 Content-Disposition 헤더 생성
            ContentDisposition contentDisposition = ContentDisposition.builder("attachment")
                    .filename(encodedFilename)
                    .build();

            // 8. Content-Type 감지
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
