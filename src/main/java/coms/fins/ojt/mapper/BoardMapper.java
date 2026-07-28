package coms.fins.ojt.mapper;

import coms.fins.ojt.domain.BoardDetailResponseVO;
import coms.fins.ojt.domain.BoardVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface BoardMapper {
    List<BoardVO> getList();
    void insert(BoardVO board);
    BoardVO read(Long boardId);
    BoardDetailResponseVO selectBoardDetailById(Long boardId);
}

