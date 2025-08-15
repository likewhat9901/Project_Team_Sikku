package com.edu.springboot.qnaBoard;

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
    
    /* ============== qnaBoardWrite 페이지 ================= */
    
}
