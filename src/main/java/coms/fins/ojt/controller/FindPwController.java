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

    @PostMapping("/send_code")
    public ResponseEntity<Map<String, String>> sendCode(@RequestBody Map<String, String> requestData) {
        Map<String, String> response = new HashMap<>();

        if (requestData == null) {
            response.put("message", "error");
            return ResponseEntity.badRequest().body(response);
        }

        String username = requestData.get("username");
        String email = requestData.get("email");

        boolean success = userService.sendFindPwCode(username, email);

        if (success) {
            response.put("message", "success");
            return ResponseEntity.ok(response);
        } else {
            response.put("message", "error");
            return ResponseEntity.badRequest().body(response);
        }
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
}
