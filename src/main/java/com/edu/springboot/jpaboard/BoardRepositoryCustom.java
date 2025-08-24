package com.edu.springboot.jpaboard;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;


/* 커스텀 레포지토리 */
// 1) 인터페이스     (implements 구현체는 따로 BoardRepositoryImpl 클래스 생성.)
public interface BoardRepositoryCustom {
	
	// JpaRepository에 없는 "복합 검색" 기능을 확장하기 위해 선언. 여기서는 메서드 시그니처만 정의.
	Page<BoardEntity> searchComplex (Pageable pageable, BoardSearchCondDTO condDTO);

	
	
	// 주간 게시글 수 통계
	List<WeeklyPostCountDTO> countWeeklyPosts();
	
	// 주간 인기글(조회수) TOP5 통계
	List<WeeklyTop5PostDTO> findWeeklyTop5Posts();
	
	
	
	
	
}
