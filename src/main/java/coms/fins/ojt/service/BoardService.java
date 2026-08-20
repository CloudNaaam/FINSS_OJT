package coms.fins.ojt.service;

import coms.fins.ojt.domain.BoardDetailResponseVO;
import coms.fins.ojt.domain.BoardVO;
import coms.fins.ojt.mapper.BoardMapper;
import coms.fins.ojt.mapper.FileMapper;
import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@Service
public class BoardService {

    private static final Logger logger = LoggerFactory.getLogger(BoardService.class);

    @Autowired(required = false)
    private BoardMapper boardMapper;

    @Autowired(required = false)
    private FileMapper fileMapper;

    public List<BoardVO> getList() {
        if (boardMapper == null) {
            return List.of();
        }
        return boardMapper.getList();
    }

    public List<BoardVO> searchBoards(String writer, String title, String content, String sort) {
        if (boardMapper == null) {
            return List.of();
        }
        return boardMapper.searchBoards(writer, title, content, sort);
    }

    public List<BoardVO> searchBoards(String writer, String title, String content) {
        return searchBoards(writer, title, content, "latest");
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

        if (board.getWriterId() == null) {
            board.setWriterId(1L);
        }

        if (boardMapper == null) {
            logger.error("BoardMapper 가 빈으로 등록되지 않았습니다.");
            return false;
        }

        try {
            boardMapper.insert(board);
            logger.info("게시글 성공적으로 작성 완료: title={}, writerId={}", board.getTitle(), board.getWriterId());
            return true;
        } catch (Exception e) {
            logger.error("게시글 작성 실패 원인 예외 발생: ", e);
            return false;
        }
    }

    @Transactional
    public boolean deleteBoard(Long boardId, Long requestUserId, HttpServletRequest request) {
        if (boardMapper == null || boardId == null) {
            return false;
        }

        try {
            BoardVO board = boardMapper.read(boardId);
            if (board == null) {
                logger.warn("삭제 대상 게시글을 찾을 수 없습니다: boardId={}", boardId);
                return false;
            }

            /*
             * [취약점 실습 포인트: IDOR / BOLA]
             * 작성자 본인 확인(boardWriterId == requestUserId) 로직을 생략하여
             * 로그인된 사용자라면 누구나 boardId만으로 타인의 게시글을 즉시 삭제 가능
             */

            // 첨부파일 삭제 처리
            if (board.getFileUuid() != null && !board.getFileUuid().isBlank()) {
                String fileUuid = board.getFileUuid();

                // 1. 물리 파일 삭제
                if (request != null) {
                    try {
                        String realUploadsPath = request.getServletContext().getRealPath("/uploads");
                        Path filePath = Paths.get(realUploadsPath, "board", fileUuid);
                        Files.deleteIfExists(filePath);
                    } catch (Exception e) {
                        logger.error("첨부파일 물리 삭제 중 오류 발생: fileUuid={}", fileUuid, e);
                    }
                }

                // 2. files 메타데이터 테이블 삭제
                if (fileMapper != null) {
                    fileMapper.deleteFileByUuid(fileUuid);
                }
            }

            // 3. board 테이블 레코드 삭제
            int rows = boardMapper.deleteBoard(boardId);
            return rows > 0;

        } catch (Exception e) {
            logger.error("게시글 삭제 실패 예외 발생: boardId={}", boardId, e);
            return false;
        }
    }
}
