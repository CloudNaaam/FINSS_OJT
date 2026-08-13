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
        if (requestURI.equals("/api/auth/login") 
                || requestURI.equals("/api/auth/register")
                || requestURI.equals("/api/auth/dup")
                || requestURI.equals("/api/auth/send_code")
                || requestURI.equals("/api/auth/valid_code")
                || requestURI.startsWith("/api/admin/")
                || requestURI.startsWith("/api/user/")
                || requestURI.equals("/api/users")) {
            return true;
        }

        // 클라이언트 토큰 추출: Custom Header (X-CSRF-TOKEN) -> Form Body (csrfToken)
        String clientToken = request.getHeader("X-CSRF-TOKEN");
        if (clientToken == null || clientToken.isBlank()) {
            clientToken = request.getHeader("X-XSRF-TOKEN");
        }
        if (clientToken == null || clientToken.isBlank()) {
            clientToken = request.getParameter("csrfToken");
        }

        // 세션에 저장된 CSRF 토큰 추출
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        String sessionToken = (session != null) ? (String) session.getAttribute(CsrfTokenManager.SESSION_CSRF_KEY) : null;

        // 세션 CSRF 토큰 검증 (세션 토큰과 클라이언트 폼 토큰 일치 여부 판별)
        if (sessionToken == null || clientToken == null || !sessionToken.equals(clientToken.trim())) {
            String origin = request.getHeader("Origin");
            if (origin != null && !origin.isBlank()) {
                response.setHeader("Access-Control-Allow-Origin", origin);
                response.setHeader("Access-Control-Allow-Credentials", "true");
            }

            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403 Forbidden
            response.setContentType("application/json;charset=UTF-8");

            PrintWriter writer = response.getWriter();
            writer.write("{\"success\":false, \"code\":\"INVALID_CSRF_TOKEN\", \"message\":\"CSRF 토큰이 없거나 유효하지 않습니다. (세션이 만료되었거나 로그인이 필요할 수 있습니다.)\"}");
            writer.flush();
            return false;
        }

        return true;
    }
}
