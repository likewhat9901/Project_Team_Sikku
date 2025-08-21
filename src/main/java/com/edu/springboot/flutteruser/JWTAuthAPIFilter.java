package com.edu.springboot.flutteruser;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class JWTAuthAPIFilter extends OncePerRequestFilter {

    private final JWTUtil jwtUtil;
    private final UserDetailsService userDetailsService;

    public JWTAuthAPIFilter(JWTUtil jwtUtil, UserDetailsService userDetailsService) {
        this.jwtUtil = jwtUtil;
        this.userDetailsService = userDetailsService;
    }
    
    // 인증이 필요하지 않은 공개 엔드포인트 목록
    private static final List<String> PUBLIC_ENDPOINTS = Arrays.asList(
        "/api/auth/register",
        "/api/auth/login",
        "/api/weather",
        "/api/ranking",
        "/api/top10boards"
    );

    @Override
    protected void doFilterInternal(HttpServletRequest request, 
                                  HttpServletResponse response, 
                                  FilterChain filterChain) throws ServletException, IOException {
        
        String requestPath = request.getRequestURI();
        String method = request.getMethod();
        
        // 공개 엔드포인트는 JWT 검증을 건너뛰기
        if (isPublicEndpoint(requestPath)) {
            filterChain.doFilter(request, response);
            return;
        }
        
        // Authorization 헤더에서 JWT 토큰 추출
        String authHeader = request.getHeader("Authorization");
        String token = null;
        String username = null;
        
        // Bearer 토큰 형식 확인
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            token = authHeader.substring(7); // "Bearer " 제거
            try {
                username = jwtUtil.extractUsername(token);
            } catch (Exception e) {
                // 토큰 파싱 실패
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\":\"Invalid token\"}");
                return;
            }
        }
        
        // 토큰이 있고 사용자명이 추출되었으며, 현재 SecurityContext에 인증 정보가 없는 경우
        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            
            try {
                UserDetails userDetails = userDetailsService.loadUserByUsername(username);
                
                // 토큰 유효성 검증
                if (jwtUtil.validateToken(token, userDetails.getUsername())) {
                    // 인증 객체 생성
                    UsernamePasswordAuthenticationToken authToken = 
                        new UsernamePasswordAuthenticationToken(
                            userDetails, 
                            null, 
                            userDetails.getAuthorities()
                        );
                    authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                    
                    // SecurityContext에 인증 정보 설정
                    SecurityContextHolder.getContext().setAuthentication(authToken);
                } else {
                    // 토큰이 유효하지 않음
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    response.getWriter().write("{\"error\":\"Token expired or invalid\"}");
                    return;
                }
            } catch (Exception e) {
                // 사용자 정보 로드 실패 또는 기타 오류
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\":\"Authentication failed\"}");
                return;
            }
        } else if (authHeader == null) {
            // Authorization 헤더가 없음
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"Authorization header missing\"}");
            return;
        }
        
        // 다음 필터로 계속 진행
        filterChain.doFilter(request, response);
    }
    
    /**
     * 공개 엔드포인트 여부 확인
     */
    private boolean isPublicEndpoint(String requestPath) {
        return PUBLIC_ENDPOINTS.stream()
                .anyMatch(endpoint -> requestPath.equals(endpoint) || requestPath.startsWith(endpoint + "/"));
    }
    
    /**
     * 필터를 적용하지 않을 요청인지 확인 (선택적 오버라이드)
     */
    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) throws ServletException {
        String path = request.getRequestURI();
        // /api/** 경로가 아닌 경우 필터 적용 안 함
        return !path.startsWith("/api/");
    }
}