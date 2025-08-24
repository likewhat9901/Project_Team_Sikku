package com.edu.springboot.jpaboard;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class DashboardController {
	
	@Autowired
	BoardService bs;
	
	@Autowired
	CommentService cs;
	
	@Autowired
	MemberService ms;
	
	// API 엔드포인트 → JSON 반환
    @GetMapping("/api/dashboard/weekly-posts")
    public List<WeeklyPostCountDTO> getWeeklyPostStats() {
    	
        return bs.getWeeklyPosts();
    }
    
    @GetMapping("/api/dashboard/weekly-comments")
    public List<WeeklyPostCountDTO> getWeeklyCommentStats() {
    	
        return cs.getWeeklyComments();
    }

    @GetMapping("/api/dashboard/weekly-top5")
    public List<WeeklyTop5PostDTO> getWeeklyTop5Stats() {
    	
    	return bs.getWeeklyTop5();
    }
    
    @GetMapping("/api/dashboard/weekly-user")
    public List<WeeklyUserDTO> getWeeklyUserStats() {
    	
    	return ms.getWeeklyUsers();
    }
}
