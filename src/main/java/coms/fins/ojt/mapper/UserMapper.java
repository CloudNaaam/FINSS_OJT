package coms.fins.ojt.mapper;

import coms.fins.ojt.domain.UserVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface UserMapper {
    int insertUser(UserVO user);
    int checkUsernameExists(@Param("username") String username);
    UserVO findByUsername(@Param("username") String username);
    int loginRaw(@Param("username") String username, @Param("password") String password);
}
