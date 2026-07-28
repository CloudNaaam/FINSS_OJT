package coms.fins.ojt.service;

import coms.fins.ojt.domain.BoardDetailResponseVO;
import coms.fins.ojt.domain.BoardVO;
import coms.fins.ojt.mapper.BoardMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class BoardService {

    private static final Logger logger = LoggerFactory.getLogger(BoardService.class);

    @Autowired(required = false)
    private BoardMapper boardMapper;

    public List<BoardVO> getList() {
        if (boardMapper == null) {
            return List.of();
        }
        return boardMapper.getList();
    }

    public BoardDetailResponseVO getBoardDetail(Long boardId) {
        if (boardMapper == null || boardId == null) {
            return null;
        }
        return boardMapper.selectBoardDetailById(boardId);
    }

    @Transactional
    public boolean createBoard(BoardVO board) {
        if (board == null || board.getTitle() == null || board.getTitle().isBlank()) {
            logger.warn("게시글 제목이 유효하지 않습니다.");
            return false;
        }

        if (boardMapper == null) {
            logger.error("BoardMapper 가 빈으로 등록되지 않았습니다.");
            return false;
        }

        try {
            // 작성자 ID를 1L로 고정 설정
            board.setWriterId(1L);
            boardMapper.insert(board);
            logger.info("게시글 성공적으로 작성 완료: title={}", board.getTitle());
            return true;
        } catch (Exception e) {
            logger.error("게시글 작성 실패 원인 예외 발생: ", e);
            return false;
        }
    }
}

