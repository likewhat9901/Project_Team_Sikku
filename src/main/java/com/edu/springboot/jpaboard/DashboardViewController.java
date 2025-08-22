package com.edu.springboot.jpaboard;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/* 현 컨트롤러는 JSON API랑 분리된 JSP 열기용 컨트롤러입니다. */

@Controller
public class DashboardViewController {
	
	@GetMapping("/admin/dashboard")
    public String dashboardPage() {
		
        return "/admin/dashBoard";
	}
}
