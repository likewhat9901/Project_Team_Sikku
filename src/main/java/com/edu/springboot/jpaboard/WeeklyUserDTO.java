package com.edu.springboot.jpaboard;

import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/*
게시물, 댓글 발행량이 많은 TOP5 사용자 정보를 담는 전용 객체 (Controller → Service → Repository로 전달)
*/
@Data
@AllArgsConstructor
@NoArgsConstructor
public class WeeklyUserDTO {

    private String userId;
    private Long postCount;
    private Long commentCount;
	
}
