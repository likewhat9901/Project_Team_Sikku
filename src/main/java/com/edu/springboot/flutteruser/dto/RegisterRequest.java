package com.edu.springboot.flutteruser.dto;

import lombok.Data;

//회원가입 요청 DTO
@Data
public class RegisterRequest {
	
	private String userid;
    private String userpw;
    private String username;
    private String phoneNumber;
    private String email;
    private String address;
}
