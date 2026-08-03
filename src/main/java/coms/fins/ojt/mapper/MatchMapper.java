package coms.fins.ojt.mapper;

import coms.fins.ojt.domain.MatchVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MatchMapper {
    List<MatchVO> selectAllMatches();
    MatchVO selectMatchById(@Param("matchId") Long matchId);
}
