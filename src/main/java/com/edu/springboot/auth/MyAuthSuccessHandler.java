package com.edu.springboot.auth;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

@Component
public class MyAuthSuccessHandler implements AuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(
            HttpServletRequest request,
            HttpServletResponse response,
            Authentication authentication)
            throws IOException, ServletException {

        User user = (User) authentication.getPrincipal();
        boolean isAdmin = user.getAuthorities().stream()
                .anyMatch(auth -> "ROLE_ADMIN".equals(auth.getAuthority()));
        
        request.getSession().setAttribute("userRole", isAdmin ? "ROLE_ADMIN" : "ROLE_USER");

        if (isAdmin) {
            response.sendRedirect("/admin/index.do"); 
        } else {
            response.sendRedirect("/main/member.do");
        }

    }
}
