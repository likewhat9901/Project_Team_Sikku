package com.edu.springboot.qnaBoard;

import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class QnaBoardService {
	
	@Autowired
    private QnaBoardRepository qnaRepo;
	
	/* ============== qnaBoardList 페이지 ================= */
	// 공지글
    public List<QnaBoardEntity> getNoticeList() {
        return qnaRepo.findByNoticeflagOrderByPostdateDesc("Y");
    }

    // 일반 사용자 QnA 글
    public List<QnaBoardEntity> getQnaList() {
        return qnaRepo.findByNoticeflagOrderByPostdateDesc("N");
    }
    
    // 검색 기능
    public List<QnaBoardEntity> qnaSearch(String type, String keyword) {
    	if ("writer".equals(type)) {
            return qnaRepo.findByWriterContaining(keyword);
        } else if ("title".equals(type)) {
            return qnaRepo.findByTitleContaining(keyword);
        } else if ("content".equals(type)) {
            return qnaRepo.findByContentContaining(keyword);
        } else if ("titleAndContent".equals(type)) {
            return qnaRepo.findByTitleContainingOrContentContaining(keyword, keyword);
        }
        return Collections.emptyList();
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
