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
    int updatePasswordByUsernameAndEmail(@Param("username") String username, @Param("email") String email, @Param("newPassword") String newPassword);
}
