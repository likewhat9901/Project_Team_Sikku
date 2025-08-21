package com.edu.springboot.jpaboard.dto;

import java.time.LocalDateTime;

public record MyPostDto(Long boardIdx, String title, LocalDateTime postdate) 
{
	
}
