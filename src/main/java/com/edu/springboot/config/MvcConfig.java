package com.edu.springboot.config;

import java.nio.file.Paths;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class MvcConfig implements WebMvcConfigurer {

	public static final String PLANTDICT_UPLOAD_ROOT =
            Paths.get(System.getProperty("user.dir"), "uploads", "plantdict")
                 .toAbsolutePath().toString();

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/uploads/plantdict/**")
                .addResourceLocations("file:" + PLANTDICT_UPLOAD_ROOT + "/");
    }

}
