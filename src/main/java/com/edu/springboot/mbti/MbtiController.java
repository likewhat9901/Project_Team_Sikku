package com.edu.springboot.mbti;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpServletRequest;


@Controller
public class MbtiController {
	
	@Autowired
	IMbtiService dao;

	@GetMapping("/mbti/list.do")
	public String mbti(Model model) {
		
		List<MbtiDTO> MBTIs = dao.MbtiSelectDistinct();
		
		System.out.println("MBTIs: " + MBTIs);
		model.addAttribute("MBTIs", MBTIs);
		
		return "mbti/mbtiList";
	}
	
	@GetMapping("mbti/view.do")
	public String mbtiView(Model model, HttpServletRequest req) {
		String mbtiName = req.getParameter("mbti");
		System.out.println("mbtiName: "+ mbtiName);
		
		List<MbtiDTO> MBTI = dao.MbtiSelectOneByName(mbtiName);
		model.addAttribute("MBTI", MBTI);
		
		for(int i = 0; i < MBTI.size(); i++) {
			MbtiDTO dto = MBTI.get(i);
			if("실내용".equals(dto.getCategory())) {
				model.addAttribute("MBTI_indoor", dto);
				System.out.println("MBTI_indoor: "+ dto);
			}
			else if ("텃밭용".equals(dto.getCategory())) {
	            model.addAttribute("MBTI_outdoor", dto);
	            System.out.println("MBTI_outdoor: "+ dto);
	        }
		}
		
		String curMbti = mbtiName.toUpperCase();
		
		List<String> order = Arrays.asList(
		        "INTJ","INTP","ENTJ","ENTP","INFJ","INFP","ENFJ","ENFP",
		        "ISTJ","ISFJ","ESTJ","ESFJ","ISTP","ISFP","ESTP","ESFP"
		    );
		
		int n = order.size();
	    int idx = order.indexOf(curMbti);
	    if (idx < 0) idx = 0; // 방어

	    String prev = order.get((idx - 1 + n) % n);
	    String next = order.get((idx + 1) % n);

	    model.addAttribute("currentMbti", curMbti);
	    model.addAttribute("prevMbti", prev);
	    model.addAttribute("nextMbti", next);
		
		
		return "mbti/mbtiView";
	}
	

}
