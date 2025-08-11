package com.edu.springboot.jpaboard;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

@Service
public class CommentService {
	
	//DAO역할의 인터페이스
	@Autowired
	private CommentRepository cr;
	
	
	// 목록 (검색어X)
	public Page<CommentEntity> selectList(Pageable pageable) {
		Page<CommentEntity> commentRows = cr.findAll(pageable);
		return commentRows;
	}
	
	// 게시물 기준으로 댓글 조회.
	public List<CommentEntity> findByBoardIdx(Long boardIdx) {
		// 조회를 위한 '검색 조건' 역할을 하는 임시 객체
	    BoardEntity board = new BoardEntity();
	    board.setBoardIdx(boardIdx);
	    return cr.findByBoard(board);
	}
	
	/* 오류 발생
	 -> 댓글 저장할 때 board, member 객체를 반드시 세팅해야 DB에 들어감. */
	// 댓글 쓰기
	public void insertPost(CommentEntity ce, BoardEntity be, MemberEntity me) {
		ce.setBoard(be); // 댓글에 게시물 연결!
		ce.setMember(me); // 댓글에 멤버 연결!
		cr.save(ce);
	}
	
    // 댓글 하나를 조회하는 메서드
    public CommentEntity selectComment(Long commentIdx) {
        // findById는 Optional<T>를 반환하므로, orElseThrow()로 값을 가져오거나 예외 처리를 해야 합니다.
        return cr.findById(commentIdx).orElseThrow(() -> new IllegalArgumentException("Invalid comment Id:" + commentIdx));
    }
	
    // 댓글 수정
    public void updatePost(CommentEntity ce, BoardEntity be, MemberEntity me) {
		ce.setBoard(be);
		ce.setMember(me);
        cr.save(ce);
    }

    // 댓글 삭제
    public void deletePost(Long commentIdx) {
        cr.deleteById(commentIdx);
    }
	
}