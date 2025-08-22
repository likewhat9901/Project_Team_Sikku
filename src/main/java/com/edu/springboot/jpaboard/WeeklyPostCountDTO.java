package com.edu.springboot.jpaboard;

import java.time.LocalDateTime;

import lombok.Data;

/*
주간 발행 닐짜, 갯수를 담는 전용 객체 (Controller → Service → Repository로 전달)
*/
@Data
public class WeeklyPostCountDTO {

	private LocalDateTime postdate;
	private int postCount;
	
}
