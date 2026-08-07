package coms.fins.ojt.controller;

import coms.fins.ojt.domain.MatchVO;
import coms.fins.ojt.service.MatchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.File;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@RestController
@RequestMapping("/api/matches")
public class MatchController {

    @Autowired
    private MatchService matchService;

    /**
     * 매치 목록 조회 / 검색 API (/api/matches)
     * 파라미터: is_end(마감여부), is_gender(성별), level(레벨), date(날짜), evening(저녁매치)
     */
    @GetMapping
    public ResponseEntity<List<MatchVO>> searchMatches(
            @RequestParam(value = "is_end", required = false) Integer isEnd,
            @RequestParam(value = "is_gender", required = false) String isGender,
            @RequestParam(value = "level", required = false) Integer level,
            @RequestParam(value = "date", required = false) String date,
            @RequestParam(value = "evening", required = false) String evening) {

        List<MatchVO> matches = matchService.searchMatches(isEnd, isGender, level, date, evening);
        return ResponseEntity.ok(matches);
    }

    @GetMapping("/{matchId}")
    public ResponseEntity<MatchVO> getMatchById(@PathVariable("matchId") String matchId) {
        MatchVO match = matchService.getMatchById(matchId);
        if (match != null) {
            return ResponseEntity.ok(match);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // 2. Command Injection: 구분자(;, |, &, `) 뒤의 OS 명령어 또는 Subshell $(...)
    private static final java.util.List<java.util.regex.Pattern> COMMAND_INJECTION_PATTERNS = java.util.List.of(
            java.util.regex.Pattern.compile("[;&|`]" + "\\s*" + "(cat|ls|whoami|id|pwd|nc|curl|wget|bash|cmd)", java.util.regex.Pattern.CASE_INSENSITIVE),
            java.util.regex.Pattern.compile("\\$\\([\\s\\S]*\\)", java.util.regex.Pattern.CASE_INSENSITIVE)
    );

    private boolean isCommandInjection(String input) {
        if (input == null || input.isBlank()) {
            return false;
        }
        for (java.util.regex.Pattern pattern : COMMAND_INJECTION_PATTERNS) {
            if (pattern.matcher(input).find()) {
                return true;
            }
        }
        return false;
    }

    @GetMapping("/{matchId}/highlight_download")
    public ResponseEntity<?> downloadHighlight(
            @PathVariable("matchId") String matchId,
            @RequestParam(value = "output_name", required = false) String outputName) {

        if (isCommandInjection(matchId) || isCommandInjection(outputName)) {
            java.util.Map<String, Object> errResp = new java.util.HashMap<>();
            errResp.put("success", false);
            errResp.put("message", "Command Injection 패턴이 감지되었습니다.");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errResp);
        }

        try {
            File videoFile = matchService.compressAndGetHighlightVideo(matchId, outputName);

            Resource resource = new FileSystemResource(videoFile);

            String downloadName = (outputName != null && !outputName.isBlank()) ? outputName.trim() : videoFile.getName();
            if (!downloadName.toLowerCase().endsWith(".mp4")) {
                downloadName += ".mp4";
            }

            String encodedFilename = URLEncoder.encode(downloadName, StandardCharsets.UTF_8).replaceAll("\\+", "%20");

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType("video/mp4"))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFilename + "\"; filename*=UTF-8''" + encodedFilename)
                    .body(resource);

        } catch (Exception e) {
            org.slf4j.LoggerFactory.getLogger(MatchController.class).error("영상 하이라이트 다운로드 예외 발생: ", e);
            java.util.Map<String, Object> errResp = new java.util.HashMap<>();
            errResp.put("success", false);

            java.io.StringWriter sw = new java.io.StringWriter();
            java.io.PrintWriter pw = new java.io.PrintWriter(sw);
            e.printStackTrace(pw);
            String fullStackTrace = sw.toString();

            errResp.put("error", fullStackTrace);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(errResp);
        }
    }
}
