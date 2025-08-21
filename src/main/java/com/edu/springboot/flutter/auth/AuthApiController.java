package com.edu.springboot.flutter.auth;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.edu.springboot.flutter.auth.dto.LoginRequest;
import com.edu.springboot.flutter.auth.dto.LoginResponse;
import com.edu.springboot.flutter.auth.dto.RegisterRequest;

@RestController
@RequestMapping("/api/flutter")
public class AuthApiController {
	
	@Autowired
	private AuthService authService;

    // Flutter에서 오는 요청을 허용 (간단 CORS)(안 하면 브라우저/에뮬레이터에서 CORS 에러 뜰 수 있음)
    @CrossOrigin(origins = "*")
    @PostMapping("/login") // POST /api/flutter/login 요청이 오면 이 메서드가 실행
    public ResponseEntity<?> login(@RequestBody LoginRequest req) {
    	/* @RequestBody LoginRequest req 
        : Flutter에서 보낸 JSON({"username":"xxx","password":"yyy"})을 LoginRequest DTO에 자동으로 매핑해줌. */
    	
    	// Debug
    	System.out.println("받은 userid = " + req.getUserid());
    	System.out.println("받은 userpw = " + req.getUserpw());
    	
    	String userid = req.getUserid();
    	String userpw = req.getUserpw();
    	
    	try {
    		LoginResponse response = authService.login(req.getUserid(), req.getUserpw());
            return ResponseEntity.ok(response);
		} catch (Exception e) {
			return ResponseEntity.status(401).body(Map.of("error", e.getMessage()));
		}
    }
    
    // 회원가입
    @CrossOrigin(origins = "*")
    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody RegisterRequest req) {
        System.out.println("회원가입 요청 userid = " + req.getUserid());

        try {
            authService.register(req);
            
            return ResponseEntity.ok(Map.of("message", "회원가입 성공"));
        } catch (IllegalStateException dup) {         // 중복 아이디
            return ResponseEntity.status(409).body(Map.of("error", dup.getMessage()));
        } catch (IllegalArgumentException bad) {      // 필수값 누락 등
            return ResponseEntity.badRequest().body(Map.of("error", bad.getMessage()));
        } catch (Exception e) {                       // 기타
            return ResponseEntity.internalServerError().body(Map.of("error", "회원가입 실패"));
        }
    }
    
    // 회원가입 - 아이디 중복 확인 API
    @CrossOrigin(origins = "*")
    @GetMapping("/check-id/{userid}")
    public ResponseEntity<Boolean> checkIdDuplicate(@PathVariable("userid") String userid) {
        boolean available = authService.isUserIdAvailable(userid);
        return ResponseEntity.ok(available);
    }
}
