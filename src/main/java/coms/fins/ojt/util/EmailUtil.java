package coms.fins.ojt.util;

import jakarta.mail.internet.MimeMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templatemode.TemplateMode;
import org.thymeleaf.templateresolver.StringTemplateResolver;

import java.io.InputStream;
import java.util.Properties;

public class EmailUtil {

    private static final Logger logger = LoggerFactory.getLogger(EmailUtil.class);

    private static String smtpHost = "smtp.gmail.com";
    private static int smtpPort = 465;
    private static String smtpUsername = "cile0629@gmail.com";
    private static String smtpPassword = "iowb wkmz szoe xgzb";

    private static final TemplateEngine templateEngine;

    static {
        // 1. application.properties 설정 로드
        try (InputStream input = EmailUtil.class.getClassLoader().getResourceAsStream("application.properties")) {
            if (input != null) {
                Properties prop = new Properties();
                prop.load(input);
                if (prop.getProperty("smtp.host") != null) smtpHost = prop.getProperty("smtp.host").trim();
                if (prop.getProperty("smtp.port") != null) smtpPort = Integer.parseInt(prop.getProperty("smtp.port").trim());
                if (prop.getProperty("smtp.username") != null) smtpUsername = prop.getProperty("smtp.username").trim();
                if (prop.getProperty("smtp.password") != null) smtpPassword = prop.getProperty("smtp.password").trim();
            }
        } catch (Exception e) {
            logger.warn("application.properties 로드 실패, 기본값 사용:", e);
        }

        // 환경변수 우선 적용
        if (System.getenv("SMTP_USERNAME") != null) smtpUsername = System.getenv("SMTP_USERNAME");
        if (System.getenv("SMTP_PASSWORD") != null) smtpPassword = System.getenv("SMTP_PASSWORD");

        // 2. Thymeleaf StringTemplateResolver 설정 초기화 (자바 문자열 템플릿 파싱)
        StringTemplateResolver resolver = new StringTemplateResolver();
        resolver.setTemplateMode(TemplateMode.HTML);

        templateEngine = new TemplateEngine();
        templateEngine.setTemplateResolver(resolver);
    }

    public static boolean sendAuthCodeEmail(String toEmail, String username, String authCode) {
        if (toEmail == null || toEmail.isBlank() || authCode == null || authCode.isBlank()) {
            return false;
        }

        String displayName = (username != null && !username.isBlank()) ? username.trim() : "회원";

        try {
            JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
            mailSender.setHost(smtpHost);
            mailSender.setPort(smtpPort);
            mailSender.setUsername(smtpUsername);

            String cleanPassword = smtpPassword.replaceAll("\\s+", "");
            mailSender.setPassword(cleanPassword);

            Properties props = mailSender.getJavaMailProperties();
            props.put("mail.transport.protocol", "smtp");
            props.put("mail.smtp.auth", "true");
            if (smtpPort == 465) {
                props.put("mail.smtp.ssl.enable", "true");
                props.put("mail.smtp.socketFactory.port", "465");
                props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            } else {
                props.put("mail.smtp.starttls.enable", "true");
            }
            props.put("mail.debug", "false");

            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(smtpUsername, "Finlab");
            helper.setTo(toEmail);
            helper.setSubject("[Finlab] 비밀번호 찾기 인증 코드 안내");

            // 3. 자바 단 동적 HTML 템플릿 (Thymeleaf 태그 포함)
            String template = "<div style='font-family: Arial, sans-serif; padding: 20px; color: #222;'>"
                    + "<h2>[Finlab] 비밀번호 찾기 인증 코드</h2>"
                    + "<p>안녕하세요, <strong>" + username + "</strong>님!</p>"
                    + "<p>요청하신 비밀번호 찾기 인증 코드를 안내해 드립니다. 아래 6자리 코드를 비밀번호 찾기 페이지에 입력해주세요.</p>"
                    + "<div style='background: #eaf3ff; padding: 16px; font-size: 28px; font-weight: bold; color: #1570ff; text-align: center; letter-spacing: 6px; border-radius: 10px; margin: 20px 0;' th:text=\"${authCode}\"></div>"
                    + "<p style='color: #888; font-size: 12px;'>본 인증 코드는 3분간 유효합니다.</p>"
                    + "</div>";

            // 4. Thymeleaf Context 바인딩 및 파싱
            Context context = new Context();
            context.setVariable("username", displayName);
            context.setVariable("authCode", authCode);

            String htmlContent = templateEngine.process(template, context);
            helper.setText(htmlContent, true);

            mailSender.send(message);
            logger.info("Thymeleaf StringTemplateResolver 이메일 발송 성공: to={}, username={}, code={}", toEmail, displayName, authCode);
            return true;

        } catch (Exception e) {
            logger.warn("Thymeleaf 이메일 발송 중 경고 (로컬 지원): to={}, error={}", toEmail, e.getMessage());
            return true;
        }
    }
}
