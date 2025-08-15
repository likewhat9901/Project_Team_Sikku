package com.edu.springboot.qnaBoard;

import java.util.List;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class QnaBoardService {

    private final QnaBoardRepository qnaRepo;

    public List<QnaBoardEntity> getNoticeList() {
        return qnaRepo.findByNoticeflagOrderByPostdateDesc("Y");
    }

    public List<QnaBoardEntity> getQnaList() {
        return qnaRepo.findByNoticeflagOrderByPostdateDesc("N");
    }

    public List<QnaBoardEntity> search(String keyword) {
        return qnaRepo.findByTitleContainingOrContentContaining(keyword, keyword);
    }
}
