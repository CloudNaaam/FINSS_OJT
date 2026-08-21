package coms.fins.ojt.mapper;

import coms.fins.ojt.domain.MatchApplicationVO;
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

    int insertApplication(MatchApplicationVO vo);
    MatchApplicationVO selectApplication(@Param("applicationId") String applicationId);
    int updateApplicationStatus(@Param("applicationId") String applicationId, @Param("status") String status);
    int updateApplicationFee(@Param("applicationId") String applicationId, @Param("fee") Integer fee);
    int insertParticipant(@Param("matchId") String matchId, @Param("userId") Long userId);
    int deleteParticipant(@Param("matchId") String matchId, @Param("userId") Long userId);
    int countParticipant(@Param("matchId") String matchId, @Param("userId") Long userId);
    List<MatchVO> selectMyAppliedMatches(@Param("userId") Long userId);
}
