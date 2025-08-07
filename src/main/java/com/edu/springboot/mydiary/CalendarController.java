package com.edu.springboot.mydiary;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/calendar")
public class CalendarController {
	@Autowired
	private CalendarService calendarService;

	@GetMapping("/images")
	public List<DiaryPostResponse> getImagesForMonth(@RequestParam int year, 
			@RequestParam int month) {
		// 로그인한 사용자 ID 가져오기
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		String userId = auth.getName();
		
		//servise로 전달
		List<DiaryPostResponse> posts = calendarService.getPostsByMonth(year, month, userId);
		System.out.println("API 호출" + posts.size());
		return posts;
	}
}
