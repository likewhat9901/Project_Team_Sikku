package com.edu.springboot.dict;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class DictController {
	
	@Autowired
	IDictService dao;
	

	@GetMapping("/dict/list.do")
	public String dictList(Model model) {
		
		List<DictDTO> plants = dao.selectAll();
		
		System.out.println("plants: " + plants);
		model.addAttribute("plants", plants);
		
		return "dict/dictList";
	}
	
	@GetMapping("/dict/view.do")
	public String dictView(Model model, HttpServletRequest req) {
		
		int plantidx = Integer.parseInt(req.getParameter("plantidx"));
		System.out.println("plantidx: "+ plantidx);
		
		DictDTO plant = dao.selectOne(plantidx);
		
		//plant 출력 확인
		if (plant == null) {
		    System.out.println("plant is NULL!");
		} else {
		    System.out.println("plant: " + plant);
		}
		
		model.addAttribute("plant", plant);
		
		return "dict/dictView";
	}
	
	
	
	

}
