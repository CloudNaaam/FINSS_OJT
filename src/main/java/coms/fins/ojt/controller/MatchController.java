package coms.fins.ojt.controller;

import coms.fins.ojt.domain.MatchApplicationVO;
import coms.fins.ojt.domain.MatchVO;
import coms.fins.ojt.mapper.MatchMapper;
import coms.fins.ojt.service.MatchService;
import jakarta.servlet.http.HttpServletRequest;
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
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/matches")
public class MatchController {

    @Autowired
    private MatchService matchService;

    @Autowired
    private MatchMapper matchMapper;

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

    @GetMapping("/my")
    public ResponseEntity<List<MatchVO>> getMyMatches(
            @CookieValue(value = "user_id", required = false) String userIdCookie,
            HttpServletRequest request) {

        Long userId = null;
        if (userIdCookie != null && !userIdCookie.isBlank()) {
            try {
                userId = Long.parseLong(userIdCookie.trim());
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
            return ResponseEntity.status(401).body(List.of());
        }

        return ResponseEntity.ok(matchService.getMyAppliedMatches(userId));
    }

    @GetMapping("/{matchId}")
    public ResponseEntity<MatchVO> getMatchById(
            @PathVariable("matchId") String matchId,
            @CookieValue(value = "user_id", required = false) String userIdCookie,
            HttpServletRequest request) {

        MatchVO match = matchService.getMatchById(matchId);
        if (match == null) {
            return ResponseEntity.notFound().build();
        }

        Long userId = null;
        if (userIdCookie != null && !userIdCookie.isBlank()) {
            try {
                userId = Long.parseLong(userIdCookie.trim());
            } catch (NumberFormatException ignored) {}
        }
        if (userId == null) {
            String authHeader = request.getHeader("Authorization");
            String token = (authHeader != null && authHeader.startsWith("Bearer ")) ? authHeader.substring(7).trim() : request.getParameter("access_token");
            if (token != null && !token.isBlank()) {
                userId = coms.fins.ojt.util.JwtTokenProvider.getUserIdFromToken(token);
            }
        }

        boolean isApplied = (userId != null) && matchService.isUserApplied(matchId, userId);
        match.setIsApplied(isApplied);

        return ResponseEntity.ok(match);
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

    /**
     * API 1 — 매치 신청 시작
     * POST /api/matches/{matchId}/apply
     */
    @PostMapping("/{matchId}/apply")
    public ResponseEntity<Map<String, Object>> startApply(
            @PathVariable("matchId") String matchId,
            @CookieValue(value = "user_id", required = false) String userIdCookie,
            HttpServletRequest request) {

        Map<String, Object> response = new LinkedHashMap<>();

        // 1. 인증된 사용자 ID 판별
        Long userId = null;
        if (userIdCookie != null && !userIdCookie.isBlank()) {
            try {
                userId = Long.parseLong(userIdCookie.trim());
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

        // 2. 매치 존재 여부 및 참가비 확인
        int fee = 5000;
        try {
            MatchVO match = matchService.getMatchById(matchId);
            if (match != null && match.getPricePerHour() != null && match.getPricePerHour() > 0) {
                // 매치 가격이 지정된 경우 또는 기본 5,000P
                fee = 5000;
            }
        } catch (Exception ignored) {}

        // 3. 신청 번호 생성 및 match_application INSERT (status = READY)
        MatchApplicationVO application = matchService.startApplication(matchId, userId, fee);
        if (application == null) {
            response.put("success", false);
            response.put("message", "매치 신청 생성에 실패했습니다.");
            return ResponseEntity.badRequest().body(response);
        }

        response.put("success", true);
        response.put("application_id", application.getApplicationId());
        response.put("match_id", application.getMatchId());
        response.put("fee", application.getFee());
        response.put("status", application.getStatus());

        return ResponseEntity.ok(response);
    }

    /**
     * API 2 — 포인트 사용
     * POST /api/matches/apply/point
     * Request: { "application_id": "APP-10001" }
     */
    @PostMapping("/apply/point")
    public ResponseEntity<Map<String, Object>> usePoint(
            @RequestBody(required = false) Map<String, String> body) {

        Map<String, Object> response = new LinkedHashMap<>();

        if (body == null || body.get("application_id") == null || body.get("application_id").isBlank()) {
            response.put("success", false);
            response.put("message", "application_id가 필요합니다.");
            return ResponseEntity.badRequest().body(response);
        }

        String applicationId = body.get("application_id").trim();

        try {
            boolean success = matchService.usePoint(applicationId);
            if (success) {
                response.put("success", true);
                response.put("application_id", applicationId);
                response.put("status", "POINT_USED");
                response.put("message", "포인트 결제가 완료되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "포인트 결제 처리에 실패했습니다.");
                return ResponseEntity.badRequest().body(response);
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    /**
     * API 3 — 신청 완료 (취약 버전 구현)
     * POST /api/matches/apply/complete
     * Request: { "application_id": "APP-10001" }
     */
    @PostMapping("/apply/complete")
    public ResponseEntity<Map<String, Object>> completeApply(
            @RequestBody(required = false) Map<String, String> body) {

        Map<String, Object> response = new LinkedHashMap<>();

        if (body == null || body.get("application_id") == null || body.get("application_id").isBlank()) {
            response.put("success", false);
            response.put("message", "application_id가 필요합니다.");
            return ResponseEntity.badRequest().body(response);
        }

        String applicationId = body.get("application_id").trim();

        MatchApplicationVO application = matchMapper.selectApplication(applicationId);
        if (application == null) {
            response.put("success", false);
            response.put("message", "신청 정보를 찾을 수 없습니다.");
            return ResponseEntity.badRequest().body(response);
        }

        /*
         * [취약점: 비즈니스 프로세스 단계 검증 누락 (Missing Step Verification)]
         *
         * 1. POINT_USED 여부(포인트 차감 결제 성공 여부)를 확인하지 않음
         * 2. status == READY 상태에서도 곧바로 참가자 등록 및 COMPLETED 완료 처리
         */

        matchMapper.insertParticipant(application.getMatchId(), application.getUserId());
        matchMapper.updateApplicationStatus(applicationId, "COMPLETED");

        response.put("success", true);
        response.put("application_id", applicationId);
        response.put("match_id", application.getMatchId());
        response.put("status", "COMPLETED");
        response.put("message", "매치 신청이 성공적으로 완료되었습니다.");

        return ResponseEntity.ok(response);
    }
}

