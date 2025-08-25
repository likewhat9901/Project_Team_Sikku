package com.edu.springboot.jpaboard;

import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/*
주간 인기글 TOP5 정보를 담는 전용 객체 (Controller → Service → Repository로 전달)
*/
@Data
@AllArgsConstructor
@NoArgsConstructor
public class WeeklyTop5PostDTO {

    private Long boardIdx;
    private String title;
    private Integer visitcount;
	private LocalDate postdate;
	private Integer category;
	
}
