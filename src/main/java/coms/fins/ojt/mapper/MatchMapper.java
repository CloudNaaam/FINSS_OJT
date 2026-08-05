package coms.fins.ojt.mapper;

import coms.fins.ojt.domain.MatchVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MatchMapper {
    List<MatchVO> selectAllMatches();
    List<MatchVO> selectMatchesWithFilter(
            @Param("isEnd") Integer isEnd,
            @Param("isGender") String isGender,
            @Param("level") Integer level,
            @Param("date") String date,
            @Param("evening") String evening
    );
    MatchVO selectMatchById(@Param("matchId") Object matchId);
}
