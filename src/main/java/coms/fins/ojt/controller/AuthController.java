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

    /**
     * 아이디 중복 체크 API (/api/auth/dup)
     * POST 요청: {"id": "입력ID"}
     * 응답: {"duplicate": true} 또는 {"duplicate": false}
     */
    @PostMapping("/dup")
    public ResponseEntity<Map<String, Boolean>> checkDuplicate(
            @RequestBody(required = false) Map<String, String> requestBody,
            @RequestParam(value = "id", required = false) String paramId) {

        Map<String, Boolean> response = new HashMap<>();

        String targetId = null;
        if (requestBody != null && requestBody.containsKey("id")) {
            targetId = requestBody.get("id");
        } else if (paramId != null) {
            targetId = paramId;
        }

        if (targetId == null || targetId.trim().isEmpty()) {
            response.put("duplicate", false);
            return ResponseEntity.ok(response);
        }

        boolean isDuplicate = userService.checkUsernameDuplicate(targetId.trim());
        response.put("duplicate", isDuplicate);

        return ResponseEntity.ok(response);
    }

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
    public ResponseEntity<Map<String, Object>> login(
            @RequestBody Map<String, String> loginRequest,
            jakarta.servlet.http.HttpServletResponse response) {

        Map<String, Object> result = new HashMap<>();

        String username = loginRequest.get("username");
        String password = loginRequest.get("password");

        UserVO user = userService.loginUser(username, password);

        if (user != null) {
            jakarta.servlet.http.Cookie userCookie = new jakarta.servlet.http.Cookie("user_id", String.valueOf(user.getUserId()));
            userCookie.setPath("/");
            userCookie.setMaxAge(60 * 60 * 24 * 7); // 7일 유지
            response.addCookie(userCookie);

            result.put("success", true);
            result.put("user_id", user.getUserId());
            return ResponseEntity.ok(result);
        } else {
            result.put("success", false);
            return ResponseEntity.ok(result);
        }
    }

    @PostMapping("/logout")
    public ResponseEntity<Map<String, Boolean>> logout(
            jakarta.servlet.http.HttpServletResponse response) {

        jakarta.servlet.http.Cookie userCookie = new jakarta.servlet.http.Cookie("user_id", "");
        userCookie.setPath("/");
        userCookie.setMaxAge(0);
        response.addCookie(userCookie);

        Map<String, Boolean> result = new HashMap<>();
        result.put("success", true);
        return ResponseEntity.ok(result);
    }
}
