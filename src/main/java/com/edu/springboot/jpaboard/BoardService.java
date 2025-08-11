package com.edu.springboot.jpaboard;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import jakarta.transaction.Transactional;

@Service
public class BoardService {
	
	//DAO역할의 인터페이스
	@Autowired
	private BoardRepository br;
    @Autowired
    private LikeRepository lr;
	
	
	
	// 목록 (검색어X)
	public Page<BoardEntity> selectList(Pageable pageable) {
		Page<BoardEntity> boardRows = br.findAll(pageable);
		return boardRows;
	}
	
	// 목록 (검색어O)
	public Page<BoardEntity> selectListSearch(String search, Pageable pageable) {
		Page<BoardEntity> boardRows = br.findByTitleLike(search, pageable);
		return boardRows;
	}
	
	// 상세보기
	public Optional<BoardEntity> selectPost(Long boardIdx) {
		Optional<BoardEntity> board = br.findById(boardIdx);
		
		//조회수 1증가시키고 저장
		BoardEntity be = board.get();
		int visitcount = (be.getVisitcount() == null) ? 0 : be.getVisitcount();
		be.setVisitcount(visitcount+1);
		br.save(be);
		
		return board;
	}
	
	// 좋아요
	@Transactional
	public Map<String, Object> toggleLike(Long boardIdx, String userId) {
	    BoardEntity board = br.findById(boardIdx)
	              .orElseThrow(() -> new IllegalArgumentException("게시물을 찾을 수 없습니다."));
	    
	    //현재 사용자가 해당 게시물에 좋아요 눌렀는지 조회.
	    Optional<LikeEntity> existingLike = lr.findByBoard_BoardIdxAndUserId(boardIdx, userId);
	    //좋아요가 눌린 상태인지 표시할 변수를 선언
	    boolean isLiked = false;
	    
	    //이미 좋아요가 있을 경우 그 좋아요를 삭제(취소)
	    if (existingLike.isPresent()) {
	        lr.delete(existingLike.get());
	        isLiked = false;
	    }
	    //기존 좋아요가 없으면 새로 좋아요를 생성해서 저장
	    else {
	        LikeEntity newLike = new LikeEntity();
	        newLike.setBoard(board);
	        newLike.setUserId(userId);
	        newLike.setLikedDate(LocalDateTime.now());
	        lr.save(newLike);
	        isLiked = true;
	    }
	    
	    //좋아요 상태가 변경된 후, 해당 게시물에 총 좋아요 개수를 다시 센다.
	    long newLikesCount = lr.countByBoard_BoardIdx(boardIdx);
	    
	    Map<String, Object> result = new HashMap<>();
	    result.put("likesCount", newLikesCount);
	    result.put("isLiked", isLiked);

	    return result; 
	}
	
	// 글쓰기
	public void insertPost(BoardEntity be) {
		br.save(be);
	}
	
	
    //수정
    public void updatePost(BoardEntity be) {
        br.save(be);
    }

    //삭제
    public void deletePost(Long boardIdx) {
        br.deleteById(boardIdx);
    }
    
    
    public List<BoardEntity> getTop10BoardsByCategory(Integer category) {
        // 좋아요 수 기준으로 내림차순 정렬하여 상위 10개 게시글을 조회
        return br.findTop10ByCategoryOrderByLikesDesc(category);
    }

	
}