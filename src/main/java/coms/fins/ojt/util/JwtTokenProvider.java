package coms.fins.ojt.util;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.jsonwebtoken.*;

import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.*;
import java.util.Base64;
import java.util.Map;

/**
 * JWT 토큰 관리자
 *
 * [LAB ONLY - INTENTIONALLY VULNERABLE]
 *
 * - 정상 토큰 발급: RS256
 * - 검증 시 JWT Header의 alg 값을 신뢰
 * - HS256인 경우 RSA Public Key의 바이트를 HMAC Secret으로 재사용
 *
 * => 의도적인 RS256 -> HS256 Algorithm/Key Confusion 실습
 */
public class JwtTokenProvider {

    private static final PrivateKey PRIVATE_KEY;
    private static final PublicKey PUBLIC_KEY;

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    static {
        try {
            KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance("RSA");
            keyPairGen.initialize(2048);

            KeyPair keyPair = keyPairGen.generateKeyPair();

            PRIVATE_KEY = keyPair.getPrivate();
            PUBLIC_KEY = keyPair.getPublic();

        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("RSA 키쌍 생성 실패", e);
        }
    }

    /**
     * 정상 Access Token 발급
     * - RS256
     * - 유효기간 24시간
     */
    public static String generateAccessToken(Long userId, String username) {

        long now = System.currentTimeMillis();
        long expireAt = now + (24 * 60 * 60 * 1000L);

        return Jwts.builder()
                .setHeaderParam("typ", "JWT")
                .setSubject(String.valueOf(userId))
                .claim("username", username)
                .setIssuedAt(new java.util.Date(now))
                .setExpiration(new java.util.Date(expireAt))
                .signWith(PRIVATE_KEY, SignatureAlgorithm.RS256)
                .compact();
    }

    public static String generateToken(Long userId, String username, boolean isAdmin) {
        return generateAccessToken(userId, username);
    }

    public static String generateToken(Long userId, String username) {
        return generateAccessToken(userId, username);
    }

    /**
     * [LAB ONLY - INTENTIONALLY VULNERABLE]
     *
     * JWT Header의 alg 값을 신뢰하여 검증 알고리즘을 결정한다.
     *
     * RS256:
     *   RSA Public Key 사용
     *
     * HS256:
     *   RSA Public Key의 encoded bytes를
     *   HMAC SecretKey로 잘못 재사용
     */
    public static Claims parseAndValidateToken(String token) {

        if (token == null || token.isBlank()) {
            return null;
        }

        String rawToken = token.trim();

        if (rawToken.startsWith("Bearer ")) {
            rawToken = rawToken.substring(7).trim();
        }

        try {
            /*
             * JWT:
             *
             * header.payload.signature
             *
             * 아직 Signature 검증을 하지 않은 상태에서
             * Header의 alg를 먼저 읽는다.
             */
            String[] parts = rawToken.split("\\.");

            if (parts.length != 3) {
                return null;
            }

            byte[] decodedHeader =
                    Base64.getUrlDecoder().decode(parts[0]);

            String headerJson =
                    new String(decodedHeader, StandardCharsets.UTF_8);

            Map<String, Object> header =
                    OBJECT_MAPPER.readValue(headerJson, Map.class);

            String alg = String.valueOf(header.get("alg"));

            /*
             * 정상 RS256 경로
             */
            if ("RS256".equals(alg)) {

                return Jwts.parserBuilder()
                        .setSigningKey(PUBLIC_KEY)
                        .build()
                        .parseClaimsJws(rawToken)
                        .getBody();
            }

            /*
             * 취약한 HS256 경로
             *
             * 문제:
             *
             * RSA PUBLIC KEY
             *      ↓
             * getEncoded()
             *      ↓
             * byte[]
             *      ↓
             * SecretKeySpec(HmacSHA256)
             *
             * 즉 공개키를 HMAC Secret처럼 취급한다.
             */
            else if ("HS256".equals(alg)) {

                byte[] publicKeyBytes =
                        PUBLIC_KEY.getEncoded();

                Key confusedKey =
                        new SecretKeySpec(
                                publicKeyBytes,
                                SignatureAlgorithm.HS256.getJcaName()
                        );

                return Jwts.parserBuilder()
                        .setSigningKey(confusedKey)
                        .build()
                        .parseClaimsJws(rawToken)
                        .getBody();
            }

            /*
             * 나머지 알고리즘은 거부
             */
            return null;

        } catch (Exception e) {
            return null;
        }
    }

    public static Long getUserIdFromToken(String token) {

        Claims claims = parseAndValidateToken(token);

        if (claims == null) {
            return null;
        }

        try {
            return Long.parseLong(claims.getSubject());
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * JWKS 공개키 제공
     */
    public static java.util.Map<String, Object> getJwksKeySet() {

        java.util.Map<String, Object> result =
                new java.util.HashMap<>();

        if (!(PUBLIC_KEY instanceof
                java.security.interfaces.RSAPublicKey rsaPublicKey)) {

            result.put(
                    "keys",
                    java.util.Collections.emptyList()
            );

            return result;
        }

        java.util.Map<String, Object> keyMap =
                new java.util.HashMap<>();

        keyMap.put("kty", "RSA");
        keyMap.put("alg", "RS256");
        keyMap.put("use", "sig");
        keyMap.put("kid", "finlab-rsa-key-1");

        byte[] nBytes =
                rsaPublicKey.getModulus().toByteArray();

        byte[] eBytes =
                rsaPublicKey.getPublicExponent().toByteArray();

        if (nBytes[0] == 0) {

            byte[] tmp =
                    new byte[nBytes.length - 1];

            System.arraycopy(
                    nBytes,
                    1,
                    tmp,
                    0,
                    tmp.length
            );

            nBytes = tmp;
        }

        String nBase64 =
                Base64.getUrlEncoder()
                        .withoutPadding()
                        .encodeToString(nBytes);

        String eBase64 =
                Base64.getUrlEncoder()
                        .withoutPadding()
                        .encodeToString(eBytes);

        keyMap.put("n", nBase64);
        keyMap.put("e", eBase64);

        result.put(
                "keys",
                java.util.Collections.singletonList(keyMap)
        );

        return result;
    }
}