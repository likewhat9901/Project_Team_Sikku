package com.edu.springboot.mbti;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpServletRequest;


@Controller
public class MbtiController {
	
	@Autowired
	MbtiService dao;

	@GetMapping("/mbti.do")
	public String mbti(Model model) {
		
		List<MbtiDTO> MBTIs = dao.MbtiSelectAll();
		
		System.out.println("MBTIs: " + MBTIs);
		model.addAttribute("MBTIs", MBTIs);
		
		return "mbti/mbti_list";
	}
	
	@GetMapping("/mbtiView.do")
	public String mbtiView(Model model, HttpServletRequest req) {
		int mbtiIdx = Integer.parseInt(req.getParameter("idx"));
		System.out.println("mbtiIdx: "+ mbtiIdx);
		
		return "mbti/mbti_view";
	}
	

}
