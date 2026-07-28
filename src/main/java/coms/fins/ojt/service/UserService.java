package coms.fins.ojt.service;

import coms.fins.ojt.domain.UserVO;
import coms.fins.ojt.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserService {

    @Autowired(required = false)
    private UserMapper userMapper;

    @Transactional
    public boolean registerUser(UserVO user) {
        if (user == null || user.getUsername() == null || user.getUsername().isBlank()
                || user.getPassword() == null || user.getPassword().isBlank()) {
            return false;
        }

        if (userMapper == null) {
            return false;
        }

        try {
            int exists = userMapper.checkUsernameExists(user.getUsername());
            if (exists > 0) {
                return false;
            }

            int result = userMapper.insertUser(user);
            return result > 0;

        } catch (Exception e) {
            return false;
        }
    }

    public boolean loginUser(String username, String password) {
        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            return false;
        }

        if (userMapper == null) {
            return false;
        }

        try {
            int count = userMapper.loginRaw(username, password);
            return count > 0;
        } catch (Exception e) {
            return false;
        }
    }
}
