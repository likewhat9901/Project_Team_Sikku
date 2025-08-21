package com.edu.springboot.flutteruser;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.edu.springboot.flutteruser.dto.RegisterRequest;
import com.edu.springboot.flutteruser.dto.UserResponse;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthRegisterController {
    
    private final UserService service;
    private final AuthTokenService authTokenService;
    /**
     * 사용자 등록
     */
    @PostMapping("/api/auth/register")
    public ResponseEntity<?> registerUser(@RequestBody RegisterRequest req) {
    	UserResponse user = service.register(req);
        // 회원가입 직후 자동 로그인 토큰 발급
//        String token = authTokenService.loginAndIssueToken(req.getUserid(), req.getUserpw());
        return ResponseEntity.ok(
//            Map.of("user", user, "token", token, "tokenType", "Bearer")
        		user
        );
    }

}
