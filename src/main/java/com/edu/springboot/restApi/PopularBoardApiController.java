package com.edu.springboot.restApi;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;



@RestController
public class PopularBoardApiController {
	
	
	@GetMapping("/api/popularBoards")
	// Map<String, Object>	{"key": value} 형태의 JSON
    public Map<String, Object> getPopularBoards(@RequestParam(name="category") String category){
		try {
			List<Map<String, String>> top10 = new ArrayList<>();
			
			switch (category) {
				case "free" : category="자유게시판";
				case "gallery" : category="갤러리게시판";
			}
			
			
			for (int i = 1; i <= 10; i++) {
                Map<String, String> board = new HashMap<>();
                board.put("title", category + " 인기 게시물 " + i);
                board.put("date", "2025-08-" + (i < 10 ? "0" + i : i));
                top10.add(board);
            }
			
            
			return Map.of(
	                "top10", top10,
	                "category_name", category
	            );
            
		} catch (Exception e) {
			e.printStackTrace();
            return Map.of("error", "API 실행 중 오류 발생");
		}
    }
}
