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
	
    @GetMapping("/qnaBoardList.do")
    public String list(Model model) {
        model.addAttribute("noticeRows", qnaService.getNoticeList());
        model.addAttribute("qnaRows", qnaService.getQnaList());
        return "boards/qna/qnaBoardList"; // JSP 경로
    }

    @GetMapping("/search.do")
    public String search(@RequestParam("keyword") String keyword, Model model) {
        List<QnaBoardEntity> results = qnaService.search(keyword);
        model.addAttribute("qnaRows", results);
        model.addAttribute("noticeRows", qnaService.getNoticeList()); // 필요 시 유지
        return "qna/qnaBoardList";
    }

}
