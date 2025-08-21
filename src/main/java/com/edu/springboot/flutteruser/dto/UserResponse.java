package com.edu.springboot.flutteruser.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

//회원가입 응답 DTO

@Data
@AllArgsConstructor
public class UserResponse {
	private String userid;
    private String username;
    private String email;
}
