package coms.fins.ojt.config;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletRequestWrapper;
import jakarta.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.regex.Pattern;

public class SqlInjectionFilter implements Filter {

    private static final Logger logger = LoggerFactory.getLogger(SqlInjectionFilter.class);

    // 1. SQL Injection: UNION SELECT, OR 1=1, Time-based sleep (주석 --, /* 감지 제외)
    private static final List<Pattern> SQL_INJECTION_PATTERNS = List.of(
            Pattern.compile("union\\s+select", Pattern.CASE_INSENSITIVE),
            Pattern.compile("or\\s+['\"]?1['\"]?\\s*=\\s*['\"]?1", Pattern.CASE_INSENSITIVE),
            Pattern.compile("sleep\\s*\\(|benchmark\\s*\\(", Pattern.CASE_INSENSITIVE)
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        if (!(request instanceof HttpServletRequest) || !(response instanceof HttpServletResponse)) {
            chain.doFilter(request, response);
            return;
        }

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // 1. URL Query Parameter 및 Form Parameter 검사
        Map<String, String[]> paramMap = httpRequest.getParameterMap();
        for (Map.Entry<String, String[]> entry : paramMap.entrySet()) {
            String paramName = entry.getKey();
            for (String value : entry.getValue()) {
                if (isSqlInjection(value)) {
                    logger.warn("[SqlInjectionFilter] SQL Injection 패턴 감지! URI: {}, Parameter: '{}' -> Value: '{}'",
                            httpRequest.getRequestURI(), paramName, value);
                    blockRequest(httpResponse);
                    return;
                }
            }
        }

        // 2. JSON Body 요청인 경우 Body 내용 검사
        String contentType = httpRequest.getContentType();
        if (contentType != null && contentType.toLowerCase().contains("application/json")) {
            CachedBodyHttpServletRequest wrappedRequest = new CachedBodyHttpServletRequest(httpRequest);
            String body = wrappedRequest.getBody();
            if (isSqlInjection(body)) {
                logger.warn("[SqlInjectionFilter] SQL Injection 패턴 감지 (JSON Body)! URI: {}, Body: '{}'",
                        httpRequest.getRequestURI(), body);
                blockRequest(httpResponse);
                return;
            }
            chain.doFilter(wrappedRequest, response);
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean isSqlInjection(String input) {
        if (input == null || input.isBlank()) {
            return false;
        }
        for (Pattern pattern : SQL_INJECTION_PATTERNS) {
            if (pattern.matcher(input).find()) {
                return true;
            }
        }
        return false;
    }

    private void blockRequest(HttpServletResponse response) throws IOException {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write("{\"success\":false,\"message\":\"SQL Injection 패턴이 감지되었습니다.\"}");
    }

    // JSON Body 반복 조회를 위한 HttpServletRequestWrapper
    private static class CachedBodyHttpServletRequest extends HttpServletRequestWrapper {
        private final byte[] cachedBody;

        public CachedBodyHttpServletRequest(HttpServletRequest request) throws IOException {
            super(request);
            InputStream requestInputStream = request.getInputStream();
            this.cachedBody = requestInputStream.readAllBytes();
        }

        public String getBody() {
            return new String(this.cachedBody, StandardCharsets.UTF_8);
        }

        @Override
        public ServletInputStream getInputStream() {
            return new CachedBodyServletInputStream(this.cachedBody);
        }

        @Override
        public BufferedReader getReader() {
            ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(this.cachedBody);
            return new BufferedReader(new InputStreamReader(byteArrayInputStream, StandardCharsets.UTF_8));
        }
    }

    private static class CachedBodyServletInputStream extends ServletInputStream {
        private final ByteArrayInputStream cachedBodyInputStream;

        public CachedBodyServletInputStream(byte[] cachedBody) {
            this.cachedBodyInputStream = new ByteArrayInputStream(cachedBody);
        }

        @Override
        public boolean isFinished() {
            return cachedBodyInputStream.available() == 0;
        }

        @Override
        public boolean isReady() {
            return true;
        }

        @Override
        public void setReadListener(ReadListener readListener) {}

        @Override
        public int read() {
            return cachedBodyInputStream.read();
        }
    }
}
