package com.edu.springboot.jpaboard.dto;

import java.time.LocalDateTime;

public record MyCommentDto(
    Long commentIdx,
    Long boardIdx,
    String boardTitle,
    String content,
    LocalDateTime postdate
) {}
