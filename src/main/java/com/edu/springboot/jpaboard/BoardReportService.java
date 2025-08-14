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
        // 신고 횟수 카운트 (BoardReportRepository)
        Long reportCount = rr.countByBoardIdx(boardIdx);
        
        // board 테이블 업데이트 (BoardRepository)
        Optional<BoardEntity> boardOpt = br.findById(boardIdx);  // br 사용!
        if (boardOpt.isPresent()) {
            BoardEntity board = boardOpt.get();
            board.setReport(reportCount.intValue());
            br.save(board);  // br 사용!
        }
    }
}
