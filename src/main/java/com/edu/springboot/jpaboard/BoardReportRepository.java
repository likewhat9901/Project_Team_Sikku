package com.edu.springboot.jpaboard;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface BoardReportRepository extends JpaRepository<BoardReportEntity, Long>{

	 
	Long countByBoardIdx(Long boardIdx);
	
    // 특정 사용자가 특정 게시글을 이미 신고했는지 확인
    boolean existsByBoardIdxAndUserId(Long boardIdx, String userId);
    
    // 특정 게시글의 모든 신고 내역 조회 (최신순)
    List<BoardReportEntity> findByBoardIdxOrderByReportDateDesc(Long boardIdx);

    // 특정 사용자의 신고 내역 조회 (최신순)
    List<BoardReportEntity> findByUserIdOrderByReportDateDesc(String userId);
    

    // 특정 게시글의 신고 횟수 조회
    @Query("SELECT COUNT(r) FROM BoardReportEntity r WHERE r.boardIdx = :boardIdx")
    Long countReportsByBoardIdx(@Param("boardIdx") Long boardIdx);
    

    // 신고가 많은 게시글 조회 (신고 횟수 >= minReports)
    @Query("SELECT r.boardIdx, COUNT(r) as reportCount " +
           "FROM BoardReportEntity r " +
           "GROUP BY r.boardIdx " +
           "HAVING COUNT(r) >= :minReports " +
           "ORDER BY reportCount DESC")
    List<Object[]> findMostReportedBoards(@Param("minReports") int minReports);
    

    // 오류 나서 일단 주석처리
//    // 오늘 접수된 신고 조회
//    @Query("SELECT r FROM BoardReportEntity r " +
//           "WHERE DATE(r.reportDate) = CURRENT_DATE " +
//           "ORDER BY r.reportDate DESC")
//    List<BoardReportEntity> findTodayReports();
	
}
