package coms.fins.ojt.mapper;

import coms.fins.ojt.domain.BoardDetailResponseVO;
import coms.fins.ojt.domain.BoardVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface BoardMapper {
    List<BoardVO> getList();
    List<BoardVO> searchBoards(
            @Param("writer") String writer,
            @Param("title") String title,
            @Param("content") String content,
            @Param("sort") String sort
    );
    void insert(BoardVO board);
    BoardVO read(Long boardId);
    BoardDetailResponseVO selectBoardDetailById(Long boardId);
    int deleteBoard(Long boardId);
    int selectTotalBoardCount();
}
