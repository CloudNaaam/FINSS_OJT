package coms.fins.ojt.mapper;

import coms.fins.ojt.domain.GroundVO;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface GroundMapper {
    int insertGround(GroundVO ground);
    int updateGround(GroundVO ground);
    List<GroundVO> selectGroundsByManagerId(@Param("managerId") Long managerId);
    GroundVO selectGroundById(@Param("groundId") Long groundId);
}
