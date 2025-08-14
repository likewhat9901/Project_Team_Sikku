package com.edu.springboot.jpaboard;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class QnaController {
	
	@GetMapping("/qna/qnaBoard.do")
	public String qnaBoard() {
		return "boards/qna/qna";
	}
	

}
