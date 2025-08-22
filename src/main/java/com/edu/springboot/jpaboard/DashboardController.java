package com.edu.springboot.jpaboard;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class DashboardController {
	
	@Autowired
	BoardService bs;
	
	// API 엔드포인트 → JSON 반환
    @GetMapping("/api/dashboard/weekly-posts")
    public List<WeeklyPostCountDTO> getWeeklyPostStats() {
    	
        return bs.getWeeklyPosts();
    }

}
