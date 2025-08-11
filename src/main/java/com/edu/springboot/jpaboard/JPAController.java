package com.edu.springboot.jpaboard;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


import jakarta.servlet.http.HttpServletRequest;

@Controller
public class JPAController {
	
	//게시판 서비스 빈 자동주입
	@Autowired
	BoardService bs;
	//댓글 서비스 빈 자동주입
	@Autowired
	CommentService cs;
	
	
	//게시물 리스트
	@GetMapping("/boards/free/freeBoardList.do")
	public String list(Model model, HttpServletRequest req) {
		
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
			boardResult = bs.selectList(pageable);
		}
		//검색어가 있을 때 목록
		else {
			searchWord = "%" + searchWord + "%";  //검색어를 %검색어% 문자열로 만들어주기.
			boardResult = bs.selectListSearch(searchWord, pageable);
		}
		
		List<BoardEntity> rows = boardResult.getContent();
		
		model.addAttribute("rows", rows);
		
		return "/boards/free/freeBoardList";
	}
	
	//무한 스크롤
	@GetMapping("/boards/free/freeBoardListMore.do")
	@ResponseBody
	public Page<BoardEntity> listMore(@RequestParam("pageNum") int pageNum) {
		System.out.println("디버깅용 - 컨트롤러 (listMore)");
	    Sort sort = Sort.by(Sort.Order.desc("boardIdx"));
	    Pageable pageable = PageRequest.of(pageNum, 10, sort);
	    
	    return bs.selectList(pageable);
	}

	
	
	//게시물 상세보기
	@GetMapping("/boards/free/freeBoardView.do")
	public String view(@RequestParam("boardIdx") Long boardIdx, Model model) {
		
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
		    }
		}
		
		model.addAttribute("comment", comment);
		
		return "/boards/free/freeBoardView";
	}
	
	
	//글쓰기
	@GetMapping("/boards/free/freeBoardWrite.do")
	public String write() {
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
	public String edit(Model model, HttpServletRequest req) {
		
		String idx= req.getParameter("boardIdx");
		Optional<BoardEntity> result = bs.selectPost(Long.parseLong(idx));
		if(result.isPresent()) {
			model.addAttribute("row", result.get());
		}
		else {
			model.addAttribute("row", null);
		}
		return "/boards/free/freeBoardEdit";
	}
	
	//POST방식으로 수정하기 DB처리
	@PostMapping("/boards/free/freeBoardEditProc.do")
	public String editProc(BoardEntity be) {
		System.out.println("수정 요청: " + be.getBoardIdx());  // 디버깅 로그
		bs.updatePost(be);
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
					@RequestParam("memberIdx") Long memberIdx, CommentEntity ce,
					MemberEntity me) {
		BoardEntity be = new BoardEntity();
	    be.setBoardIdx(boardIdx); // idx만 세팅해서 참조
	    be.setMemberIdx(memberIdx); // idx만 세팅해서 참조
	    cs.insertPost(ce, be, me);
	    return "redirect:freeBoardView.do?boardIdx=" + boardIdx;
	}
	
	
	//댓글 수정 진입
	@RequestMapping("/boards/free/freeBoardCommentEdit.do")
	public String commentEdit(@RequestParam("commentIdx") Long commentIdx,
			@RequestParam("boardIdx") Long boardIdx, Model model) {
	    // 기존 댓글 정보를 가져와서 모델에 담는 로직 (예: cs.selectComment(commentIdx))
	    CommentEntity comment = cs.selectComment(commentIdx); // selectComment 메서드가 필요함
	    model.addAttribute("comment", comment);

	    return "redirect:freeBoardView.do?boardIdx="+ boardIdx;
	}
	
	//댓글 수정하기
	@PostMapping("/boards/free/freeBoardCommentEditProc.do")
	public String commentEditProc(@RequestParam("boardIdx") Long boardIdx,
					@RequestParam("memberIdx") Long memberIdx, CommentEntity ce,
					MemberEntity me) {
		BoardEntity be = new BoardEntity();
	    be.setBoardIdx(boardIdx);
	    be.setMemberIdx(memberIdx);
		cs.updatePost(ce, be, me);
		return "redirect:freeBoardView.do?boardIdx="+ boardIdx;
	}
		
	@GetMapping("/boards/gallery/galleryBoardList.do")
	public String galleryBoardList() {
		return "/boards/gallery/galleryBoardList";
	}
	
	@GetMapping("/boards/gallery/galleryBoardView.do")
	public String galleryBoardView() {
		return "/boards/gallery/galleryBoardView";
	}
	
	@GetMapping("/boards/gallery/galleryBoardWrite.do")
	public String galleryBoardWrite() {
		return "/boards/gallery/galleryBoardWrite";
	}
	
	@GetMapping("/boards/gallery/galleryBoardEdit.do")
	public String galleryBoardEdit() {
		return "/boards/gallery/galleryBoardEdit";
	}
	
	
}
