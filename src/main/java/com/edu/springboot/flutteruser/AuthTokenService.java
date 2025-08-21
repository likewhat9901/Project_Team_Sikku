package com.edu.springboot.flutteruser;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuthTokenService {
    private final AuthenticationManager authenticationManager;
    private final JWTUtil jwtUtil;

    public String loginAndIssueToken(String userid, String rawPassword) {
        // Spring Security가 내부적으로 userDetailsService+passwordEncoder로 검증
        authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(userid, rawPassword)
        );
        // 성공 시 토큰 발급
        return jwtUtil.generateToken(userid);
    }
}