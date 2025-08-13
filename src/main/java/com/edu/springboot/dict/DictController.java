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
		
		// 전체 plantidx 순서 가져오기
	    List<Integer> order = dao.selectAllPlantidx(); // plantidx만 순서대로 가져오는 DAO 메서드

	    int n = order.size();
	    int idx = order.indexOf(plantidx);

	    // 이전, 다음 계산 (순환)
	    int prevIdx = (idx - 1 + n) % n;
	    int nextIdx = (idx + 1) % n;

	    int prevPlant = order.get(prevIdx);
	    int nextPlant = order.get(nextIdx);

	    // JSP에서 사용할 수 있도록 추가
	    model.addAttribute("prevDict", prevPlant);
	    model.addAttribute("nextDict", nextPlant);
		
		return "dict/dictView";
	}
	
	
	
	

}
