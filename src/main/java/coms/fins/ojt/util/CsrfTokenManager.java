package coms.fins.ojt.util;

import java.util.UUID;

/**
 * 세션 연동 CSRF 토큰 생성 유틸리티
 * - 로그인 시 세션 생성과 함께 CSRF 토큰이 생성되며 세션 동안 유지됨
 * - 로그아웃 / 세션 만료 시 토큰 파기
 */
public class CsrfTokenManager {

    public static final String SESSION_CSRF_KEY = "CSRF_TOKEN";

    /**
     * 새로운 세션용 무작위 CSRF 토큰 생성
     */
    public static String generateToken() {
        return UUID.randomUUID().toString().replace("-", "");
    }
}
