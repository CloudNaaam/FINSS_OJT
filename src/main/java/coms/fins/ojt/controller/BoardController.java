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

    @GetMapping("/api/board/all")
    @ResponseBody
    public ResponseEntity<List<BoardVO>> getAllBoards() {
        List<BoardVO> list = boardService.getList();
        return ResponseEntity.ok(list);
    }

    @PostMapping("/api/board/write")
    @ResponseBody
    public ResponseEntity<Map<String, Boolean>> writeBoard(@RequestBody BoardVO board) {
        Map<String, Boolean> response = new HashMap<>();

        boolean success = boardService.createBoard(board);

        response.put("success", success);
        return ResponseEntity.ok(response);
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

    @DeleteMapping("/api/board/delete")
    @ResponseBody
    public ResponseEntity<Map<String, Boolean>> deleteBoard(
            @RequestBody Map<String, Object> requestData,
            HttpServletRequest request) {

        Map<String, Boolean> response = new HashMap<>();

        if (requestData == null || !requestData.containsKey("board_id")) {
            response.put("success", false);
            return ResponseEntity.badRequest().body(response);
        }

        Object idObj = requestData.get("board_id");
        Long boardId = null;

        if (idObj instanceof Number) {
            boardId = ((Number) idObj).longValue();
        } else if (idObj instanceof String) {
            try {
                boardId = Long.parseLong((String) idObj);
            } catch (NumberFormatException e) {
                response.put("success", false);
                return ResponseEntity.badRequest().body(response);
            }
        }

        if (boardId == null) {
            response.put("success", false);
            return ResponseEntity.badRequest().body(response);
        }

        boolean success = boardService.deleteBoard(boardId, request);
        response.put("success", success);

        return ResponseEntity.ok(response);
    }
}
