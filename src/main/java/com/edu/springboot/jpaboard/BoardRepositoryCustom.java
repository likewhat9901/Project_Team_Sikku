package com.edu.springboot.jpaboard;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;


/* 커스텀 레포지토리 */
// 1) 인터페이스     (implements 구현체는 따로 BoardRepositoryImpl 클래스 생성.)
// JpaRepository에 없는 "복합 검색" 기능을 확장하기 위해 선언. 여기서는 메서드 시그니처만 정의.
public interface BoardRepositoryCustom {
	
	Page<BoardEntity> searchComplex (Pageable pageable, BoardSearchCondDTO condDTO);

}
