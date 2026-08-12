package coms.fins.ojt.controller;

import coms.fins.ojt.util.JwtTokenProvider;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * JWKS (JSON Web Key Set) 공개키 제공 컨트롤러
 * 표준 엔드포인트: GET /.well-known/jwks.json 및 GET /api/auth/jwks
 */
@RestController
public class JwksController {

    @GetMapping(value = {"/.well-known/jwks.json", "/api/auth/jwks"}, produces = "application/json;charset=UTF-8")
    public ResponseEntity<Map<String, Object>> getJwks() {
        return ResponseEntity.ok(JwtTokenProvider.getJwksKeySet());
    }
}
