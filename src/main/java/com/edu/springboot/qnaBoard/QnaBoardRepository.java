package com.edu.springboot.qnaBoard;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface QnaBoardRepository extends JpaRepository<QnaBoardEntity, Long> {

    // 공지글 목록 (noticeflag = 'Y' or 'N')
    List<QnaBoardEntity> findByNoticeflagOrderByPostdateDesc(String noticeflag);

    // 제목 or 내용 검색도 추가 가능
    List<QnaBoardEntity> findByTitleContainingOrContentContaining(String keyword1, String keyword2);
}
