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

    // 1. SSTI (Thymeleaf / SpEL) 규칙
    private static final java.util.List<java.util.regex.Pattern> SSTI_PATTERNS = java.util.List.of(
            java.util.regex.Pattern.compile("\\$\\{[\\s\\S]*?\\}", java.util.regex.Pattern.CASE_INSENSITIVE),
            java.util.regex.Pattern.compile("getruntime|processbuilder|exec\\s*\\(", java.util.regex.Pattern.CASE_INSENSITIVE)
    );

    private boolean isSsti(String input) {
        if (input == null || input.isBlank()) {
            return false;
        }
        for (java.util.regex.Pattern pattern : SSTI_PATTERNS) {
            if (pattern.matcher(input).find()) {
                return true;
            }
        }
        return false;
    }

    @PostMapping("/match")
    public ResponseEntity<Map<String, Object>> match(@RequestBody(required = false) Map<String, String> requestData) {
        Map<String, Object> response = new HashMap<>();
        String username = requestData != null ? requestData.get("username") : null;
        String email = requestData != null ? requestData.get("email") : null;

        if (isSsti(username) || isSsti(email)) {
            response.put("success", false);
            response.put("message", "SSTI 패턴이 감지되었습니다.");
            return ResponseEntity.status(org.springframework.http.HttpStatus.BAD_REQUEST).body(response);
        }

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

            if (isSsti(username) || isSsti(email)) {
                response.put("success", false);
                response.put("message", "SSTI 패턴이 감지되었습니다.");
                return ResponseEntity.status(org.springframework.http.HttpStatus.BAD_REQUEST).body(response);
            }

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
