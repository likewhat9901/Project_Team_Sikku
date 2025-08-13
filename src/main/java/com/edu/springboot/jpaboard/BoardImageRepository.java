package com.edu.springboot.jpaboard;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface BoardImageRepository extends JpaRepository<BoardImageEntity, Long> {
	
	// 게시물을 기준으로 이미지 조회하기.
    List<BoardImageEntity> findByBoard(BoardEntity board);
    
    // 게시물 엔티티를 미리 조회하지 않고도, 단순히 게시물 ID 값만으로 이미지를 조회할 수 있음.
    List<BoardImageEntity> findByBoard_BoardIdx(Long boardIdx);
}
