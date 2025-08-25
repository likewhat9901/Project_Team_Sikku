package com.edu.springboot.jpaboard;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;


public interface MemberRepositoryCustom {
	
	// 주간 게시물,댓글 발행량이 많은 TOP5 유저 통계
	List<WeeklyUserDTO> findWeeklyUsers();
	
}
