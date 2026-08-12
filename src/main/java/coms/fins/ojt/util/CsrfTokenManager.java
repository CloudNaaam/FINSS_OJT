package coms.fins.ojt.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Base64;
import java.util.UUID;

/**
 * 10분 유효기간을 갖는 CSRF 토큰 생성 및 검증 유틸리티
 */
public class CsrfTokenManager {

    private static final Logger logger = LoggerFactory.getLogger(CsrfTokenManager.class);
    
    // CSRF 시크릿 키 (서버 전용)
    private static final String SERVER_SECRET = "FinlabCsrfSecretKey2026_10MinValidity!";
    
    // 10분 = 600,000 밀리초
    public static final long TOKEN_VALIDITY_MS = 10 * 60 * 1000L;

    /**
     * 10분간 유효한 새로운 CSRF 토큰을 생성합니다.
     */
    public static String generateToken() {
        long expireAt = System.currentTimeMillis() + TOKEN_VALIDITY_MS;
        String nonce = UUID.randomUUID().toString().substring(0, 8);
        String signature = generateSignature(expireAt, nonce);
        
        String raw = expireAt + ":" + nonce + ":" + signature;
        return Base64.getUrlEncoder().withoutPadding().encodeToString(raw.getBytes(StandardCharsets.UTF_8));
    }

    /**
     * 전달받은 CSRF 토큰의 유효성 및 10분 만료 여부를 검증합니다.
     */
    public static boolean validateToken(String token) {
        if (token == null || token.isBlank()) {
            return false;
        }

        try {
            byte[] decoded = Base64.getUrlDecoder().decode(token.trim());
            String raw = new String(decoded, StandardCharsets.UTF_8);
            String[] parts = raw.split(":");

            if (parts.length != 3) {
                logger.warn("CSRF 토큰 형식이 올바르지 않습니다.");
                return false;
            }

            long expireAt = Long.parseLong(parts[0]);
            String nonce = parts[1];
            String signature = parts[2];

            // 1. 10분 유효기간 만료 여부 확인
            if (System.currentTimeMillis() > expireAt) {
                logger.warn("CSRF 토큰 10분 유효기간이 만료되었습니다. (expireAt={}, current={})", expireAt, System.currentTimeMillis());
                return false;
            }

            // 2. 서버 서명 무결성 검증
            String expectedSignature = generateSignature(expireAt, nonce);
            if (!expectedSignature.equals(signature)) {
                logger.warn("CSRF 토큰 위변조가 감지되었습니다.");
                return false;
            }

            return true;

        } catch (Exception e) {
            logger.error("CSRF 토큰 검증 중 예외 발생: ", e);
            return false;
        }
    }

    private static String generateSignature(long expireAt, String nonce) {
        try {
            String data = SERVER_SECRET + "|" + expireAt + "|" + nonce;
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(data.getBytes(StandardCharsets.UTF_8));
            return Base64.getUrlEncoder().withoutPadding().encodeToString(hash).substring(0, 16);
        } catch (Exception e) {
            throw new RuntimeException("SHA-256 알고리즘 사용 불가능", e);
        }
    }
}
