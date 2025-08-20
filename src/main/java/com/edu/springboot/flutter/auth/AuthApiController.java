package com.edu.springboot.flutter.auth;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.edu.springboot.flutter.auth.dto.LoginRequest;
import com.edu.springboot.flutter.auth.dto.LoginResponse;

@RestController
@RequestMapping("/api/flutter")
public class AuthApiController {

    // Flutter에서 오는 요청을 허용 (간단 CORS)(안 하면 브라우저/에뮬레이터에서 CORS 에러 뜰 수 있음)
    @CrossOrigin(origins = "*")
    @PostMapping("/login") // POST /api/flutter/login 요청이 오면 이 메서드가 실행
    public ResponseEntity<?> login(@RequestBody LoginRequest req) {
    	// Debug
    	System.out.println("받은 username = " + req.getUsername());
    	System.out.println("받은 password = " + req.getPassword());
    	
    	/* @RequestBody LoginRequest req 
        : Flutter에서 보낸 JSON({"username":"xxx","password":"yyy"})을 
          LoginRequest DTO에 자동으로 매핑해줌. */
        // ----- 더미 검증 로직 -----
        // 아이디/비번이 "test"/"1234"면 성공, 아니면 실패
        if ("test".equals(req.getUsername()) && "1234".equals(req.getPassword())) {
        	
        	/* ResponseEntity.ok(...)
			→ HTTP 상태 코드 200 OK와 함께 응답 바디를 돌려줌.
			(new LoginResponse(...)가 JSON으로 변환돼서 Flutter로 전달)
        	 */
        	// 진짜 JWT 대신 임시 토큰 문자열 리턴
            return ResponseEntity.ok(new LoginResponse("dummy-jwt-token-abc.def.ghi"));
        }
        // 실패 시 401
        return ResponseEntity.status(401).body("Invalid credentials");
    }
}
