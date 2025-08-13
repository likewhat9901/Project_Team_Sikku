package com.edu.springboot;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
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
		
		List<DictDTO> plants = dao.selectAll();
		
//		System.out.println(plants);
		model.addAttribute("plants", plants);
		
		return "main/member";
	}
	
	@GetMapping("/main/nonMember.do")
	public String nonMember() {
		
		
		return "main/nonMember";
	}
	
	@GetMapping("/dict/callback")
	public String ajax_local_callback() {
		
		
		return "dict/ajax_local_callback";
	}
    
}
