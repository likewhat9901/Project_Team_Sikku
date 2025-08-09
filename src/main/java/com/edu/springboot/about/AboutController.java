package com.edu.springboot.about;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;


@Controller
public class AboutController {
	
	
	@GetMapping("/about/identity.do")
	public String identity() {
		return "/about/identity";
	}
	
	

}
