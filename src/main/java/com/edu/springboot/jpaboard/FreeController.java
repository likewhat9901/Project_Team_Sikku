package com.edu.springboot.jpaboard;

import java.security.Principal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.CookieManager;
import utils.DateUtils;

@Controller
public class FreeController {
	
	//게시판 서비스 빈 자동주입
	@Autowired
	BoardService bs;
	//댓글 서비스 빈 자동주입
	@Autowired
	CommentService cs;
	
	@Autowired
	BoardReportService rs;
	
	@Autowired
	BoardReportRepository rr;
	
	@Autowired
	LikeRepository lr;
	
	@Autowired
	BoardRepository br;
	
	//게시물 리스트
	@GetMapping("/boards/free/freeBoardList.do")
	public String list(Model model, HttpServletRequest req, Principal principal) {
		
		String searchWord = req.getParameter("searchWord");
		String pageNum = req.getParameter("pageNum");
		
		System.out.println("검색어=" + searchWord);
		System.out.println("페이지번호=" + pageNum);
		
		//내림차순 정렬
		//페이지 번호는 0부터 시작하기 때문에 -1처리.
		Sort sort = Sort.by(Sort.Order.desc("boardIdx"));
		int iPageNum = (pageNum == null) ? 0 : Integer.parseInt(pageNum) - 1;
		
		// PageRequest : 페이징 요청 객체
		Pageable pageable = PageRequest.ofSize(10).withPage(iPageNum).withSort(sort);
		
		Page<BoardEntity> boardResult;
		//검색어가 없을 때 목록
		if (searchWord == null || searchWord.equals("")) {
			boardResult = bs.selectList(pageable, 1);
		}
		//검색어가 있을 때 목록
		else {
			searchWord = "%" + searchWord + "%";  //검색어를 %검색어% 문자열로 만들어주기.
			boardResult = bs.selectListSearch(searchWord, pageable, 1);
		}
		
		List<BoardEntity> rows = boardResult.getContent();
		
		model.addAttribute("rows", rows);
		
		
		//현재 로그인한 userId 가져오기
		String loginUserId = principal.getName();
		model.addAttribute("loginUserId", loginUserId);
		
		//좋아요 model에 담아 넘기기
		Map<Long, Long> likesCountMap = new HashMap<>();
		for (BoardEntity board : rows) {
			long likesCount = lr.countByBoard_BoardIdx(board.getBoardIdx());
			likesCountMap.put(board.getBoardIdx(), likesCount);
			System.out.println("디버깅:likesCountMap=" + likesCountMap);
		}
		model.addAttribute("likesCountMap", likesCountMap);
		
		return "/boards/free/freeBoardList";
	}
	
	//무한 스크롤
	@GetMapping("/boards/free/freeBoardListMore.do")
	@ResponseBody
	public Page<BoardEntity> listMore(@RequestParam("pageNum") int pageNum) {
		System.out.println("디버깅용 - 컨트롤러 (listMore)");
	    Sort sort = Sort.by(Sort.Order.desc("boardIdx"));
	    Pageable pageable = PageRequest.of(pageNum, 10, sort);
	    
	    return bs.selectList(pageable, 1);
	}

	
	
	//게시물 상세보기
	@GetMapping("/boards/free/freeBoardView.do")
	public String view(@RequestParam("boardIdx") Long boardIdx, Model model,
										Principal principal,
							HttpServletRequest req, HttpServletResponse resp) {
		
		System.out.println("boardIdx: "+ boardIdx);
		
		// 게시물 정보
		Optional<BoardEntity> board = bs.selectPost(boardIdx);
		BoardEntity be = board.get();
		be.setContent(be.getContent().replaceAll("\r\n", "<br>"));
		model.addAttribute("board", be);
		
		
		//댓글 보기
		// 해당 게시물에 달린 댓글
		List<CommentEntity> comment = cs.findByBoardIdx(boardIdx);
		// 댓글이 있을 경우에만 처리
		if (!comment.isEmpty()) {
		    for (CommentEntity ce : comment) {
		        ce.setContent(ce.getContent().replaceAll("\r\n", "<br>"));
		        //날짜 포맷팅 (댓글)
		        String ceFormattedDate = DateUtils.formatPostDate(ce.getPostdate());
		        model.addAttribute("ceFormattedDate", ceFormattedDate);
		    }
		}
		model.addAttribute("comment", comment);
		
		//현재 로그인한 userId 가져오기
		String loginUserId = principal.getName();
		model.addAttribute("loginUserId", loginUserId);
		System.out.println("loginUserId: "+ loginUserId);
		
		
		//날짜 포맷팅 (게시물)
		String beFormattedDate = DateUtils.formatPostDate(be.getPostdate());
		model.addAttribute("beFormattedDate", beFormattedDate);
		
		//좋아요 갯수 조회
		long likesCount = lr.countByBoard_BoardIdx(boardIdx);
		System.out.println("상세보기 좋아요 디버깅:likesCountMap=" + likesCount);
		model.addAttribute("likesCount", likesCount);
		
		// 현재 사용자가 이 게시물에 좋아요를 눌렀는지 확인
		Optional<LikeEntity> userLike = lr.findByBoard_BoardIdxAndUserId(boardIdx, loginUserId);
		boolean isLiked = userLike.isPresent();
		model.addAttribute("isLiked", isLiked);
		System.out.println("isLiked: "+ isLiked);
		
		//조회수 한번만 오르도록 쿠키 사용하기
		//HttpServletRequest, HttpServletResponse 추가
		//파라미터로 쿠키명 생성
		String idx = req.getParameter("boardIdx");
		String boName = "free";
		String ckName = boName +"-"+ idx;
		cookieOneDay(req, model, resp, ckName, boardIdx);
		
		// 조회수 증가 후 최신 데이터 다시 조회
		Optional<BoardEntity> updatedBoard = bs.selectPost(boardIdx);
		BoardEntity be2 = updatedBoard.get();
		model.addAttribute("board", be2);
		
		return "/boards/free/freeBoardView";
	}
	
	//하루만 유효한 쿠키 생성 (Utils에 있는 CookieManager 활용)
	public void cookieOneDay(HttpServletRequest req, Model model, 
			HttpServletResponse resp, String ckName, Long boardIdx) {
		String rk = CookieManager.readCookie(req, ckName);
		if(rk.equals("")) {
			//쿠키생성
			CookieManager.makeCookie(resp, ckName, "true", 86400);
			bs.increaseVisitCount(boardIdx);
			model.addAttribute("message", "쿠키생성&조회수update");
		}
		else {
			//쿠키가 이미 생성되어 있다면 업데이트 생략
			model.addAttribute("message", "하루동안처리안함");
		}
	}
	
	// 좋아요 토글(추가/취소) API
	@PostMapping("/boards/free/toggleLike.do")
	/* ResponseEntity<Map<String, Object>>
	 -> HTTP 응답의 모든 것을 직접 제어할 수 있는 객체.
	 * 
	 */
	public ResponseEntity<Map<String, Object>> toggleLike(
	        @RequestParam("boardIdx") Long boardIdx, Principal principal) {
	    
		//현재 로그인 사용자 ID 추출.
	    String userId = principal.getName();
	    Map<String, Object> response = new HashMap<>();

       try {
           // Service 계층의 좋아요 처리 로직 호출
           Map<String, Object> result = bs.toggleLike(boardIdx, userId);

           // "성공 여부"와 "좋아요 개수", "현재 좋아요 상태"를 response 맵에 저장.
           response.put("success", true);
           response.put("likesCount", result.get("likesCount"));
           response.put("isLiked", result.get("isLiked")); // isLiked 필드 추가
           
           // HTTP 200 OK 상태와 함께 response 데이터를 클라이언트에 보냄
           return ResponseEntity.ok(response);
           
       }
       /* 예외 발생 시, 실패 결과와 메시지를 응답 맵에 넣고
           HTTP 500 (서버 오류) 상태와 함께 반환. */ 
       catch (Exception e) {
           response.put("success", false);
           response.put("message", "좋아요 처리 중 오류가 발생했습니다.");
           
           return ResponseEntity.status(500).body(response);
       }
   }
	
	@GetMapping("/boards/free/getLikeStatus.do")
	@ResponseBody
	public Map<String, Object> getLikeStatus(
			@RequestParam("boardIdx") Long boardIdx, Principal principal) {
		
	    Map<String, Object> response = new HashMap<>();
	    try {
	        String userId = principal != null ? principal.getName() : null;

	        Map<String, Object> result = bs.toggleLike(boardIdx, userId); 
	        int likesCount = (int) result.get("likesCount"); 
	        boolean isLiked = false;
	        if (userId != null) {
	            isLiked = bs.isLikedByUser(boardIdx, userId).isPresent();
	        }// Service에서 좋아요 개수 가져오기

	        response.put("success", true);
	        response.put("likesCount", likesCount);
	        response.put("isLiked", isLiked);
	    } catch (Exception e) {
	        response.put("success", false);
	        response.put("message", "좋아요 상태를 불러오는 중 오류가 발생했습니다.");
	    }
	    return response;
	}

   
   
   //글쓰기
   @GetMapping("/boards/free/freeBoardWrite.do")
   public String write(Principal principal, Model model) {
      
      //현재 로그인한 userId 가져오기
      String loginUserId = principal.getName();
      model.addAttribute("loginUserId", loginUserId);
      
      return "/boards/free/freeBoardWrite";
   }
   
   //POST방식으로 글쓰기 DB처리
   @PostMapping("/boards/free/freeBoardWriteProc.do")
   public String writeProc(BoardEntity be) {
      bs.insertPost(be);
      return "redirect:freeBoardList.do";
   }
   
   
   //수정하기 (수정 페이지에 진입)
   @GetMapping("/boards/free/freeBoardEdit.do")
   public String edit(Model model, @RequestParam("boardIdx") Long boardIdx) {
      Optional<BoardEntity> result = bs.selectPost(boardIdx);
      if(result.isPresent()) {
         model.addAttribute("board", result.get());
         
       //좋아요 갯수 조회
 		long likesCount = lr.countByBoard_BoardIdx(boardIdx);
 		System.out.println("상세보기 좋아요 디버깅:likesCount=" + likesCount);
 		model.addAttribute("likesCount", likesCount);
      }
      else {
         model.addAttribute("board", null);
      }
      
      
      return "/boards/free/freeBoardEdit";
   }
   
   //POST방식으로 수정하기 DB처리
   @PostMapping("/boards/free/freeBoardEditProc.do")
   public String editProc(BoardEntity be, Model model) {
      System.out.println("수정 요청: " + be.getBoardIdx());  // 디버깅 로그
      bs.updatePost(be);  //여기서 likes가 없음.
      return "redirect:freeBoardView.do?boardIdx="+ be.getBoardIdx();
   }
   
   
   //삭제
   @GetMapping("/boards/free/freeBoardDelete.do")
   public String delete(BoardEntity be) {
      bs.deletePost(be.getBoardIdx());
      return "redirect:freeBoardList.do";
   }
   
   /* ===== 댓글 ===== */

	/* 오류 발생
	 -> 댓글 저장할 때 board, member 객체를 반드시 세팅해야 DB에 들어감. */
	
	//댓글 작성하기
	@PostMapping("/boards/free/freeBoardCommentWriteProc.do")
	public String commentWriteProc(@RequestParam("boardIdx") Long boardIdx,
					@RequestParam("userId") String userId, 
					@RequestParam("content") String content) {
		
		// CommentService에서 모든 처리를 담당하도록 변경
		cs.insertPost(boardIdx, userId, content);
		return "redirect:freeBoardView.do?boardIdx=" + boardIdx;
	}
	
	
	/* 댓글은 freeBoardView에 CommentEntity타입의 댓글 리스트가 이미 넘어갔으므로
	GETMapping은 필요 하지 않다.
	*/
	//댓글 수정하기
	@PostMapping("/boards/free/freeBoardCommentEditProc.do")
	public String commentEditProc(@RequestParam("commentIdx") Long commentIdx,
					@RequestParam("boardIdx") Long boardIdx,
					@RequestParam("userId") String userId,
					@RequestParam("content") String content) {
		
		// CommentService에서 모든 처리를 담당하도록 변경
		cs.updatePost(commentIdx, boardIdx, userId, content);
		return "redirect:freeBoardView.do?boardIdx=" + boardIdx;
	}
	
	// 댓글 삭제하기
	@GetMapping("/boards/free/freeBoardCommentDelete.do")
	public String commentDelete(@RequestParam("commentIdx") Long commentIdx,
	                          @RequestParam("boardIdx") Long boardIdx) {
	    cs.deletePost(commentIdx);
	    return "redirect:freeBoardView.do?boardIdx=" + boardIdx;
	}
	
	//신고하기 모달창에서 작성 후 DB에 반영시키기
	@PostMapping("/boards/free/reportBoard.do")
	public String reportBoard(BoardReportEntity re, Principal principal) {
		
		String userId = principal.getName();	
		re.setUserId(userId);
		rr.save(re);
		
	    // 서비스에서 신고 저장 + board 테이블 업데이트 한번에 처리
	    rs.saveReportAndUpdateBoard(re);
		
		return "redirect:freeBoardView.do?boardIdx=" + re.getBoardIdx();
	}
	
	
		
	
	
}
