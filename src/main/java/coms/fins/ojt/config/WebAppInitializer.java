package coms.fins.ojt.config;

import jakarta.servlet.Filter;
import jakarta.servlet.MultipartConfigElement;
import jakarta.servlet.ServletRegistration;
import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

import java.io.File;

public class WebAppInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

    // 최대 파일 크기 (10MB), 최대 요청 크기 (50MB)
    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024L;
    private static final long MAX_REQUEST_SIZE = 50 * 1024 * 1024L;
    private static final int FILE_SIZE_THRESHOLD = 0;

    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class<?>[] { RootConfig.class };
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        return new Class<?>[] { WebConfig.class };
    }

    @Override
    protected String[] getServletMappings() {
        return new String[] { "/" };
    }

    @Override
    protected Filter[] getServletFilters() {
        CharacterEncodingFilter encodingFilter = new CharacterEncodingFilter();
        encodingFilter.setEncoding("UTF-8");
        encodingFilter.setForceEncoding(true);
        return new Filter[] { encodingFilter };
    }

    @Override
    protected void customizeRegistration(ServletRegistration.Dynamic registration) {
        String tempDir = System.getProperty("java.io.tmpdir");
        MultipartConfigElement multipartConfigElement = new MultipartConfigElement(
                tempDir,
                MAX_FILE_SIZE,
                MAX_REQUEST_SIZE,
                FILE_SIZE_THRESHOLD
        );
        registration.setMultipartConfig(multipartConfigElement);
    }
}
