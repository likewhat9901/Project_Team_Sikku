package com.edu.springboot.restApi;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.edu.springboot.jpaboard.BoardEntity;
import com.edu.springboot.jpaboard.BoardService;



@RestController
public class PopularBoardApiController {
	
	@Autowired
    private BoardService boardService;
	
	
	@GetMapping("/api/top10boards")
	// Map<String, Object>	{"key": value} 형태의 JSON
    public Map<String, Object> getTop10Boards(@RequestParam(name="category", defaultValue="free") String category){
		try {
			List<BoardEntity> top10Boards = boardService.getTop10Boards();
			
			Map<String, Object> response = new HashMap<>();
			response.put("category", category);  // 원하는 필드를 추가
	        response.put("top10Boards", top10Boards);  // top 10 게시글 추가
	        
	        return response;
			
		} catch (Exception e) {
			// 예외 처리
	        Map<String, Object> errorResponse = new HashMap<>();
	        errorResponse.put("error", "API 오류: top10boards.");
	        return errorResponse;
		}
    }
}
