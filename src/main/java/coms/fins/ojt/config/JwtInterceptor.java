package coms.fins.ojt.config;

import coms.fins.ojt.util.JwtTokenProvider;
import io.jsonwebtoken.Claims;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * JWT 토큰 검증 인터셉터
 * Authorization: Bearer <token> 헤더 또는 access_token 파라미터 검증
 */
public class JwtInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String method = request.getMethod();
        if ("OPTIONS".equalsIgnoreCase(method)) {
            return true;
        }

        String authHeader = request.getHeader("Authorization");
        String token = null;

        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            token = authHeader.substring(7).trim();
        } else {
            token = request.getParameter("access_token");
        }

        Long userId = null;

        if (token != null && !token.isBlank()) {
            Claims claims = JwtTokenProvider.parseAndValidateToken(token);
            if (claims != null) {
                request.setAttribute("jwtClaims", claims);
                try {
                    userId = Long.parseLong(claims.getSubject());
                } catch (Exception ignored) {}
            }
        }

        // JWT 토큰이 없거나 파싱되지 않은 경우 쿠키(user_id)에서 fallback 추출
        if (userId == null && request.getCookies() != null) {
            for (jakarta.servlet.http.Cookie cookie : request.getCookies()) {
                if ("user_id".equals(cookie.getName()) && cookie.getValue() != null && !cookie.getValue().isBlank()) {
                    try {
                        userId = Long.parseLong(cookie.getValue().trim());
                        break;
                    } catch (Exception ignored) {}
                }
            }
        }

        // 세션에서 fallback 추출
        if (userId == null && request.getSession(false) != null) {
            Object sUserId = request.getSession(false).getAttribute("userId");
            if (sUserId instanceof Number) {
                userId = ((Number) sUserId).longValue();
            } else if (sUserId instanceof String) {
                try { userId = Long.parseLong((String) sUserId); } catch (Exception ignored) {}
            }
            if (userId == null) {
                Object sUser = request.getSession(false).getAttribute("user");
                if (sUser instanceof coms.fins.ojt.domain.UserVO) {
                    userId = ((coms.fins.ojt.domain.UserVO) sUser).getUserId();
                }
            }
        }

        if (userId != null) {
            request.setAttribute("userId", userId);
        }

        return true;
    }
}
