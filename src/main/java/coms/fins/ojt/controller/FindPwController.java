package coms.fins.ojt.controller;

import coms.fins.ojt.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/findpw")
public class FindPwController {

    @Autowired
    private UserService userService;

    /**
     * JSON Body에서 이메일 목록(단일 문자열 또는 JSON 배열) 추출
     * [취약점: JSON 배열(["victim@finss.com", "attacker@evil.com"]) 수용]
     */
    private List<String> extractEmails(Object emailObj) {
        List<String> emails = new ArrayList<>();
        if (emailObj == null) {
            return emails;
        }
        if (emailObj instanceof List<?>) {
            for (Object item : (List<?>) emailObj) {
                if (item != null && !item.toString().isBlank()) {
                    emails.add(item.toString().trim());
                }
            }
        } else if (emailObj instanceof String[]) {
            for (String item : (String[]) emailObj) {
                if (item != null && !item.isBlank()) {
                    emails.add(item.trim());
                }
            }
        } else if (emailObj instanceof String) {
            String s = ((String) emailObj).trim();
            if (!s.isBlank()) {
                emails.add(s);
            }
        }
        return emails;
    }

    @PostMapping("/match")
    public ResponseEntity<Map<String, Object>> match(@RequestBody(required = false) Map<String, Object> requestData) {
        Map<String, Object> response = new HashMap<>();
        String username = requestData != null && requestData.get("username") != null ? requestData.get("username").toString() : null;
        List<String> emails = extractEmails(requestData != null ? requestData.get("email") : null);

        if (!emails.isEmpty()) {
            String primaryEmail = emails.get(0);
            if (primaryEmail != null && !primaryEmail.isBlank()) {
                userService.checkMatchUsernameAndEmail(username, primaryEmail);
            }
        }

        response.put("success", true);
        response.put("message", "success");
        return ResponseEntity.ok(response);
    }

    /**
     * 비밀번호 찾기 인증 코드 발송 API
     * [취약점: email이 JSON 배열일 경우 1번째 이메일로 유저를 검증하고, 배열 내 모든 이메일(공격자 포함)로 동일한 인증 코드 발송]
     */
    @PostMapping("/send_code")
    public ResponseEntity<Map<String, Object>> sendCode(@RequestBody(required = false) Map<String, Object> requestData) {
        Map<String, Object> response = new HashMap<>();

        if (requestData != null) {
            String username = requestData.get("username") != null ? requestData.get("username").toString() : null;
            List<String> emails = extractEmails(requestData.get("email"));

            if (!emails.isEmpty()) {
                String primaryEmail = emails.get(0);
                if (primaryEmail != null && !primaryEmail.isBlank()) {
                    userService.checkMatchUsernameAndEmail(username, primaryEmail);
                }
                // 🎯 배열 내 모든 이메일로 인증 코드 발송
                userService.sendFindPwCodeToEmails(username, emails);
            }
        }

        response.put("success", true);
        response.put("message", "success");
        return ResponseEntity.ok(response);
    }

    @PostMapping("/temp_pw")
    public ResponseEntity<Map<String, String>> generateTempPw(@RequestBody(required = false) Map<String, Object> requestData) {
        Map<String, String> response = new HashMap<>();

        if (requestData == null) {
            response.put("message", "error");
            return ResponseEntity.badRequest().body(response);
        }

        String username = requestData.get("username") != null ? requestData.get("username").toString() : null;
        List<String> emails = extractEmails(requestData.get("email"));
        String email = !emails.isEmpty() ? emails.get(0) : null;

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
    public ResponseEntity<Map<String, Object>> verifyAuthCode(@RequestBody(required = false) Map<String, Object> requestData) {
        Map<String, Object> response = new HashMap<>();
        List<String> emails = extractEmails(requestData != null ? requestData.get("email") : null);
        String email = !emails.isEmpty() ? emails.get(0) : null;
        String code = requestData != null ? (requestData.containsKey("code") ? (requestData.get("code") != null ? requestData.get("code").toString() : null) : (requestData.get("auth_code") != null ? requestData.get("auth_code").toString() : null)) : null;

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
