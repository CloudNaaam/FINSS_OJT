package coms.fins.ojt.mapper;

import coms.fins.ojt.domain.JobApplicationVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface JobApplicationMapper {
    int insertJobApplication(JobApplicationVO jobApplication);
    int updateJobApplication(JobApplicationVO jobApplication);
    List<JobApplicationVO> selectAllApplications();
    JobApplicationVO selectApplicationById(@Param("applicationId") Long applicationId);
    JobApplicationVO selectLatestByEmailOrPhone(@Param("email") String email, @Param("phone") String phone);
}
