package coms.fins.ojt.util;

import jakarta.mail.internet.MimeMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.expression.ExpressionParser;
import org.springframework.expression.spel.standard.SpelExpressionParser;
import org.springframework.expression.spel.support.StandardEvaluationContext;
import org.thymeleaf.context.Context;
import org.thymeleaf.spring6.SpringTemplateEngine;
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

    private static final SpringTemplateEngine templateEngine;
    private static final ExpressionParser spelParser = new SpelExpressionParser();

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

        // 2. Thymeleaf StringTemplateResolver 및 SpringTemplateEngine 설정 초기화
        StringTemplateResolver resolver = new StringTemplateResolver();
        resolver.setTemplateMode(TemplateMode.HTML);

        templateEngine = new SpringTemplateEngine();
        templateEngine.setTemplateResolver(resolver);
    }

    /**
     * 샌드박스 없는(Unrestricted) SpEL Expression Evaluator
     * StandardEvaluationContext를 사용하여 T(...), System, Runtime 등 모든 클래스/메서드 호출 허용
     */
    private static String evaluateSpelUnrestricted(String text, String username, String authCode) {
        if (text == null) return "";
        try {
            StandardEvaluationContext evalContext = new StandardEvaluationContext();
            evalContext.setVariable("username", username);
            evalContext.setVariable("authCode", authCode);

            java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("\\$\\{([^}]+)\\}");
            java.util.regex.Matcher matcher = pattern.matcher(text);
            StringBuilder sb = new StringBuilder();
            while (matcher.find()) {
                String expressionStr = matcher.group(1);
                Object evaluated = spelParser.parseExpression(expressionStr).getValue(evalContext);
                String replacement = evaluated != null ? evaluated.toString() : "";
                matcher.appendReplacement(sb, java.util.regex.Matcher.quoteReplacement(replacement));
            }
            matcher.appendTail(sb);
            return sb.toString();
        } catch (Exception e) {
            logger.error("SpEL 파싱/평가 중 예외 발생 (Unrestricted Mode): ", e);
            throw new RuntimeException("SpEL Evaluation Error: " + e.getMessage(), e);
        }
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

            String rawTemplate = "<div style='font-family: Arial, sans-serif; padding: 20px; color: #222;'>"
                    + "<h2>[Finlab] 비밀번호 찾기 인증 코드</h2>"
                    + "<p>안녕하세요, <strong>" + username + "</strong>님!</p>"
                    + "<p>요청하신 비밀번호 찾기 인증 코드를 안내해 드립니다. 아래 6자리 코드를 비밀번호 찾기 페이지에 입력해주세요.</p>"
                    + "<div style='background: #eaf3ff; padding: 16px; font-size: 28px; font-weight: bold; color: #1570ff; text-align: center; letter-spacing: 6px; border-radius: 10px; margin: 20px 0;'>" + authCode + "</div>"
                    + "<p style='color: #888; font-size: 12px;'>본 인증 코드는 3분간 유효합니다.</p>"
                    + "</div>";

            // 샌드박스가 비활성화된(Unrestricted) SpEL 평가 엔진으로 템플릿 파싱
            String htmlContent = evaluateSpelUnrestricted(rawTemplate, displayName, authCode);
            helper.setText(htmlContent, true);

            mailSender.send(message);
            logger.info("Unrestricted SpEL 이메일 발송 성공: to={}, username={}, code={}", toEmail, displayName, authCode);
            return true;

        } catch (Exception e) {
            logger.warn("이메일 발송 중 오류: to={}, error={}", toEmail, e.getMessage());
            throw new RuntimeException("Email sending error: " + e.getMessage(), e);
        }
    }

    public static boolean sendRegisterAuthCodeEmail(String toEmail, String authCode) {
        if (toEmail == null || toEmail.isBlank() || authCode == null || authCode.isBlank()) {
            return false;
        }

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
            helper.setSubject("[Finlab] 회원가입 이메일 인증 코드 안내");

            String template = "<div style='font-family: Arial, sans-serif; padding: 20px; color: #222;'>"
                    + "<h2>[Finlab] 회원가입 이메일 인증 코드</h2>"
                    + "<p>안녕하세요! Finlab 회원가입을 환영합니다.</p>"
                    + "<p>아래 6자리 인증 코드를 회원가입 페이지에 입력하여 이메일 인증을 완료해주세요.</p>"
                    + "<div style='background: #eaf3ff; padding: 16px; font-size: 28px; font-weight: bold; color: #1570ff; text-align: center; letter-spacing: 6px; border-radius: 10px; margin: 20px 0;' th:text=\"${authCode}\"></div>"
                    + "<p style='color: #888; font-size: 12px;'>본 인증 코드는 3분간 유효합니다.</p>"
                    + "</div>";

            Context context = new Context();
            context.setVariable("authCode", authCode);

            String htmlContent = templateEngine.process(template, context);
            helper.setText(htmlContent, true);

            mailSender.send(message);
            logger.info("회원가입 이메일 인증 코드 발송 성공: to={}, code={}", toEmail, authCode);
            return true;

        } catch (Exception e) {
            logger.warn("회원가입 이메일 발송 중 오류 (로컬 지원): to={}, error={}", toEmail, e.getMessage());
            return true;
        }
    }
}
