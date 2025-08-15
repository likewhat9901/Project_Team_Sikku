package com.edu.springboot.qnaBoard;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface QnaBoardRepository extends JpaRepository<QnaBoardEntity, Long> {
	
	/*================ QnaBoardList =======================*/
    // 글 목록 가져오기 (noticeflag = 'Y' or 'N')
    List<QnaBoardEntity> findByNoticeflagOrderByPostdateDesc(String noticeflag); // (noticeflag = 'Y')
    Page<QnaBoardEntity> findByNoticeflagOrderByPostdateDesc(String noticeflag, Pageable pageable); // (noticeflag = 'N')
    

    // 작성자 or 제목 or 내용 or 제목+내용 검색
    Page<QnaBoardEntity> findByTitleContainingAndNoticeflag(String keyword, String noticeflag, Pageable pageable);
    Page<QnaBoardEntity> findByContentContainingAndNoticeflag(String keyword, String noticeflag, Pageable pageable);
    Page<QnaBoardEntity> findByWriterContainingAndNoticeflag(String keyword, String noticeflag, Pageable pageable);
    Page<QnaBoardEntity> findByTitleContainingOrContentContainingAndNoticeflag(String titleKeyword, String contentKeyword, String noticeflag, Pageable pageable);
    
    /*================ QnaBoardView =======================*/
    // findById(Long idx)는 JpaRepository 기본 메서드 사용.
    // save, deleteById 기본 메서드
    
    // 관리자 답변
    
    
    
    /*================ QnaBoardWrite =======================*/
    
}
