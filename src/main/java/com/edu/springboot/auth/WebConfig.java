package com.edu.springboot.auth;

import java.nio.file.Paths;
import java.util.concurrent.TimeUnit;

import org.springframework.context.annotation.Configuration;
import org.springframework.http.CacheControl;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    // 운영 환경에 맞게 변경 가능 (프로젝트 밖 경로 권장)
    public static final String UPLOAD_ROOT =
            Paths.get(System.getProperty("user.home"), "app-uploads", "profile").toString();

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // /uploads/profile/** → 파일시스템 경로 매핑
        registry.addResourceHandler("/uploads/profile/**")
                .addResourceLocations("file:" + UPLOAD_ROOT + "/")
                .setCacheControl(CacheControl.noCache())  // 이미지 즉시 반영
                .resourceChain(false);
    }
}