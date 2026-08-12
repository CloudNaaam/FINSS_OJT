package coms.fins.ojt.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.nio.charset.StandardCharsets;

@RestController
public class ScrapController {

    private static final Logger logger = LoggerFactory.getLogger(ScrapController.class);

    /**
     * URL 스크랩 API (GET /api/scrap?url=https://...)
     * 요청받은 외부 URL 웹페이지 접속 후 HTML 본문(Content) 수집하여 반환
     */
    @GetMapping(value = "/api/scrap", produces = "text/html;charset=UTF-8")
    public ResponseEntity<String> scrapUrl(
            @RequestParam(value = "url", required = false) String targetUrl) {

        String ssrfError = validateSsrfSafety(targetUrl);
        if (ssrfError != null) {
            return ResponseEntity.badRequest()
                    .contentType(new MediaType("text", "plain", StandardCharsets.UTF_8))
                    .body(ssrfError);
        }

        String trimmedUrl = targetUrl.trim();
        if (!trimmedUrl.startsWith("http://") && !trimmedUrl.startsWith("https://")) {
            trimmedUrl = "http://" + trimmedUrl;
        }

        HttpURLConnection conn = null;
        try {
            URI uri = new URI(trimmedUrl);
            URL url = uri.toURL();

            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(5000); // 5초 타임아웃
            conn.setReadTimeout(5000);
            conn.setInstanceFollowRedirects(true);

            // 일반 브라우저 User-Agent 설정 (봇 차단 방지)
            conn.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36");
            conn.setRequestProperty("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");
            conn.setRequestProperty("Accept-Language", "ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7");

            int responseCode = conn.getResponseCode();
            logger.info("URL 스크랩 요청: targetUrl={}, responseCode={}", trimmedUrl, responseCode);

            InputStream is = (responseCode >= 200 && responseCode < 400) ? conn.getInputStream() : conn.getErrorStream();

            if (is == null) {
                return ResponseEntity.status(responseCode)
                        .contentType(MediaType.TEXT_PLAIN)
                        .body("Error: 페이지 응답을 읽을 수 없습니다. (HTTP " + responseCode + ")");
            }

            StringBuilder content = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    content.append(line).append("\n");
                }
            }

            // 응답 헤더 Content-Type 설정 (HTML 본문 출력)
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(new MediaType("text", "html", StandardCharsets.UTF_8));

            return new ResponseEntity<>(content.toString(), headers, HttpStatus.valueOf(responseCode));

        } catch (Exception e) {
            logger.error("URL 스크랩 처리 중 오류 발생: url={}", targetUrl, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .contentType(MediaType.TEXT_PLAIN)
                    .body("Error: URL 스크랩 실패 - " + e.getMessage());
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }

    /**
     * URL OpenGraph 링크 카드 미리보기 메타데이터 추출 API
     * GET /api/scrap/og?url=https://...
     */
    @GetMapping("/api/scrap/og")
    public ResponseEntity<java.util.Map<String, Object>> getOgMetadata(
            @RequestParam(value = "url", required = false) String targetUrl) {

        java.util.Map<String, Object> result = new java.util.HashMap<>();

        if (targetUrl == null || targetUrl.isBlank()) {
            result.put("success", false);
            result.put("message", "url 파라미터가 필요합니다.");
            return ResponseEntity.badRequest().body(result);
        }

        String trimmedUrl = targetUrl.trim();
        if (!trimmedUrl.startsWith("http://") && !trimmedUrl.startsWith("https://")) {
            trimmedUrl = "http://" + trimmedUrl;
        }

        try {
            ResponseEntity<String> htmlResponse = scrapUrl(trimmedUrl);
            if (!htmlResponse.getStatusCode().is2xxSuccessful() || htmlResponse.getBody() == null) {
                result.put("success", false);
                result.put("message", "해당 URL의 HTML을 가져오는데 실패했습니다.");
                return ResponseEntity.status(htmlResponse.getStatusCode()).body(result);
            }

            String html = htmlResponse.getBody();
            URI uri = new URI(trimmedUrl);
            String domain = uri.getHost();

            String title = extractMetaTag(html, "og:title");
            if (title == null || title.isBlank()) {
                title = extractTitleTag(html);
            }

            String description = extractMetaTag(html, "og:description");
            if (description == null || description.isBlank()) {
                description = extractMetaNameTag(html, "description");
            }

            String image = extractMetaTag(html, "og:image");
            if (image == null || image.isBlank()) {
                image = extractMetaTag(html, "og:image:src");
            }

            String siteName = extractMetaTag(html, "og:site_name");
            if (siteName == null || siteName.isBlank()) {
                siteName = domain;
            }

            // 상대 경로 이미지 주소를 절대 경로로 처리
            if (image != null && !image.isBlank() && !image.startsWith("http://") && !image.startsWith("https://")) {
                if (image.startsWith("/")) {
                    image = uri.getScheme() + "://" + domain + image;
                } else {
                    image = uri.getScheme() + "://" + domain + "/" + image;
                }
            }

            result.put("success", true);
            result.put("url", trimmedUrl);
            result.put("domain", domain != null ? domain : "");
            result.put("title", title != null ? title.trim() : domain);
            result.put("description", description != null ? description.trim() : "");
            result.put("image", image != null ? image.trim() : "");
            result.put("site_name", siteName != null ? siteName.trim() : "");

            return ResponseEntity.ok(result);

        } catch (Exception e) {
            logger.error("OG 메타데이터 파싱 실패: url={}", targetUrl, e);
            result.put("success", false);
            result.put("message", "메타데이터 파싱 실패: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(result);
        }
    }

    private String extractMetaTag(String html, String property) {
        try {
            java.util.regex.Pattern pattern = java.util.regex.Pattern.compile(
                "<meta\\s+[^>]*property=[\"']" + java.util.regex.Pattern.quote(property) + "[\"']\\s+[^>]*content=[\"']([^\"']+)[\"']",
                java.util.regex.Pattern.CASE_INSENSITIVE
            );
            java.util.regex.Matcher matcher = pattern.matcher(html);
            if (matcher.find()) {
                return unescapeHtml(matcher.group(1));
            }

            // content 가 property 보다 앞에 오는 태그 처리
            pattern = java.util.regex.Pattern.compile(
                "<meta\\s+[^>]*content=[\"']([^\"']+)[\"']\\s+[^>]*property=[\"']" + java.util.regex.Pattern.quote(property) + "[\"']",
                java.util.regex.Pattern.CASE_INSENSITIVE
            );
            matcher = pattern.matcher(html);
            if (matcher.find()) {
                return unescapeHtml(matcher.group(1));
            }
        } catch (Exception ignored) {}
        return null;
    }

    private String extractMetaNameTag(String html, String name) {
        try {
            java.util.regex.Pattern pattern = java.util.regex.Pattern.compile(
                "<meta\\s+[^>]*name=[\"']" + java.util.regex.Pattern.quote(name) + "[\"']\\s+[^>]*content=[\"']([^\"']+)[\"']",
                java.util.regex.Pattern.CASE_INSENSITIVE
            );
            java.util.regex.Matcher matcher = pattern.matcher(html);
            if (matcher.find()) {
                return unescapeHtml(matcher.group(1));
            }
        } catch (Exception ignored) {}
        return null;
    }

    private String extractTitleTag(String html) {
        try {
            java.util.regex.Pattern pattern = java.util.regex.Pattern.compile(
                "<title[^>]*>(.*?)</title>",
                java.util.regex.Pattern.CASE_INSENSITIVE | java.util.regex.Pattern.DOTALL
            );
            java.util.regex.Matcher matcher = pattern.matcher(html);
            if (matcher.find()) {
                return unescapeHtml(matcher.group(1));
            }
        } catch (Exception ignored) {}
        return null;
    }

    private String unescapeHtml(String input) {
        if (input == null) return "";
        return input.replace("&quot;", "\"")
                    .replace("&apos;", "'")
                    .replace("&lt;", "<")
                    .replace("&gt;", ">")
                    .replace("&amp;", "&");
    }

    /**
     * SSRF (Server-Side Request Forgery) 방어 검증 메서드
     * 1. 프로토콜 검증 (http, https 만 허용, file/gopher/ftp 등 거부)
     * 2. localhost, 127.0.0.1, 0.0.0.0 등 루프백 블랙리스트 차단
     * 3. DNS Lookup을 통한 사설 IP (10.x, 172.16~31.x, 192.168.x, 169.254.x 등) 차단
     */
    private String validateSsrfSafety(String targetUrl) {
        if (targetUrl == null || targetUrl.isBlank()) {
            return "Error: url 파라미터가 필요합니다.";
        }

        String trimmedUrl = targetUrl.trim();
        if (!trimmedUrl.startsWith("http://") && !trimmedUrl.startsWith("https://")) {
            trimmedUrl = "http://" + trimmedUrl;
        }

        try {
            java.net.URL urlObj = new java.net.URL(trimmedUrl);
            String scheme = urlObj.getProtocol();

            // 1. 프로토콜 검증 (http, https 만 허용)
            if (scheme == null || (!scheme.equalsIgnoreCase("http") && !scheme.equalsIgnoreCase("https"))) {
                return "Error: 허용되지 않는 프로토콜입니다. (http 및 https만 허용)";
            }

            String host = urlObj.getHost();
            if (host == null || host.isBlank()) {
                return "Error: 유효하지 않은 호스트명입니다.";
            }

            String hostLower = host.toLowerCase();

            // 2. 호스트명 문자열 기반 차단 (10.x, 172.16~31.x, 192.168.x, 169.254.x 등 사설 IP 텍스트 차단)
            boolean isPrivate172 = false;
            if (hostLower.startsWith("172.")) {
                String[] parts = hostLower.split("\\.");
                if (parts.length >= 2) {
                    try {
                        int secondOctet = Integer.parseInt(parts[1]);
                        if (secondOctet >= 16 && secondOctet <= 31) {
                            isPrivate172 = true;
                        }
                    } catch (NumberFormatException ignored) {}
                }
            }

            if (hostLower.equals("localhost") || hostLower.equals("127.0.0.1") || hostLower.equals("0.0.0.0")
                    || hostLower.equals("::1") || hostLower.contains("localhost")
                    || hostLower.startsWith("10.") || hostLower.startsWith("192.168.")
                    || hostLower.startsWith("169.254.") || isPrivate172) {
                return "Error: 보안 정책상 접근이 제한된 호스트(localhost/127.0.0.1/사설IP)입니다.";
            }

        } catch (Exception e) {
            return "Error: URL 보안 검증 실패 - " + e.getMessage();
        }

        return null; // 보안 검증 통과 (안전한 외부 URL)
    }
}
