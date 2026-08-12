package coms.fins.ojt.config;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.HandlerInterceptor;

public class AuthCookieInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 1. user_id 쿠키 존재 여부 확인
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("user_id".equals(cookie.getName()) && cookie.getValue() != null && !cookie.getValue().trim().isEmpty()) {
                    return true;
                }
            }
        }

        // 2. JWT Authorization 헤더 또는 access_token 파라미터 확인
        String authHeader = request.getHeader("Authorization");
        String token = null;
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            token = authHeader.substring(7).trim();
        } else {
            token = request.getParameter("access_token");
        }

        if (token != null && !token.isBlank()) {
            io.jsonwebtoken.Claims claims = coms.fins.ojt.util.JwtTokenProvider.parseAndValidateToken(token);
            if (claims != null) {
                return true;
            }
        }

        // 쿠키 및 JWT 토큰이 모두 존재하지 않으면 /login 페이지로 리다이렉트
        response.sendRedirect("/login");
        return false;
    }
}
