package com.edu.springboot.jpaboard;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;


public interface CommentRepositoryCustom {
	
	
	// 주간 댓글 수 통계
	List<WeeklyPostCountDTO> countWeeklyComments();
	
	
	
}
