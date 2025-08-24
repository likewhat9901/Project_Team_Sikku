package com.edu.springboot.jpaboard;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import com.edu.springboot.jpaboard.dto.MyCommentDto;


@Service
public class CommentService {
	
	//DAO역할의 인터페이스
	@Autowired
	private CommentRepository cr;
	@Autowired
	private BoardRepository br;
	@Autowired
	private MemberRepository mr;
	
    @Autowired
    private CommentRepository commentRepository;
	
	// 게시물 기준으로 댓글 조회
	public List<CommentEntity> findByBoardIdx(Long boardIdx) {
	    return cr.findByBoard_BoardIdx(boardIdx);
	}
	
	public void insertPost(Long boardIdx, String userId, String content) {
		// 데이터베이스에서 실제 엔티티 조회
		BoardEntity board = br.findById(boardIdx)
				.orElseThrow(() -> new IllegalArgumentException("Invalid board Id: " + boardIdx));
		
		MemberEntity member = mr.findByUserId(userId)
				.orElseThrow(() -> new IllegalArgumentException("Invalid user Id: " + userId));
		
		// 댓글 엔티티 생성
		CommentEntity comment = CommentEntity.builder()
				.board(board)
				.member(member)
				.content(content)
				.likes(0)
				.build();
		
		cr.save(comment);
	}
	
	
    // 댓글 수정
	public void updatePost(Long commentIdx, Long boardIdx, String userId, String content) {
		// 기존 댓글 조회
		CommentEntity existingComment = cr.findById(commentIdx)
				.orElseThrow(() -> new IllegalArgumentException("Invalid comment Id: " + commentIdx));
		
		// 내용만 수정 (board와 member는 그대로 유지)
		existingComment.setContent(content);
		
		cr.save(existingComment);
	}

    // 댓글 삭제
    public void deletePost(Long commentIdx) {
        cr.deleteById(commentIdx);
    }
    

    public List<MyCommentDto> getMyComments(String userId) {
        return commentRepository.findMyComments(userId);
    }
    
    /**********************************************************************/
    
    // 최근 7일 게시글 통계 가져오기
    public List<WeeklyPostCountDTO> getWeeklyComments() {
    	return cr.countWeeklyComments();
    }
	
}