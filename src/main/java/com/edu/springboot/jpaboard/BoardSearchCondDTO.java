package com.edu.springboot.jpaboard;

import java.time.LocalDateTime;

import lombok.Data;

/*
검색 조건을 담는 전용 객체 (Controller → Service → Repository로 전달)
*/
@Data
public class BoardSearchCondDTO {

	private String title;
	private String content;
	private String userId;
	private LocalDateTime postdate;
	private String searchWord;
	private Integer category;
	
}
