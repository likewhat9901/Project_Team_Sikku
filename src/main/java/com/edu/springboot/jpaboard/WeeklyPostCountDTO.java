package com.edu.springboot.jpaboard;

import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/*
주간 발행 닐짜, 갯수를 담는 전용 객체 (Controller → Service → Repository로 전달)
*/
@Data
@AllArgsConstructor
@NoArgsConstructor
public class WeeklyPostCountDTO {

	private LocalDate postdate;
	private Long postCount;
	
}
