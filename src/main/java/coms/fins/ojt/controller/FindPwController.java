package coms.fins.ojt.controller;

import coms.fins.ojt.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/findpw")
public class FindPwController {

    @Autowired
    private UserService userService;

    @PostMapping("/match")
    public ResponseEntity<Map<String, Object>> match(@RequestBody(required = false) Map<String, String> requestData) {
        Map<String, Object> response = new HashMap<>();
        String username = requestData != null ? requestData.get("username") : null;
        String email = requestData != null ? requestData.get("email") : null;

        if (email != null && !email.isBlank()) {
            userService.checkMatchUsernameAndEmail(username, email);
        }

        response.put("success", true);
        response.put("message", "success");
        return ResponseEntity.ok(response);
    }

    @PostMapping("/send_code")
    public ResponseEntity<Map<String, Object>> sendCode(@RequestBody(required = false) Map<String, String> requestData) {
        Map<String, Object> response = new HashMap<>();

        if (requestData != null) {
            String username = requestData.get("username");
            String email = requestData.get("email");

            if (email != null && !email.isBlank()) {
                userService.checkMatchUsernameAndEmail(username, email);
            }
            userService.sendFindPwCode(username, email);
        }

        response.put("success", true);
        response.put("message", "success");
        return ResponseEntity.ok(response);
    }

    @PostMapping("/temp_pw")
    public ResponseEntity<Map<String, String>> generateTempPw(@RequestBody Map<String, String> requestData) {
        Map<String, String> response = new HashMap<>();

        if (requestData == null) {
            response.put("message", "error");
            return ResponseEntity.badRequest().body(response);
        }

        String username = requestData.get("username");
        String email = requestData.get("email");

        String tempPw = userService.generateAndUpdateTempPassword(username, email);

        if (tempPw != null) {
            response.put("temp_password", tempPw);
            return ResponseEntity.ok(response);
        } else {
            response.put("message", "error");
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PostMapping("/auth_code")
    public ResponseEntity<Map<String, Object>> verifyAuthCode(@RequestBody(required = false) Map<String, String> requestData) {
        Map<String, Object> response = new HashMap<>();
        String email = requestData != null ? requestData.get("email") : null;
        String code = requestData != null ? (requestData.containsKey("code") ? requestData.get("code") : requestData.get("auth_code")) : null;

        boolean success = userService.verifyEmailCode(email, code);
        response.put("success", success);
        if (success) {
            response.put("message", "success");
            return ResponseEntity.ok(response);
        } else {
            response.put("message", "error");
            return ResponseEntity.badRequest().body(response);
        }
    }
}
