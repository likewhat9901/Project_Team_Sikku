package com.edu.springboot.jpaboard;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.edu.springboot.jpaboard.BoardEntity;

public interface BoardRepository extends JpaRepository<BoardEntity, Long> {
    // 기본적인 CRUD + findAll(Sort sort) 등 제공
	
	// 카테고리를 기준으로 데이터 가져오기
	Page<BoardEntity> findByCategory(Pageable pageable, Integer category);
	
	// 제목 LIKE 검색을 위한 메서드 (예: %검색어%)
	Page<BoardEntity> findByCategoryAndTitleLike(Integer category, String title, Pageable pageable);
    
	
	
    List<BoardEntity> findTop10ByCategoryOrderByLikesDesc(Integer category);
    
    
    
//    // 게시글 내용(content)에 대한 검색
//    Page<BoardEntity> findByContentLike(String content, Pageable pageable);
//
//    // 게시글 제목 또는 내용에서 검색
//    Page<BoardEntity> findByTitleContainingOrContentContaining(String title, String content, Pageable pageable);
//
//    // 특정 작성자의 게시글만
//    Page<BoardEntity> findByWriter(String writer, Pageable pageable);

    
}
