package com.edu.springboot.qnaBoard;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import com.edu.springboot.jpaboard.MemberEntity;
import com.edu.springboot.jpaboard.MemberRepository;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class QnaBoardService {
	
	@Autowired
    private QnaBoardRepository qnaRepo;
	@Autowired
	private MemberRepository memberRepo;
	
	
	/* ============== 공통 ================= */
	// 게시글 찾기
	public QnaBoardEntity getPost(Long idx) {
	    return qnaRepo.findById(idx)
	        .orElseThrow(() -> new IllegalArgumentException("게시글이 없습니다."));
	}
	
	// 유저 권한확인
	public String getAuthorityByUserId(String userId) {
	    return memberRepo.findByUserId(userId)
	        .map(MemberEntity::getAuthority) // 인스턴스 메서드를 참조(람다식의 축약) : map(x -> x.getSomething()) ➝ ClassName::getSomething
	        .orElse("ROLE_USER");
	}
	
	// 비밀글 접근제한
	public boolean canAccessSecret(QnaBoardEntity qna, String userId, String authority) {
	    boolean isAdmin = "ROLE_ADMIN".equals(authority);
	    boolean isOwner = qna.getWriterid().equals(userId);
	    boolean isSecret = "Y".equalsIgnoreCase(qna.getSecretflag());
	    return !isSecret || isOwner || isAdmin; // 비밀글이 아니거나 || 작성자이거나 || 관리자이거나
	}
	
	
	/* ============== qnaBoardList 페이지 ================= */
	// 공지글 (페이징 X)
    public List<QnaBoardEntity> getNoticeList() {
        return qnaRepo.findByNoticeflagOrderByPostdateDesc("Y");
    }

    // 일반 사용자 QnA 글 (페이징 O)
    public Page<QnaBoardEntity> getQnaList(int page, int pageSize) {
        return qnaRepo.findByNoticeflagOrderByPostdateDesc("N",
                PageRequest.of(page - 1, pageSize, Sort.by("idx").descending()));
    }
    
    // 검색 기능 (페이징 O)
    public Page<QnaBoardEntity> qnaSearch(String type, String keyword, int page, int pageSize) {
    	Pageable pageable = PageRequest.of(page - 1, pageSize, Sort.by("idx").descending());
    	
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
    // 본인 글인지 확인
 	public boolean isAuthor(Long idx, String userId) {
 	    QnaBoardEntity post = getPost(idx);
 	    return post.getWriterid().equals(userId);
 	}

    // 답변상태(answerstatus)가 "대기"인것만 가져오기
    public Page<QnaBoardEntity> getQnaByAnswerstatus(int page, int pageSize) {
    	return qnaRepo.findByAnswerstatusOrderByPostdateDesc("대기",
                PageRequest.of(page - 1, pageSize, Sort.by("idx").descending()));
    }
    
    // 조회수 증가
    @Transactional
    public void increaseViews(Long idx) {
        QnaBoardEntity qna = getPost(idx);
        
        qna.setViews(qna.getViews() + 1);
        qnaRepo.save(qna);
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
        QnaBoardEntity qna = getPost(idx);
        
        qna.setAnswercontent(answerContent);
        qna.setUpdatedate(LocalDateTime.now()); // LocalDateTime 사용한다면
        
        if (answerContent != null && !answerContent.trim().isEmpty()) {
            qna.setAnswerstatus("완료");
        }
        else {
        	qna.setAnswerstatus("대기");
        }

        // save 안 해도 됨: JPA는 트랜잭션 안에서 변경 감지(dirty checking)로 자동 업데이트 됨
    }
    
    // 좋아요 기능(+1)
    @Transactional
    public int increaseLikeCount(Long idx) {
        QnaBoardEntity qna = getPost(idx);

        int currentLikes = qna.getLikes() != null ? qna.getLikes() : 0;
        int newLikes = currentLikes + 1;
        qna.setLikes(newLikes);
        
        qnaRepo.save(qna); // DB 반영

        return newLikes; // 최신 좋아요 수 반환
    }
    
    // 좋아요 기능(-1)
    @Transactional
    public int decreaseLikeCount(Long idx) {
        QnaBoardEntity qna = getPost(idx);

        int currentLikes = qna.getLikes() != null ? qna.getLikes() : 0;
        int newLikes = Math.max(0, currentLikes - 1); // 음수 방지
        qna.setLikes(newLikes);
        
        qnaRepo.save(qna);

        return newLikes;
    }

    
    /* ============== qnaBoardWrite 페이지 ================= */
    // 게시글 생성(만들기)
    @Transactional
    public void createPost(QnaBoardEntity qna) {
        if (qna.getSecretflag() == null) qna.setSecretflag("N");
        if (qna.getNoticeflag() == null) qna.setNoticeflag("N");
        qnaRepo.save(qna);
    }
    
}
