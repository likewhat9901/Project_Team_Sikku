package com.edu.springboot.jpaboard;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.edu.springboot.auth.AuthController;
import com.edu.springboot.flutter.auth.AuthApiController;
import com.edu.springboot.jpaboard.dto.IBoardRow;
import com.edu.springboot.jpaboard.dto.LikedPostDto;
import com.edu.springboot.jpaboard.dto.MyPostDto;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class BoardService {

	
   //DAO역할의 인터페이스
   @Autowired
   private BoardRepository br;
   @Autowired
   private LikeRepository lr;


   
   
   /******************** 자유게시판 (카테고리=1) *****************/
   // 목록 (검색어X)
   public Page<BoardEntity> selectList(Pageable pageable, Integer category) {
      Page<BoardEntity> boardRows = br.findByCategory(pageable, 1);
      return boardRows;
   }
   
   // 목록 (검색어O)
   public Page<BoardEntity> selectListSearch(Pageable pageable, Integer category, String search) {
	    Page<BoardEntity> boardRows = br.findByCategoryAndTitleContaining(pageable, 1, search);
	    return boardRows;
	}
   
   
   /******************** 갤러리게시판 (카테고리=2) *****************/
   // 목록 (검색어X)
   public Page<BoardEntity> selectGList(Pageable pageable, Integer category) {
      Page<BoardEntity> boardRows = br.findByCategory(pageable, 2);
      return boardRows;
   }
   
   // 목록 (검색어O)
   public Page<BoardEntity> selectGListSearch(Pageable pageable, Integer category, String search) {
	    Page<BoardEntity> boardRows = br.findByCategoryAndTitleContaining(pageable, 2, search);
	    return boardRows;
	}
   
   /**********************************************************************/
   
   // 목록 (복합 검색어)
   public Page<BoardEntity> selectListComplexSearch(Pageable pageable, BoardSearchCondDTO condDTO) {
	 
	   
	    if(condDTO.getCategory() != null && condDTO.getCategory() == 1) {
	        Page<BoardEntity> boardRows = br.searchComplex(pageable, condDTO);
	        return boardRows;
	    }
	    else {
	        // 카테고리가 null이거나 1이 아닐 때는 기본 selectList 사용
	    	return br.searchComplex(pageable, condDTO);
	    }
   }
   
   /**********************************************************************/
   
   // 순수하게 게시물 정보만 조회하는 메서드
   public Optional<BoardEntity> selectPost(Long boardIdx) {
       return br.findById(boardIdx);
   }

   // 순수하게 조회수만 증가시키는 메서드
   @Transactional
   public void increaseVisitCount(Long boardIdx) {
       Optional<BoardEntity> board = br.findById(boardIdx);
       if (board.isPresent()) {
           BoardEntity be = board.get();
           be.setVisitcount(be.getVisitcount() + 1);
           br.save(be);
       }
   }
   
   // 좋아요
   @Transactional
   public Map<String, Object> toggleLike(Long boardIdx, String userId) {
       BoardEntity board = br.findById(boardIdx)
                 .orElseThrow(() -> new IllegalArgumentException("게시물을 찾을 수 없습니다."));
       
       // likes 리스트를 스트림(Stream)으로 변환.
       // 현재 사용자가 해당 게시물에 좋아요 눌렀는지 조회.
       Optional<LikeEntity> existingLike = board.getLikes().stream()
             .filter(like -> like.getUserId().equals(userId))
             .findFirst();
       //좋아요가 눌린 상태인지 표시할 변수를 선언
       boolean isLiked = false;
       
       //이미 좋아요가 있을 경우 그 좋아요를 삭제(취소)
       if (existingLike.isPresent()) {
          System.out.println("좋아요 취소 - 기존 좋아요 삭제");
          board.getLikes().remove(existingLike.get());
           lr.delete(existingLike.get());
           isLiked = false;
       }
       //기존 좋아요가 없으면 새로 좋아요를 생성해서 저장
       else {
          System.out.println("새 좋아요 추가");
           LikeEntity newLike = new LikeEntity();
           newLike.setBoard(board);
           newLike.setUserId(userId);
           newLike.setLikedDate(LocalDateTime.now());
           
           board.getLikes().add(newLike);
           lr.save(newLike);
           isLiked = true;
       }
       
       // 변경사항 저장
       br.save(board);
       
       // hboard 테이블의 likes 컬럼 업데이트
       int newLikesCount = board.getLikes().size();
       board.setLikesCount(newLikesCount);  // 이 부분이 실제 DB 컬럼을 업데이트함
       br.save(board);
       
       Map<String, Object> result = new HashMap<>();
       result.put("likesCount", newLikesCount);
       result.put("isLiked", isLiked);

       return result; 
   }
   
// 내가 좋아요 눌렀는지 여부
   public Optional<LikeEntity> isLikedByUser(Long boardIdx, String userId) {
       return lr.findByBoard_BoardIdxAndUserId(boardIdx, userId);
   }
   
   // 글쓰기
   public void insertPost(BoardEntity be) {
      br.save(be);
   }
   
   
    //수정
    public void updatePost(BoardEntity be) {
    	// 1. 기존 글 불러오기 (DB에서)
        BoardEntity original = br.findById(be.getBoardIdx()).orElseThrow();

        // 2. 필요한 필드만 수정
        original.setTitle(be.getTitle());
        original.setContent(be.getContent());
    	
        br.save(original);
    }

    // 삭제
    public void deletePost(Long boardIdx) {
        br.deleteById(boardIdx);
    }

    // 카테고리별 좋아요 TOP10
    public Page<IBoardRow> getTop10BoardsByCategory(Integer category, int page, int size) {
    	Pageable pageable = PageRequest.of(page, size);
        return br.findTopByCategory(category, pageable);
    }

 // 마이페이지: 내가 좋아요 누른 글 목록 조회  
    public List<LikedPostDto> getLikedPostsOf(String userId) {
        return lr.findLikedPostsByUser(userId);
    }
    
    public List<MyPostDto> getMyPostsOf(String userId) {
        return br.findMyPosts(userId);
    }
    
    /**********************************************************************/

    
    // 최근 7일 게시글 통계 가져오기
    public List<WeeklyPostCountDTO> getWeeklyPosts() {
    	return br.countWeeklyPosts();
    }
    
    // 최근 7일 조회수 TOP5 게시글 가져오기
    public List<WeeklyTop5PostDTO> getWeeklyTop5() {
    	return br.findWeeklyTop5Posts();
    }
    
    
    
    
    
    
    
    
    
    
    
    

}
