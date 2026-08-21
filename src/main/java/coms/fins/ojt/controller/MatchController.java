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
        if (userId == null && request.getSession(false) != null) {
            userId = (Long) request.getSession(false).getAttribute("userId");
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
        if (userId == null && request.getSession(false) != null) {
            userId = (Long) request.getSession(false).getAttribute("userId");
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
        if (userId == null && request.getSession(false) != null) {
            userId = (Long) request.getSession(false).getAttribute("userId");
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
     * Request: { "application_id": "APP-10001", "fee": 1 }
     * [취약점: fee 또는 custom_fee 파라미터를 임의로 낮추어(예: 1P, 0P) 결제 가능]
     */
    @PostMapping("/apply/point")
    public ResponseEntity<Map<String, Object>> usePoint(
            @RequestBody(required = false) Map<String, Object> body) {

        Map<String, Object> response = new LinkedHashMap<>();

        if (body == null || body.get("application_id") == null || String.valueOf(body.get("application_id")).isBlank()) {
            response.put("success", false);
            response.put("message", "application_id가 필요합니다.");
            return ResponseEntity.badRequest().body(response);
        }

        String applicationId = String.valueOf(body.get("application_id")).trim();

        // 💥 [취약점 포인트: 참가비 변조 (Fee Tampering)]
        Integer customFee = null;
        Object feeObj = body.containsKey("fee") ? body.get("fee") : (body.containsKey("custom_fee") ? body.get("custom_fee") : body.get("pay_amount"));
        if (feeObj != null) {
            try {
                customFee = Integer.parseInt(String.valueOf(feeObj).trim());
            } catch (NumberFormatException ignored) {}
        }

        try {
            boolean success = matchService.usePoint(applicationId, customFee);
            if (success) {
                MatchApplicationVO app = matchService.getApplication(applicationId);
                response.put("success", true);
                response.put("application_id", applicationId);
                response.put("status", "POINT_USED");
                response.put("paid_fee", (app != null) ? app.getFee() : (customFee != null ? customFee : 5000));
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
     * API 3 — 신청 완료
     * POST /api/matches/apply/complete
     * Request: { "application_id": "APP-10001" }
     * [방어 조치: POINT_USED 단계 검증을 엄격히 수행하여 결제 건너뛰기 차단]
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

        // 🛡️ [겉보기 보안 조치]: 이전의 '결제 건너뛰기'를 엄격히 차단!
        if (!"POINT_USED".equalsIgnoreCase(application.getStatus())) {
            response.put("success", false);
            response.put("message", "포인트 결제(POINT_USED) 단계가 완료되지 않은 신청입니다. 결제를 먼저 진행해 주세요.");
            return ResponseEntity.badRequest().body(response);
        }

        matchMapper.insertParticipant(application.getMatchId(), application.getUserId());
        matchMapper.updateApplicationStatus(applicationId, "COMPLETED");

        response.put("success", true);
        response.put("application_id", applicationId);
        response.put("match_id", application.getMatchId());
        response.put("status", "COMPLETED");
        response.put("message", "매치 신청이 성공적으로 완료되었습니다.");

        return ResponseEntity.ok(response);
    }

    /**
     * API 4 — 매치 신청 취소 및 환불
     * POST /api/matches/cancel 또는 POST /api/matches/apply/cancel
     * Request: { "application_id": "APP-10001", "match_id": "1" }
     * [취약점: 실제 지불한 포인트(1P)가 아닌 매치 기본 정가(5,000P)를 무조건 환불하여 포인트 무한 복사 발생]
     */
    @PostMapping({"/cancel", "/apply/cancel"})
    public ResponseEntity<Map<String, Object>> cancelApply(
            @RequestBody(required = false) Map<String, String> body,
            @CookieValue(value = "user_id", required = false) String userIdCookie,
            HttpServletRequest request) {

        Map<String, Object> response = new LinkedHashMap<>();

        Long userId = null;
        if (userIdCookie != null && !userIdCookie.isBlank()) {
            try { userId = Long.parseLong(userIdCookie.trim()); } catch (Exception ignored) {}
        }
        if (userId == null && request.getSession(false) != null) {
            userId = (Long) request.getSession(false).getAttribute("userId");
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

        String applicationId = body != null ? body.get("application_id") : null;
        String matchId = body != null ? body.get("match_id") : null;

        try {
            int refundAmount = matchService.cancelApplication(applicationId, matchId, userId);
            response.put("success", true);
            response.put("refund_point", refundAmount);
            response.put("message", "매치 신청이 성공적으로 취소되었으며, " + refundAmount + "P가 환불되었습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "매치 취소 처리 실패: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}

