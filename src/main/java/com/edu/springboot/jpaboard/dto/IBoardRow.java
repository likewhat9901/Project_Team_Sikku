package com.edu.springboot.jpaboard.dto;

import java.time.LocalDateTime;

public interface IBoardRow {
    Long getBoardIdx();
    String getTitle();
    LocalDateTime getPostdate();
    Long getLikeCount();
}
