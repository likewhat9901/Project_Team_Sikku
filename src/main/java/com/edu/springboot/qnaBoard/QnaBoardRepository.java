package com.edu.springboot.qnaBoard;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface QnaBoardRepository extends JpaRepository<QnaBoardEntity, Long> {
	
	/*================ QnaBoardList =======================*/
    // 글 목록 가져오기 (noticeflag = 'Y' or 'N')
    List<QnaBoardEntity> findByNoticeflagOrderByPostdateDesc(String noticeflag);

    // 작성자 or 제목 or 내용 or 제목+내용 검색
    List<QnaBoardEntity> findByWriterContaining(String keyword);
    List<QnaBoardEntity> findByTitleContaining(String keyword);
    List<QnaBoardEntity> findByContentContaining(String keyword);
    List<QnaBoardEntity> findByTitleContainingOrContentContaining(String titleKeyword, String contentKeyword);
    
    /*================ QnaBoardView =======================*/
    // findById(Long idx)는 JpaRepository 기본 메서드 사용.
    
    
    
    /*================ QnaBoardWrite =======================*/
    
}
