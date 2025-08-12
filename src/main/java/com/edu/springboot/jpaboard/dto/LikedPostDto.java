package com.edu.springboot.jpaboard.dto;

import java.time.LocalDateTime;

public record LikedPostDto(
        Long boardIdx,
        String title,
        LocalDateTime postdate,
        LocalDateTime likedDate
) {}