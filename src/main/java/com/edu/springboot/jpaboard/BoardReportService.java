package com.edu.springboot.jpaboard;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BoardReportService {
	
	@Autowired
	private BoardReportRepository rr;
	@Autowired 
	private BoardRepository br;

    public void saveReportAndUpdateBoard(BoardReportEntity report) {
        // 1. 신고 저장
        rr.save(report);
        
        // 2. 해당 게시글의 신고 횟수 업데이트
        updateBoardReportCount(report.getBoardIdx());
    }
    
    private void updateBoardReportCount(Long boardIdx) {
        // 신고 횟수 카운트 (Report 테이블에서 신고갯수 세기)
        Long reportCount = rr.countByBoardIdx(boardIdx);
        
        // 해당 게시물 정보를 be로 불러오기
        Optional<BoardEntity> be = br.findById(boardIdx);
        // Optional이 아닌 BoardEntity타입의 변수에 담기
        if(be.isPresent()) {
            BoardEntity board = br.findById(boardIdx).get();
            board.setReport(reportCount.intValue());
            br.save(board);
            System.out.println("게시판테이블에도 report 컬럼에 1증가 완료.");
        }
        
    }
    
    public boolean checkReport(Long boardIdx, String userId) {
    	
    	boolean result = rr.existsByBoardIdxAndUserId(boardIdx, userId);
    	
    	return result;
    }
    
}
