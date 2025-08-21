package com.edu.springboot.flutter.auth;

import java.io.IOException;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class JwtAuthenticationFilter extends OncePerRequestFilter{
	
	@Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
        throws ServletException, IOException {

        try {
            String token = parseJwt(request);
            System.out.println("JWT 필터 실행됨, "+token);
            if (token != null && JwtTokenProvider.validateToken(token)) {
            	UsernamePasswordAuthenticationToken authentication =
            		(UsernamePasswordAuthenticationToken) JwtTokenProvider.getAuthentication(token);

        		authentication.setDetails(
        		    new WebAuthenticationDetailsSource().buildDetails(request));

            	// ✅ 인증 정보를 시큐리티 컨텍스트에 저장
                SecurityContextHolder.getContext().setAuthentication(authentication);
                System.out.println("인증 정보 시큐리티 컨텍스트에 저장되는지: " + 
                SecurityContextHolder.getContext().getAuthentication().getName());
            }
        } catch (Exception e) {
            System.out.println("JWT 인증 필터 오류: " + e.getMessage());
        }

        filterChain.doFilter(request, response);
    }

    // 🔎 Authorization 헤더에서 Bearer 토큰 꺼내기
    private String parseJwt(HttpServletRequest request) {
        String headerAuth = request.getHeader("Authorization");

        if (StringUtils.hasText(headerAuth) && headerAuth.startsWith("Bearer ")) {
            return headerAuth.substring(7);  // "Bearer " 이후 문자열만 추출
        }
        return null;
    }
}
