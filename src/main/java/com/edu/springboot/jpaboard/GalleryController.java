package com.edu.springboot.jpaboard;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.Principal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collection;
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
import org.springframework.util.ResourceUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import utils.CookieManager;
import utils.DateUtils;
import utils.MyFunctions;

@Controller
public class GalleryController {

	// 게시판 서비스 빈 자동주입
	@Autowired
	BoardService bs;
	// 댓글 서비스 빈 자동주입
	@Autowired
	CommentService cs;
	@Autowired
	BoardImageService is;
	@Autowired
	BoardReportService rs;
	@Autowired
	LikeService ls;

	@Autowired
	BoardRepository br;
	@Autowired
	LikeRepository lr;
	@Autowired
	BoardImageRepository ir;
	@Autowired
	BoardReportRepository rr;
	@Autowired
	CommentRepository cr;

	// 게시물 리스트
	@GetMapping("/boards/gallery/galleryBoardList.do")
	public String list(Model model, HttpServletRequest req, Principal principal) {

		String searchWord = req.getParameter("searchWord");
		String pageNum = req.getParameter("pageNum");

		System.out.println("검색어=" + searchWord);
		System.out.println("페이지번호=" + pageNum);

		// 내림차순 정렬
		// 페이지 번호는 0부터 시작하기 때문에 -1처리.
		Sort sort = Sort.by(Sort.Order.desc("boardIdx"));
		int iPageNum = (pageNum == null) ? 0 : Integer.parseInt(pageNum) - 1;

		// PageRequest : 페이징 요청 객체
		Pageable pageable = PageRequest.ofSize(10).withPage(iPageNum).withSort(sort);

		Page<BoardEntity> boardResult;
		// 검색어가 없을 때 목록
		if (searchWord == null || searchWord.equals("")) {
			boardResult = bs.selectGList(pageable, 2);
		}
		// 검색어가 있을 때 목록
		else {
			boardResult = bs.selectGListSearch(pageable, 2, searchWord);
		}

		List<BoardEntity> rows = boardResult.getContent();

		model.addAttribute("rows", rows);

		// 현재 로그인한 userId 가져오기
		String loginUserId = principal.getName();
		model.addAttribute("loginUserId", loginUserId);

		// 좋아요 model에 담아 넘기기
		Map<Long, Long> likesCountMap = new HashMap<>();
		for (BoardEntity board : rows) {
			long likesCount = lr.countByBoard_BoardIdx(board.getBoardIdx());
			likesCountMap.put(board.getBoardIdx(), likesCount);
			System.out.println("디버깅:likesCountMap=" + likesCountMap);
		}
		model.addAttribute("likesCountMap", likesCountMap);
		
		//댓글 갯수 가져오기
		Map<Long, Integer> commentCountMap = new HashMap<>();
		for (BoardEntity board : rows) {
			int commentCount = cr.countByBoard_BoardIdx(board.getBoardIdx());
			commentCountMap.put(board.getBoardIdx(), commentCount);
		}
		model.addAttribute("commentCountMap", commentCountMap);

		// 이미지 정보 추가
		Map<Long, String> imageMap = new HashMap<>();
		for (BoardEntity board : rows) {
			// 각 게시물의 첫 번째 이미지 파일명 가져오기
			List<BoardImageEntity> images = ir.findByBoard_BoardIdx(board.getBoardIdx());
			if (!images.isEmpty()) {
				// 첫 번째 이미지 사용
				imageMap.put(board.getBoardIdx(), images.get(0).getSavedName());
			} else {
				// 기본 이미지 또는 null
				imageMap.put(board.getBoardIdx(), "default.jpg");
			}
		}
		model.addAttribute("imageMap", imageMap);

		return "/boards/gallery/galleryBoardList";

	}

	// 무한 스크롤
	@GetMapping("/boards/gallery/galleryBoardListMore.do")
	@ResponseBody
	public List<Map<String, Object>> getMoreBoards(@RequestParam("page") int page, HttpServletRequest req) {
		System.out.println("요청 페이지: " + page);

		String searchWord = req.getParameter("searchWord");
		String pageNum = req.getParameter("pageNum");

		// DB에서 실제 데이터 가져오기
		Sort sort = Sort.by(Sort.Order.desc("boardIdx"));
		Pageable pageable = PageRequest.of(page, 10, sort);

		Page<BoardEntity> pageResult;

		if (searchWord == null || searchWord.equals("")) {
			pageResult = bs.selectGList(pageable, 2);
		} else {
			pageResult = bs.selectGListSearch(pageable, 2, searchWord);
		}

		// 간단한 테스트 데이터
		List<Map<String, Object>> realData = new ArrayList<>();

		for (BoardEntity board : pageResult.getContent()) {
			Map<String, Object> boardMap = new HashMap<>();
			boardMap.put("boardIdx", board.getBoardIdx());
			boardMap.put("title", board.getTitle());
			boardMap.put("content", board.getContent());
			boardMap.put("userId", board.getUserId());
			boardMap.put("visitcount", board.getVisitcount());
			boardMap.put("likes", board.getLikesCount());
			realData.add(boardMap);
		}

		return realData;
	}

	// 게시물 상세보기
	@GetMapping("/boards/gallery/galleryBoardView.do")
	public String view(@RequestParam("boardIdx") Long boardIdx, Model model,
											Principal principal,
								HttpServletRequest req, HttpServletResponse resp) {

		// 게시물 정보
		Optional<BoardEntity> board = bs.selectPost(boardIdx);
		BoardEntity be = board.get();
		be.setContent(be.getContent().replaceAll("\r\n", "<br>"));
		model.addAttribute("board", be);

		// 댓글 보기
		// 해당 게시물에 달린 댓글
		List<CommentEntity> comment = cs.findByBoardIdx(boardIdx);
		// 댓글이 있을 경우에만 처리
		if (!comment.isEmpty()) {
			for (CommentEntity ce : comment) {
				ce.setContent(ce.getContent().replaceAll("\r\n", "<br>"));
				// 날짜 포맷팅 (댓글)
				String ceFormattedDate = DateUtils.formatPostDate(ce.getPostdate());
				model.addAttribute("ceFormattedDate", ceFormattedDate);
			}
		}
		model.addAttribute("comment", comment);

		// 현재 로그인한 userId 가져오기
		String loginUserId = principal.getName();
		model.addAttribute("loginUserId", loginUserId);

		// 날짜 포맷팅 (게시물)
		String beFormattedDate = DateUtils.formatPostDate(be.getPostdate());
		model.addAttribute("beFormattedDate", beFormattedDate);


		// 현재 사용자가 이 게시물에 좋아요를 눌렀는지 확인
		Optional<LikeEntity> userLike = lr.findByBoard_BoardIdxAndUserId(boardIdx, loginUserId);
		boolean isLiked = userLike.isPresent();
		model.addAttribute("isLiked", isLiked);

		// 조회수 한번만 오르도록 쿠키 사용하기
		// HttpServletRequest, HttpServletResponse 추가
		// 파라미터로 쿠키명 생성
		String idx = req.getParameter("boardIdx");
		String boName = "gallery";
		String ckName = boName + "-" + idx;
		cookieOneDay(req, model, resp, ckName, boardIdx);

		// 조회수 증가 후 최신 데이터 다시 조회
		Optional<BoardEntity> updatedBoard = bs.selectPost(boardIdx);
		BoardEntity be2 = updatedBoard.get();
		model.addAttribute("board", be2);

		// 이미지 정보 추가
		List<String> imageFiles = new ArrayList<>();
		List<BoardImageEntity> images = ir.findByBoard_BoardIdx(be.getBoardIdx());
		if (!images.isEmpty()) {
			for (BoardImageEntity image : images) {
				imageFiles.add(image.getSavedName());
			}
		} else {
			// 이미지가 없을 경우, 기본 이미지
			imageFiles.add("default.jpg");
		}
		model.addAttribute("imageFiles", imageFiles);
		
		// 신고 true / false
		boolean checkReport = rs.checkReport(boardIdx, loginUserId);
		model.addAttribute("checkReport", checkReport);

		return "/boards/gallery/galleryBoardView";
	}

	// 하루만 유효한 쿠키 생성 (Utils에 있는 CookieManager 활용)
	public void cookieOneDay(HttpServletRequest req, Model model, HttpServletResponse resp, String ckName,
			Long boardIdx) {
		String rk = CookieManager.readCookie(req, ckName);
		if (rk.equals("")) {
			// 쿠키생성
			CookieManager.makeCookie(resp, ckName, "true", 86400);
			bs.increaseVisitCount(boardIdx);
			model.addAttribute("message", "쿠키생성&조회수update");
		} else {
			// 쿠키가 이미 생성되어 있다면 업데이트 생략
			model.addAttribute("message", "하루동안처리안함");
		}
	}

	// 좋아요 토글(추가/취소) API
	@PostMapping("/boards/gallery/toggleLike2.do")
	/*
	 * ResponseEntity<Map<String, Object>> -> HTTP 응답의 모든 것을 직접 제어할 수 있는 객체.
	 * 
	 */
	public ResponseEntity<Map<String, Object>> toggleLike2(@RequestParam("boardIdx") Long boardIdx,
			Principal principal) {

		// 현재 로그인 사용자 ID 추출.
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
		/*
		 * 예외 발생 시, 실패 결과와 메시지를 응답 맵에 넣고 HTTP 500 (서버 오류) 상태와 함께 반환.
		 */
		catch (Exception e) {
			response.put("success", false);
			response.put("message", "좋아요 처리 중 오류가 발생했습니다.");

			return ResponseEntity.status(500).body(response);
		}
	}
	
	//좋아요 상태
	@GetMapping("/boards/gallery/getLikeStatus2.do")
	@ResponseBody
	public Map<String, Object> getLikeStatus2(
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

	// 글쓰기
	@GetMapping("/boards/gallery/galleryBoardWrite.do")
	public String write(Principal principal, Model model) {

		// 현재 로그인한 userId 가져오기
		String loginUserId = principal.getName();
		model.addAttribute("loginUserId", loginUserId);

		return "/boards/gallery/galleryBoardWrite";
	}

	// POST방식으로 글쓰기 DB처리
	// 사용자가 첨부파일등록하고 글쓰기 하면 bin폴더에 해당 이미지 파일을 확인할 수 있다.
	@PostMapping("/boards/gallery/galleryBoardWriteProc.do")
	public String writeProc(BoardEntity be, @RequestParam("ofile") List<MultipartFile> ofile) {

	    try {
	        System.out.println("갤러리 게시판 글쓰기 프로세스 실행");

	        // 게시글 저장
	        BoardEntity savedBoard = br.save(be);

	        // 업로드 경로
	        String uploadDir = ResourceUtils.getFile("classpath:static/uploads/board").toPath().toString();
	        
	        // 디렉토리가 없으면 생성
	        Files.createDirectories(Paths.get(uploadDir));

	        // 서비스의 이미지 저장 함수 호출
	        is.saveBoardImage(savedBoard, ofile, uploadDir);

	        System.out.println("갤러리 게시물 업로드 성공");
	    } catch (Exception e) {
	        System.out.println("갤러리 게시물 업로드 실패");
	    }

	    return "redirect:galleryBoardList.do";
	}

	/* ====================================================================== */

	// 수정하기 (수정 페이지에 진입)
	@GetMapping("/boards/gallery/galleryBoardEdit.do")
	public String edit(Model model, @RequestParam("boardIdx") Long boardIdx) {
	      Optional<BoardEntity> result = bs.selectPost(boardIdx);
	      if(result.isPresent()) {
	         model.addAttribute("board", result.get());
	         
	       //좋아요 갯수 조회
	 		long getLikesCount = ls.getLikesCount(boardIdx);
	 		System.out.println("상세보기 좋아요 디버깅:getLikesCount=" + getLikesCount);
	 		model.addAttribute("likesCount", getLikesCount);
	      }
	      else {
	         model.addAttribute("likesCount", null);
	      }

		return "/boards/gallery/galleryBoardEdit";
	}

	// POST방식으로 수정하기 DB처리
	@PostMapping("/boards/gallery/galleryBoardEditProc.do")
	public String editProc(BoardEntity be, Model model, @RequestParam("ofile") List<MultipartFile> ofile) {
		System.out.println("수정 요청: " + be.getBoardIdx()); // 디버깅 로그
		bs.updatePost(be);

		try {

			System.out.println("갤러리 게시판 수정 프로세스 실행");

			// 게시글 저장
			BoardEntity savedBoard = br.save(be);

			// 업로드 경로
			String uploadDir = ResourceUtils.getFile("classpath:static/uploads/board").toPath().toString();

			// 서비스의 이미지 저장 함수 호출
			is.saveBoardImage(savedBoard, ofile, uploadDir);

			System.out.println("갤러리 게시물 업로드 성공");
		} catch (Exception e) {
			System.out.println("갤러리 게시물 업로드 실패");
		}
		
		long like = be.getLikesCount();
		System.out.println("좋아요갯수 몇개?" + like);

		return "redirect:galleryBoardView.do?boardIdx=" + be.getBoardIdx();
	}

	// 삭제
	@GetMapping("/boards/gallery/galleryBoardDelete.do")
	public String delete(BoardEntity be) {
		bs.deletePost(be.getBoardIdx());
		return "redirect:galleryBoardList.do";
	}

	/* ===== 댓글 ===== */

	/*
	 * 오류 발생 -> 댓글 저장할 때 board, member 객체를 반드시 세팅해야 DB에 들어감.
	 */

	// 댓글 작성하기
	@PostMapping("/boards/gallery/galleryBoardCommentWriteProc.do")
	public String commentWriteProc(@RequestParam("boardIdx") Long boardIdx, @RequestParam("userId") String userId,
			@RequestParam("content") String content) {

		// CommentService에서 모든 처리를 담당하도록 변경
		cs.insertPost(boardIdx, userId, content);
		return "redirect:galleryBoardView.do?boardIdx=" + boardIdx;
	}

	/*
	 * 댓글은 freeBoardView에 CommentEntity타입의 댓글 리스트가 이미 넘어갔으므로 GETMapping은 필요 하지 않다.
	 */
	// 댓글 수정하기
	@PostMapping("/boards/gallery/galleryBoardCommentEditProc.do")
	public String commentEditProc(@RequestParam("commentIdx") Long commentIdx, @RequestParam("boardIdx") Long boardIdx,
			@RequestParam("userId") String userId, @RequestParam("content") String content) {

		// CommentService에서 모든 처리를 담당하도록 변경
		cs.updatePost(commentIdx, boardIdx, userId, content);
		return "redirect:galleryBoardView.do?boardIdx=" + boardIdx;
	}

	// 댓글 삭제하기
	@GetMapping("/boards/gallery/galleryBoardCommentDelete.do")
	public String commentDelete(@RequestParam("commentIdx") Long commentIdx, @RequestParam("boardIdx") Long boardIdx) {
		cs.deletePost(commentIdx);
		return "redirect:galleryBoardView.do?boardIdx=" + boardIdx;
	}
	
	//신고하기 모달창에서 작성 후 DB에 반영시키기
	@PostMapping("/boards/gallery/reportGBoard.do")
	public String reportGBoard(BoardReportEntity re, Principal principal) {
		
		System.out.println("=== 신고 데이터 확인 ===");
	    System.out.println("content: " + re.getContent());
	    System.out.println("boardIdx: " + re.getBoardIdx());
	    System.out.println("userId: " + principal.getName());
		
		String userId = principal.getName();	
		re.setUserId(userId);
		rr.save(re);
		
		// 컨트롤러에서는 신고 테이블만 DB처리,
	    // 게시판 테이블의 Report +1증가는 서비스 클래스에서 진행
	    rs.saveReportAndUpdateBoard(re);
		
		return "redirect:galleryBoardView.do?boardIdx=" + re.getBoardIdx();
	}

}
