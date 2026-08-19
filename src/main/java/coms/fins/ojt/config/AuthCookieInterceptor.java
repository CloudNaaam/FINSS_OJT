package coms.fins.ojt.config;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

public class AuthCookieInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 1. JSESSIONID 서버 세션의 로그인 상태 확인 (세션 중심 관리 & 세션 재사용)
        HttpSession session = request.getSession(false);
        if (session != null) {
            if (session.getAttribute("userId") != null || session.getAttribute("user") != null) {
                return true;
            }
        }

        // 2. user_id 쿠키 존재 여부 확인 (쿠키 변조 지원)
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("user_id".equals(cookie.getName()) && cookie.getValue() != null && !cookie.getValue().trim().isEmpty()) {
                    return true;
                }
            }
        }

        // 3. JWT Authorization 헤더 또는 access_token 파라미터 확인
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

        // 4. 인증 정보가 전혀 없는 경우:
        String requestURI = request.getRequestURI();
        if (requestURI.startsWith("/api/")) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":false,\"message\":\"로그인이 필요한 서비스입니다.\",\"redirect_url\":\"/login\"}");
            return false;
        }

        // 일반 페이지 요청은 /login 페이지로 리다이렉트
        response.sendRedirect("/login");
        return false;
    }
}
