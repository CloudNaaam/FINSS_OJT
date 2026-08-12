package coms.fins.ojt.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;

@Configuration
@EnableWebMvc
@PropertySource("classpath:application.properties")
@ComponentScan(basePackages = "coms.fins.ojt")
public class WebConfig implements WebMvcConfigurer {

    @Value("${admin.base.path:C:/Users/FINS/uploads}")
    private String adminBasePath;

    @Bean
    public InternalResourceViewResolver viewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setViewClass(JstlView.class);
        resolver.setPrefix("/WEB-INF/views/");
        resolver.setSuffix(".jsp");
        return resolver;
    }

    @Bean
    public MultipartResolver multipartResolver() {
        return new StandardServletMultipartResolver();
    }

    public String getAdminBasePath() {
        if (adminBasePath != null && !adminBasePath.isBlank()) {
            return adminBasePath.trim();
        }
        return "C:/Users/FINS/uploads";
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("/resources/");

        String basePath = getAdminBasePath();
        String fileLocation = basePath.endsWith("/") ? "file:///" + basePath : "file:///" + basePath + "/";
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(fileLocation, "/uploads/");
    }

    @Override
    public void addInterceptors(org.springframework.web.servlet.config.annotation.InterceptorRegistry registry) {
        registry.addInterceptor(new JwtInterceptor())
                .addPathPatterns("/api/**");

        registry.addInterceptor(new AuthCookieInterceptor())
                .addPathPatterns("/mypage", "/mypage/**", "/board/write");

        registry.addInterceptor(new CsrfInterceptor())
                .addPathPatterns("/api/**");
    }

    @Override
    public void addCorsMappings(org.springframework.web.servlet.config.annotation.CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("http://192.168.21.218:8080", "http://192.168.21.218:8082", "http://localhost:8080", "http://localhost:8082")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true);
    }
}
