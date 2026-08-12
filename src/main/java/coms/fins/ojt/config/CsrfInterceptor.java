package coms.fins.ojt.config;

import coms.fins.ojt.util.CsrfTokenManager;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.HandlerInterceptor;

import java.io.PrintWriter;

/**
 * CSRF 토큰 10분 유효성 검증 인터셉터
 */
public class CsrfInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String method = request.getMethod();

        // GET, HEAD, OPTIONS 등의 읽기 요청 및 토큰 발급/로그인 API는 검증 제외
        if ("GET".equalsIgnoreCase(method) || "HEAD".equalsIgnoreCase(method) || "OPTIONS".equalsIgnoreCase(method)) {
            return true;
        }

        String requestURI = request.getRequestURI();
        if (requestURI.equals("/api/auth/login") || requestURI.equals("/api/auth/csrf") || requestURI.equals("/api/csrf")) {
            return true;
        }

        // 오직 HTML Form 데이터 (name="csrfToken") 만 추출하여 10분 유효기간 검증
        String token = request.getParameter("csrfToken");

        // 10분 유효기간 검증
        if (token == null || !CsrfTokenManager.validateToken(token)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403 Forbidden
            response.setContentType("application/json;charset=UTF-8");

            PrintWriter writer = response.getWriter();
            writer.write("{\"success\":false, \"code\":\"CSRF_EXPIRED\", \"message\":\"CSRF 토큰이 유효하지 않거나 10분 유효기간이 만료되었습니다. /api/auth/csrf 에서 새로 발급받으세요.\"}");
            writer.flush();
            return false;
        }

        return true;
    }
}
