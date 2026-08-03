package coms.fins.ojt.mapper;

import coms.fins.ojt.domain.EmailVerificationVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface EmailVerificationMapper {
    int insertVerification(EmailVerificationVO vo);
    EmailVerificationVO selectLatestVerification(@Param("email") String email, @Param("authCode") String authCode);
    int updateVerifiedStatus(@Param("verificationId") Long verificationId);
}
