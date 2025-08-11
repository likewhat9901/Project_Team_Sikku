package com.edu.springboot.jpaboard;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import jakarta.persistence.JoinColumn;




public interface LikeRepository extends JpaRepository<LikeEntity, Long> {
	
	/*
	BoardEntity와 관계 설정 되어 있음.
	
    @JoinColumn(name = "BOARD_IDX", nullable = false)
    private BoardEntity board; 
    
    때문에 아래와 같이 언더바(_)를 통해 메서드 생성.
	*/
    Optional<LikeEntity> findByBoard_BoardIdxAndUserId(Long boardIdx, String userId);
    
    // 해당 게시물(1개)의 좋아요갯수
    Long countByBoard_BoardIdx(Long boardIdx);
}
