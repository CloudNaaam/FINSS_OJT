package coms.fins.ojt.controller;

import coms.fins.ojt.domain.BoardVO;
import coms.fins.ojt.domain.UserVO;
import coms.fins.ojt.mapper.BoardMapper;
import coms.fins.ojt.mapper.UserMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@RestController
public class AdminController {

    private static final Logger logger = LoggerFactory.getLogger(AdminController.class);

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private BoardMapper boardMapper;

    /**
     * 1. 회원 정지 API (/api/admin/{userId}/penalty 및 /api/admin/penalty)
     * [취약점/보안 요구사항: X-Forwarded-For 헤더가 192.168.21.218 인 경우에만 접근 허용]
     * 예: /api/admin/12/penalty?until=2026-08-25 또는 POST /api/admin/penalty
     */
    @RequestMapping(value = {"/api/admin/{userId}/penalty", "/api/admin/penalty"}, method = {RequestMethod.GET, RequestMethod.POST})
    public ResponseEntity<Map<String, Object>> setPenalty(
            @PathVariable(value = "userId", required = false) Long pathUserId,
            @RequestParam(value = "user_id", required = false) Long queryUserId,
            @RequestParam(value = "userId", required = false) Long queryUserId2,
            @RequestParam(value = "suspended_until", required = false) String suspendedUntilParam,
            @RequestParam(value = "until", required = false) String untilParam,
            @RequestBody(required = false) Map<String, Object> body,
            jakarta.servlet.http.HttpServletRequest request) {

        Map<String, Object> response = new HashMap<>();

        // 🛡️ X-Forwarded-For 헤더 검증: 192.168.21.218 대역만 허용
        String xff = request.getHeader("X-Forwarded-For");
        boolean isAllowedIp = (xff != null && !xff.isBlank() && xff.contains("192.168.21.218"));

        if (!isAllowedIp) {
            response.put("success", false);
            response.put("message", "접근 권한이 없습니다. 관리자 허용 IP에서만 접근 가능합니다.");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
        }

        Long userId = pathUserId != null ? pathUserId : (queryUserId != null ? queryUserId : queryUserId2);
        if (userId == null && body != null) {
            Object idObj = body.containsKey("user_id") ? body.get("user_id") : body.get("userId");
            if (idObj instanceof Number) {
                userId = ((Number) idObj).longValue();
            } else if (idObj instanceof String && !((String) idObj).isBlank()) {
                try {
                    userId = Long.parseLong(((String) idObj).trim());
                } catch (NumberFormatException ignored) {}
            }
        }

        if (userId == null) {
            response.put("success", false);
            response.put("message", "대상 회원 ID(user_id)를 지정해주세요.");
            return ResponseEntity.badRequest().body(response);
        }

        String targetUntilStr = (suspendedUntilParam != null && !suspendedUntilParam.isBlank()) 
                ? suspendedUntilParam : untilParam;
        if (targetUntilStr == null && body != null) {
            Object uObj = body.containsKey("suspended_until") ? body.get("suspended_until") : body.get("until");
            if (uObj != null) targetUntilStr = String.valueOf(uObj);
        }

        if (userMapper == null) {
            response.put("success", false);
            response.put("message", "Database mapper error");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }

        UserVO targetUser = userMapper.selectUserById(userId);
        if (targetUser == null) {
            response.put("success", false);
            response.put("message", "존재하지 않는 회원입니다. (userId=" + userId + ")");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        }

        Date penaltyUntilDate = null;
        if (targetUntilStr != null && !targetUntilStr.isBlank() && !"clear".equalsIgnoreCase(targetUntilStr.trim())) {
            String trimmed = targetUntilStr.trim();
            penaltyUntilDate = parseMultiDateFormat(trimmed);

            if (penaltyUntilDate == null) {
                response.put("success", false);
                response.put("message", "올바르지 않은 날짜 형식을 입력했습니다. (예: YYYY-MM-DD 또는 YYYY-MM-DD HH:mm:ss)");
                return ResponseEntity.badRequest().body(response);
            }
        }

        int updated = userMapper.updateUserPenalty(userId, penaltyUntilDate);
        boolean success = updated > 0;

        response.put("success", success);
        response.put("user_id", userId);
        response.put("username", targetUser.getUsername());

        if (penaltyUntilDate != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            response.put("penalty_until", sdf.format(penaltyUntilDate));
            response.put("message", "회원 이용 정지 처리가 완료되었습니다.");
        } else {
            response.put("penalty_until", null);
            response.put("message", "회원 이용 정지가 해제되었습니다.");
        }

        return ResponseEntity.ok(response);
    }

    /**
     * 2. 회원 목록 및 검색 조회 API (GET /api/users?q=)
     */
    @GetMapping("/api/users")
    public ResponseEntity<List<UserVO>> getUsers(
            @RequestParam(value = "q", required = false) String query) {

        if (userMapper == null) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        List<UserVO> list;
        if (query != null && !query.isBlank()) {
            list = userMapper.searchUsers(query.trim());
        } else {
            list = userMapper.searchUsers(""); // 전체 유저 검색
        }

        if (list != null) {
            for (UserVO u : list) {
                u.setPassword(null); // 비밀번호 보안 처리
            }
        } else {
            list = Collections.emptyList();
        }

        return ResponseEntity.ok(list);
    }

    /**
     * 3. 회원 상세 조회 API (GET /api/user/{user_id})
     */
    @GetMapping("/api/user/{userId}")
    public ResponseEntity<Object> getUserDetail(@PathVariable("userId") Long userId) {
        if (userMapper == null) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }

        UserVO user = userMapper.selectUserById(userId);
        if (user == null) {
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", "존재하지 않는 회원입니다.");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(err);
        }

        user.setPassword(null); // 비밀번호 보안 처리
        return ResponseEntity.ok(user);
    }

    /**
     * 4. 대시보드 현황 집계 API (GET /api/admin/stats)
     * 반환: { "total_users": X, "penalized_users": Y, "total_boards": Z }
     */
    @GetMapping("/api/admin/stats")
    public ResponseEntity<Map<String, Object>> getAdminStats() {
        Map<String, Object> stats = new HashMap<>();

        int totalUsers = (userMapper != null) ? userMapper.selectTotalUserCount() : 0;
        int penalizedUsers = (userMapper != null) ? userMapper.selectPenalizedUserCount() : 0;
        int totalBoards = (boardMapper != null) ? boardMapper.selectTotalBoardCount() : 0;

        stats.put("total_users", totalUsers);
        stats.put("penalized_users", penalizedUsers);
        stats.put("total_boards", totalBoards);

        return ResponseEntity.ok(stats);
    }

    /**
     * 5. 게시글 삭제 API (GET /api/admin/{board_id}/delete)
     */
    @GetMapping("/api/admin/{boardId}/delete")
    public ResponseEntity<Map<String, Object>> deleteBoardAdmin(@PathVariable("boardId") Long boardId) {
        Map<String, Object> response = new HashMap<>();

        if (boardMapper == null) {
            response.put("success", false);
            response.put("message", "Database mapper error");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }

        BoardVO board = boardMapper.read(boardId);
        if (board == null) {
            response.put("success", false);
            response.put("message", "존재하지 않는 게시글입니다. (boardId=" + boardId + ")");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        }

        int deleted = boardMapper.deleteBoard(boardId);
        boolean success = deleted > 0;

        response.put("success", success);
        response.put("board_id", boardId);
        response.put("message", success ? "게시글이 관리자에 의해 삭제되었습니다." : "게시글 삭제에 실패했습니다.");

        return ResponseEntity.ok(response);
    }

    private Date parseMultiDateFormat(String input) {
        String[] formats = {
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd HH:mm",
            "yyyy-MM-dd",
            "yyyy.MM.dd HH:mm:ss",
            "yyyy.MM.dd HH:mm",
            "yyyy.MM.dd"
        };

        for (String format : formats) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat(format);
                sdf.setLenient(false);
                Date date = sdf.parse(input);

                // YYYY-MM-DD 만 입력한 경우 해당 날짜의 23:59:59 초로 포맷 세팅
                if (format.equals("yyyy-MM-dd") || format.equals("yyyy.MM.dd")) {
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(date);
                    cal.set(Calendar.HOUR_OF_DAY, 23);
                    cal.set(Calendar.MINUTE, 59);
                    cal.set(Calendar.SECOND, 59);
                    return cal.getTime();
                }

                return date;
            } catch (ParseException ignored) {
            }
        }
        return null;
    }
}
