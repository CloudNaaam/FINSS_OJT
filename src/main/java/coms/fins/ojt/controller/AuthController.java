package coms.fins.ojt.controller;

import coms.fins.ojt.domain.UserVO;
import coms.fins.ojt.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public ResponseEntity<Map<String, String>> register(@RequestBody UserVO user) {
        Map<String, String> response = new HashMap<>();

        boolean success = userService.registerUser(user);

        if (success) {
            response.put("message", "success");
            return ResponseEntity.ok(response);
        } else {
            response.put("message", "error");
            return ResponseEntity.status(400).body(response);
        }
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Boolean>> login(@RequestBody Map<String, String> loginRequest) {
        Map<String, Boolean> response = new HashMap<>();

        String username = loginRequest.get("username");
        String password = loginRequest.get("password");

        boolean success = userService.loginUser(username, password);

        // 성공 / 실패 모두 HTTP 200 OK로 반환
        response.put("success", success);
        return ResponseEntity.ok(response);
    }
}
