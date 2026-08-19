package coms.fins.ojt.mapper;

import coms.fins.ojt.domain.UserVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface UserMapper {
    int insertUser(UserVO user);
    int checkUsernameExists(@Param("username") String username);
    String findUsernameByUsername(@Param("username") String username);
    UserVO findByUsername(@Param("username") String username);
    UserVO selectUserById(@Param("userId") Long userId);
    int loginRaw(@Param("username") String username, @Param("password") String password);
    int updateUserProfileImg(@Param("userId") Long userId, @Param("profileImg") String profileImg);
    int updateManagerStatus(@Param("userId") Long userId, @Param("isManager") int isManager);
    Long findUserIdByUsernameAndEmail(@Param("username") String username, @Param("email") String email);
    String findUsernameByEmail(@Param("email") String email);
    int updatePasswordByUsernameAndEmail(@Param("username") String username, @Param("email") String email, @Param("newPassword") String newPassword);
    java.util.List<UserVO> searchUsers(@Param("keyword") String keyword);
    int updateUserPenalty(@Param("userId") Long userId, @Param("penaltyUntil") java.util.Date penaltyUntil);
    int selectTotalUserCount();
    int selectPenalizedUserCount();
    int updateUserPoint(@Param("userId") Long userId, @Param("point") Integer point);
    UserVO findByUsernameOrName(@Param("target") String target);
    int updateUserProfile(UserVO user);
    UserVO findByEmail(@Param("email") String email);
    int deleteUserById(@Param("userId") Long userId);
    int deleteMatchParticipantsByUserId(@Param("userId") Long userId);
    int deleteMatchApplicationsByUserId(@Param("userId") Long userId);
    int deletePointPaymentsByUserId(@Param("userId") Long userId);
    int deleteBoardsByWriterId(@Param("userId") Long userId);
}
