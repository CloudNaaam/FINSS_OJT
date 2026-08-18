package coms.fins.ojt.config;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Enumeration;

/**
 * TRACE 요청 처리 필터
 * Tomcat 기본 doTrace()의 Cookie 필터링을 우회하여 원본 요청 헤더(Cookie 포함) 전체를 응답 본문에 에코
 */
public class TraceFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        if (!(request instanceof HttpServletRequest) || !(response instanceof HttpServletResponse)) {
            chain.doFilter(request, response);
            return;
        }

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // TRACE 요청인 경우 원본 헤더(Cookie, Authorization 포함)를 그대로 반사
        if ("TRACE".equalsIgnoreCase(httpRequest.getMethod())) {
            StringBuilder buffer = new StringBuilder();
            buffer.append("TRACE ").append(httpRequest.getRequestURI());
            if (httpRequest.getQueryString() != null) {
                buffer.append("?").append(httpRequest.getQueryString());
            }
            buffer.append(" ").append(httpRequest.getProtocol());

            Enumeration<String> headerNames = httpRequest.getHeaderNames();
            while (headerNames != null && headerNames.hasMoreElements()) {
                String headerName = headerNames.nextElement();
                Enumeration<String> headerValues = httpRequest.getHeaders(headerName);
                while (headerValues != null && headerValues.hasMoreElements()) {
                    buffer.append("\r\n").append(headerName).append(": ").append(headerValues.nextElement());
                }
            }

            httpResponse.setContentType("message/http;charset=UTF-8");
            httpResponse.setStatus(HttpServletResponse.SC_OK);
            httpResponse.getWriter().print(buffer.toString());
            httpResponse.getWriter().flush();
            return;
        }

        chain.doFilter(request, response);
    }
}
