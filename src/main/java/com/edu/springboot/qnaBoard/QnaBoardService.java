package com.edu.springboot.qnaBoard;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class QnaBoardService {
	
	@Autowired
    private QnaBoardRepository qnaRepo;
	
	
	/* ============== 공통 ================= */
	public QnaBoardEntity findById(Long idx) {
	    return qnaRepo.findById(idx)
	        .orElseThrow(() -> new IllegalArgumentException("게시글이 없습니다."));
	}
	
	
	/* ============== qnaBoardList 페이지 ================= */
	// 공지글 (페이징 X)
    public List<QnaBoardEntity> getNoticeList() {
        return qnaRepo.findByNoticeflagOrderByPostdateDesc("Y");
    }

    // 일반 사용자 QnA 글 (페이징 O)
    public Page<QnaBoardEntity> getQnaList(int page, int pageSize) {
        return qnaRepo.findByNoticeflagOrderByPostdateDesc("N",
                PageRequest.of(page - 1, pageSize, Sort.by("postdate").descending()));
    }
    
    // 검색 기능 (페이징 O)
    public Page<QnaBoardEntity> qnaSearch(String type, String keyword, int page, int pageSize) {
    	Pageable pageable = PageRequest.of(page - 1, pageSize, Sort.by("	").descending());
    	
    	return switch (type) {
	        case "title" -> qnaRepo.findByTitleContainingAndNoticeflag(keyword, "N", pageable);
	        case "content" -> qnaRepo.findByContentContainingAndNoticeflag(keyword, "N", pageable);
	        case "writer" -> qnaRepo.findByWriterContainingAndNoticeflag(keyword, "N", pageable);
	        case "titleAndContent" ->
	            qnaRepo.findByTitleContainingOrContentContainingAndNoticeflag(keyword, keyword, "N", pageable);
	        default -> Page.empty(pageable);
    	};
    }
    
    /* ============== qnaBoardView 페이지 ================= */
    // 게시물 한개만 가져오기
    public QnaBoardEntity getQnaOneById(Long idx) {
        return qnaRepo.findById(idx).orElse(null);
    }
    
    // 조회수 증가
    @Transactional
    public void increaseViews(Long idx, String userId) {
        QnaBoardEntity qna = qnaRepo.findById(idx).orElse(null);
        if (qna == null) return;

        // 본인이 쓴 글이 아니면만 증가 (선택사항)
        if (!qna.getWriterid().equals(userId)) {
            qna.setViews(qna.getViews() + 1);
            qnaRepo.save(qna);
        }
    }
    
    // 삭제
    public void deletePost(Long idx) {
        qnaRepo.deleteById(idx);
    }
    
    // 관리자 답변
    /* @Transactional은 하나의 작업(트랜잭션)을 묶어서 처리해주는 애야.이게 붙은 메서드는 실행 중 DB에 변경이 생기면,
    메서드가 끝날 때 자동으로 commit 해주고, 중간에 오류 나면 rollback 해줌. -> 자동저장모드 */
    @Transactional
    public void updateAnswer(Long idx, String answerContent) {
        QnaBoardEntity qna = qnaRepo.findById(idx)
                             .orElseThrow(() -> new IllegalArgumentException("해당 글이 없습니다: " + idx));
        
        qna.setAnswercontent(answerContent);
        qna.setUpdatedate(LocalDateTime.now()); // LocalDateTime 사용한다면

        // save 안 해도 됨: JPA는 트랜잭션 안에서 변경 감지(dirty checking)로 자동 업데이트 됨
    }
    
    // 좋아요 기능(+1)
    @Transactional
    public int increaseLikeCount(Long idx) {
        QnaBoardEntity qna = qnaRepo.findById(idx)
            .orElseThrow(() -> new IllegalArgumentException("게시글이 없습니다."));

        int currentLikes = qna.getLikes() != null ? qna.getLikes() : 0;
        int newLikes = currentLikes + 1;
        qna.setLikes(newLikes);
        
        qnaRepo.save(qna); // DB 반영

        return newLikes; // 최신 좋아요 수 반환
    }
    
    // 좋아요 기능(-1)
    public int decreaseLikeCount(Long idx) {
        QnaBoardEntity qna = qnaRepo.findById(idx)
            .orElseThrow(() -> new IllegalArgumentException("게시글이 없습니다."));

        int currentLikes = qna.getLikes() != null ? qna.getLikes() : 0;
        int newLikes = Math.max(0, currentLikes - 1); // 음수 방지
        qna.setLikes(newLikes);
        
        qnaRepo.save(qna);

        return newLikes;
    }

    
    /* ============== qnaBoardWrite 페이지 ================= */
    
}
