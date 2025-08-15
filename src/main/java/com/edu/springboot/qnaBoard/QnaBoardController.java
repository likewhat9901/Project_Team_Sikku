package com.edu.springboot.qnaBoard;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class QnaBoardController {
	
	@Autowired
	private QnaBoardService qnaService;
	
	//================== List 페이지 ==========================
	// List 페이지 이동
    @GetMapping("/qnaBoardList.do")
    public String list(Model model) {
    	
        model.addAttribute("noticeRows", qnaService.getNoticeList());
        model.addAttribute("qnaRows", qnaService.getQnaList());
        
        return "boards/qna/qnaBoardList"; // JSP 경로
    }
    
    // 검색 기능
    @GetMapping("/qna/search.do")
    public String search(
        @RequestParam("type") String type,
        @RequestParam("keyword") String keyword,
        Model model) {
    	
    	//공지글은 고정
    	model.addAttribute("noticeRows", qnaService.getNoticeList());
    	
    	//검색된 게시글로 업데이트
        if (keyword == null || keyword.trim().isEmpty()) {
            model.addAttribute("qnaRows", qnaService.getQnaList()); // ← 공지 제외된 일반글
        } else {
            model.addAttribute("qnaRows", qnaService.qnaSearch(type, keyword));
        }
        
        return "boards/qna/qnaBoardList";
    }
    
    //================== View 페이지 ==========================
  	// View 페이지 이동
    @GetMapping("/qnaBoardView.do")
    public String view(@RequestParam("idx") Long idx, Model model) {
        // QnaService에서 게시글 하나 가져오는 메서드가 있다고 가정
        QnaBoardEntity qna = qnaService.getQnaOneById(idx);
        
        // 예외상황 대비
        if (qna == null) {
        	model.addAttribute("errorMsg", "존재하지 않는 게시글입니다.");
            return "redirect:/qnaBoardList.do";
        }

        model.addAttribute("qna", qna);
        return "boards/qna/qnaBoardView"; // JSP 경로
    }
    
    
    
    //================== Write 페이지 ==========================
  	// Write 페이지 이동
    @GetMapping("/qnaBoardWrite.do")
    public String write(Model model) {
    	
        
        return "boards/qna/qnaBoardWrite"; // JSP 경로
    }


}
