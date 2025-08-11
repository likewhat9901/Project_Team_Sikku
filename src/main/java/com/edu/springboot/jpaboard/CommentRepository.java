package com.edu.springboot.jpaboard;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.edu.springboot.jpaboard.BoardEntity;

public interface CommentRepository extends JpaRepository<CommentEntity, Long> {
    // 기본적인 CRUD + findAll(Sort sort) 등 제공
	
	
	// 게시물 기준으로 댓글 조회하기
	List<CommentEntity> findByBoard(BoardEntity board);
	
	
	// board 객체 안의 boardIdx 필드를 기준으로 댓글을 조회하는 쿼리 메서드
    List<CommentEntity> findByBoard_BoardIdx(Long boardIdx);
    // commentIdx로 댓글 하나를 찾는 메서드
    Optional<CommentEntity> findById(Long commentIdx);

}
