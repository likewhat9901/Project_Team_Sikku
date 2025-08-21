package com.edu.springboot.flutter.auth;

import java.security.Key;
import java.util.Date;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;

public class JwtTokenProvider {

    // 🔐 시크릿 키 (실제 서비스에서는 외부 설정이나 환경변수로 관리)
    private static final Key key = Keys.secretKeyFor(SignatureAlgorithm.HS256);
    private static final long EXPIRATION_MS = 1000 * 60 * 60; // 1시간

    // 토큰 생성 메서드
    public static String generateToken(String username) {
        return Jwts.builder()
                .setSubject(username)                   // 누구를 위한 토큰인지
                .setIssuedAt(new Date())                // 발급 시각
                .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION_MS)) // 만료 시각
                .signWith(key)                          // 서명 키
                .compact();
    }
}
