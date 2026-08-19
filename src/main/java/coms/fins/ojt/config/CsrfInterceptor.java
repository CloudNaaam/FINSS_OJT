package coms.fins.ojt.config;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import coms.fins.ojt.util.CsrfTokenManager;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

import java.io.BufferedReader;
import java.io.PrintWriter;

/**
 * CSRF 토큰 유효성 검증 인터셉터
 * - 클라이언트 Body 데이터 (Form Parameter 또는 JSON Body의 csrfToken 필드) 에서 추출하여 검증
 */
public class CsrfInterceptor implements HandlerInterceptor {

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String method = request.getMethod();

        // GET, HEAD, OPTIONS, TRACE 등의 읽기 요청 및 토큰 발급/로그인 API는 검증 제외
        if ("GET".equalsIgnoreCase(method) || "HEAD".equalsIgnoreCase(method) || "OPTIONS".equalsIgnoreCase(method) || "TRACE".equalsIgnoreCase(method)) {
            return true;
        }

        String requestURI = request.getRequestURI();
        if (requestURI.equals("/api/auth/login") 
                || requestURI.equals("/api/auth/register")
                || requestURI.equals("/api/auth/dup")
                || requestURI.equals("/api/auth/send_code")
                || requestURI.equals("/api/auth/valid_code")
                || requestURI.equals("/api/auth/logout")
                || requestURI.equals("/logout")
                || requestURI.startsWith("/api/findpw/")
                || requestURI.startsWith("/api/point/charge/")
                || requestURI.startsWith("/mock-pg/")
                || requestURI.startsWith("/api/matches/")
                || requestURI.startsWith("/api/profile/")
                || requestURI.startsWith("/api/admin/")
                || requestURI.startsWith("/api/user/")
                || requestURI.equals("/api/users")
                || ("DELETE".equalsIgnoreCase(method) && (requestURI.startsWith("/api/board") || requestURI.startsWith("/board")))) {
            return true;
        }

        // 1. 클라이언트 토큰 추출: Form Parameter (csrfToken) 에서 우선 추출
        String clientToken = request.getParameter("csrfToken");

        // 2. Form Parameter에 없고 application/json 요청인 경우 JSON Body 데이터 내부의 csrfToken 필드 추출
        String contentType = request.getContentType();
        if ((clientToken == null || clientToken.isBlank()) && contentType != null && contentType.toLowerCase().contains("application/json")) {
            try {
                StringBuilder sb = new StringBuilder();
                try (BufferedReader reader = request.getReader()) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        sb.append(line);
                    }
                }
                String body = sb.toString();
                if (body != null && !body.isBlank()) {
                    JsonNode node = objectMapper.readTree(body);
                    if (node.has("csrfToken") && !node.get("csrfToken").isNull()) {
                        clientToken = node.get("csrfToken").asText();
                    }
                }
            } catch (Exception ignored) {
            }
        }

        // 세션에 저장된 CSRF 토큰 추출 (세션 존재 시 보존 및 발급)
        HttpSession session = request.getSession(true);
        String sessionToken = (String) session.getAttribute(CsrfTokenManager.SESSION_CSRF_KEY);
        if (sessionToken == null || sessionToken.isBlank()) {
            sessionToken = CsrfTokenManager.generateToken();
            session.setAttribute(CsrfTokenManager.SESSION_CSRF_KEY, sessionToken);
        }

        // 세션 CSRF 토큰 검증 (세션 토큰과 클라이언트 Body 데이터 토큰 일치 여부 판별)
        if (clientToken == null || !sessionToken.equals(clientToken.trim())) {
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
