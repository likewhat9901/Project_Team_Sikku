package com.edu.springboot.jpaboard;

import java.util.List;

import org.springframework.data.repository.query.Param;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.edu.springboot.jpaboard.BoardEntity;
import com.edu.springboot.jpaboard.dto.MyPostDto;

public interface BoardRepository extends JpaRepository<BoardEntity, Long> {
    // 기본적인 CRUD + findAll(Sort sort) 등 제공
	
	// 제목 LIKE 검색을 위한 메서드 (예: %검색어%)
    Page<BoardEntity> findByTitleLike(String title, Pageable pageable);
    
    List<BoardEntity> findTop10ByCategoryOrderByLikesDesc(Integer category);
    
    
    
//    // 게시글 내용(content)에 대한 검색
//    Page<BoardEntity> findByContentLike(String content, Pageable pageable);
//
//    // 게시글 제목 또는 내용에서 검색
//    Page<BoardEntity> findByTitleContainingOrContentContaining(String title, String content, Pageable pageable);
//
//    // 특정 작성자의 게시글만
//    Page<BoardEntity> findByWriter(String writer, Pageable pageable);
    
    
    @Query("""
            select new com.edu.springboot.jpaboard.dto.MyPostDto(
                b.boardIdx, b.title, b.postdate
            )
            from BoardEntity b
            where b.userId = :userId
            order by b.postdate desc
        """)
        List<MyPostDto> findMyPosts(@Param("userId") String userId);

    
}
