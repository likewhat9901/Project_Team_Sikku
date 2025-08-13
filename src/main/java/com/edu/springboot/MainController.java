package com.edu.springboot;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.edu.springboot.dict.DictDTO;
import com.edu.springboot.dict.IDictService;

@Controller
public class MainController {
	
	@Autowired
	IDictService dao;
    
    @RequestMapping("/")
    public String main() {
        return "intro/about";
    }
	
	@GetMapping("/main/member.do")
	public String member(Model model) {
		//로그인한 
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	    String userId = auth.getName();
		
	    //List<DictDTO> plants = dao.selectAll();
	    // 사용자가 등록한 식물만 보이게 수정
		List<DictDTO> plants = dao.selectPlantsByUser(userId);

//		System.out.println(plants);
		model.addAttribute("plants", plants);
		
		return "main/member";
	}
	
	@GetMapping("/main/nonMember.do")
	public String nonMember() {
		
		
		return "main/nonMember";
	}
    
}
