package com.edu.springboot.jpaboard;

import java.util.List;
import java.util.Optional;

import org.springframework.data.repository.query.Param;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.edu.springboot.jpaboard.dto.LikedPostDto;

import jakarta.persistence.JoinColumn;




public interface LikeRepository extends JpaRepository<LikeEntity, Long> {
	
	/*
	BoardEntity와 관계 설정 되어 있음.
	
    @JoinColumn(name = "BOARD_IDX", nullable = false)
    private BoardEntity board; 
    
    때문에 아래와 같이 언더바(_)를 통해 메서드 생성.
	*/
    Optional<LikeEntity> findByBoard_BoardIdxAndUserId(Long boardIdx, String userId);
    
    boolean existsByBoard_BoardIdxAndUserId(Long boardIdx, String userId);
    
    // 해당 게시물(1개)의 좋아요갯수
    Long countByBoard_BoardIdx(Long boardIdx);
    
    // 내가 좋아요 누른 게시글 조회(최신순)
    @Query("""
            select new com.edu.springboot.jpaboard.dto.LikedPostDto(
                l.board.boardIdx, l.board.title, l.board.postdate, l.likedDate
            )
            from LikeEntity l
            where l.userId = :userId
            order by l.likedDate desc
            """)
     List<LikedPostDto> findLikedPostsByUser(@Param("userId") String userId);
}
