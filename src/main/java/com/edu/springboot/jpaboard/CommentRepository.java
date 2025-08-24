package com.edu.springboot.jpaboard;

import java.util.List;
import java.util.Optional;

import org.springframework.data.repository.query.Param;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.edu.springboot.jpaboard.BoardEntity;
import com.edu.springboot.jpaboard.dto.MyCommentDto;

public interface CommentRepository extends JpaRepository<CommentEntity, Long>,
														CommentRepositoryCustom {
	
	
	// 게시물 기준으로 댓글 조회하기
	List<CommentEntity> findByBoard(BoardEntity board);
	
	
	// board 객체 안의 boardIdx 필드를 기준으로 댓글을 조회하는 쿼리 메서드
	/* CommentEntity 안에 boardIdx라는 필드가 직접 존재하지 않으므로 (외래키로 연결되었음)
	언더바(_)를 이용해서 쿼리 메서드를 작성.*/
    List<CommentEntity> findByBoard_BoardIdx(Long boardIdx);
    // commentIdx로 댓글 하나를 찾는 메서드
    Optional<CommentEntity> findById(Long commentIdx);
    
    @Query("""
            SELECT new com.edu.springboot.jpaboard.dto.MyCommentDto(
                c.commentIdx,
                b.boardIdx,
                b.title,
                c.content,
                c.postdate
            )
            FROM CommentEntity c
            JOIN c.board b
            WHERE c.member.userId = :userId
            ORDER BY c.postdate DESC
        """)
        List<MyCommentDto> findMyComments(@Param("userId") String userId);
    
    
    int countByBoard_BoardIdx(Long boardIdx);

}
