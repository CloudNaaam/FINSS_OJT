package coms.fins.ojt.controller;

import coms.fins.ojt.domain.BoardDetailResponseVO;
import coms.fins.ojt.domain.BoardVO;
import coms.fins.ojt.service.BoardService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class BoardController {

    @Autowired
    private BoardService boardService;

    @GetMapping("/board")
    public String board(Model model) {
        return "board";
    }

    @GetMapping("/board/write")
    public String boardWriteForm() {
        return "board-write";
    }

    @GetMapping("/board/{id}")
    public String boardDetailView(@PathVariable("id") Long id, Model model) {
        model.addAttribute("boardId", id);
        return "board-detail";
    }

    /**
     * 게시글 목록 및 검색 API (GET /api/board, /api/board/all, /api/board/search)
     * 파라미터: title(제목), writer(작성자), contents(내용), sort(정렬방식: latest/oldest)
     */
    @GetMapping({"/api/board", "/api/board/all", "/api/board/search"})
    @ResponseBody
    public ResponseEntity<List<BoardVO>> getBoards(
            @RequestParam(value = "q", required = false) String query,
            @RequestParam(value = "title", required = false) String title,
            @RequestParam(value = "writer", required = false) String writer,
            @RequestParam(value = "contents", required = false) String contents,
            @RequestParam(value = "sort", required = false) String sort,
            @RequestParam(value = "order", required = false) String order,
            @RequestParam(value = "content", required = false) String contentFallback,
            @RequestParam(value = "username", required = false) String usernameFallback,
            @RequestParam(value = "제목", required = false) String titleKo,
            @RequestParam(value = "작성자", required = false) String writerKo,
            @RequestParam(value = "내용", required = false) String contentKo) {

        String titleParam = (query != null && !query.isBlank()) ? query : ((title != null && !title.isBlank()) ? title : titleKo);
        String writerParam = (writer != null && !writer.isBlank()) ? writer : ((usernameFallback != null && !usernameFallback.isBlank()) ? usernameFallback : writerKo);
        String contentsParam = (contents != null && !contents.isBlank()) ? contents : ((contentFallback != null && !contentFallback.isBlank()) ? contentFallback : contentKo);
        String sortParam = (sort != null && !sort.isBlank()) ? sort : order;
        if (sortParam == null || sortParam.isBlank()) {
            sortParam = "DESC";
        }

        List<BoardVO> list = boardService.searchBoards(writerParam, titleParam, contentsParam, sortParam);
        return ResponseEntity.ok(list);
    }

    @PostMapping("/api/board/write")
    @ResponseBody
    public ResponseEntity<Map<String, Boolean>> writeBoard(
            @RequestBody BoardVO board,
            @CookieValue(value = "user_id", required = false) String userIdCookie,
            HttpServletRequest request) {

        Map<String, Boolean> response = new HashMap<>();

        Long userId = null;
        if (userIdCookie != null && !userIdCookie.trim().isEmpty()) {
            try {
                userId = Long.parseLong(userIdCookie.trim());
            } catch (Exception ignored) {}
        }
        if (userId == null && request.getSession(false) != null) {
            userId = (Long) request.getSession(false).getAttribute("userId");
        }

        if (userId == null) {
            response.put("success", false);
            return ResponseEntity.status(401).body(response);
        }

        try {
            board.setWriterId(userId);
            boolean success = boardService.createBoard(board);
            response.put("success", success);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            return ResponseEntity.badRequest().body(response);
        }
    }

    @GetMapping("/api/board/{id}")
    @ResponseBody
    public ResponseEntity<BoardDetailResponseVO> getBoardDetail(@PathVariable("id") Long id) {
        BoardDetailResponseVO detail = boardService.getBoardDetail(id);
        if (detail == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(detail);
    }

    /**
     * 게시글 삭제 API (DELETE /api/board/delete, DELETE /api/board/{boardId})
     * [취약점: DELETE 메소드 사용 시 CSRF 토큰 검증 없이 삭제 수행]
     */
    @DeleteMapping({"/api/board/delete", "/api/board/{boardId}", "/board/{boardId}"})
    @ResponseBody
    public ResponseEntity<Map<String, Boolean>> deleteBoard(
            @PathVariable(value = "boardId", required = false) Long pathBoardId,
            @RequestParam(value = "board_id", required = false) Long queryBoardId,
            @RequestBody(required = false) Map<String, Object> requestData,
            @CookieValue(value = "user_id", required = false) String userIdCookie,
            HttpServletRequest request) {

        Map<String, Boolean> response = new HashMap<>();

        Long userId = null;
        if (userIdCookie != null && !userIdCookie.trim().isEmpty()) {
            try {
                userId = Long.parseLong(userIdCookie.trim());
            } catch (Exception ignored) {}
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
        if (userId == null && request.getParameter("user_id") != null) {
            try {
                userId = Long.parseLong(request.getParameter("user_id").trim());
            } catch (Exception ignored) {}
        }

        if (userId == null) {
            response.put("success", false);
            return ResponseEntity.status(401).body(response);
        }

        Long boardId = pathBoardId != null ? pathBoardId : queryBoardId;
        if (boardId == null && requestData != null && requestData.containsKey("board_id")) {
            Object idObj = requestData.get("board_id");
            if (idObj instanceof Number) {
                boardId = ((Number) idObj).longValue();
            } else if (idObj instanceof String) {
                try {
                    boardId = Long.parseLong((String) idObj);
                } catch (NumberFormatException ignored) {}
            }
        }

        if (boardId == null) {
            response.put("success", false);
            return ResponseEntity.badRequest().body(response);
        }

        boolean success = boardService.deleteBoard(boardId, userId, request);
        response.put("success", success);

        return ResponseEntity.ok(response);
    }
}
