package com.edu.springboot.auth;

import java.nio.file.Paths;
import java.util.concurrent.TimeUnit;

import org.springframework.context.annotation.Configuration;
import org.springframework.http.CacheControl;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    // 프로젝트 내부 경로로 변경
    public static final String UPLOAD_ROOT =
            Paths.get(System.getProperty("user.dir"), "src/main/resources/static/uploads/profile").toString();

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/uploads/profile/**")
                .addResourceLocations("file:" + UPLOAD_ROOT + "/")
                .setCacheControl(CacheControl.noCache()) // 캐시 없이 바로 반영
                .resourceChain(false);
    }
}