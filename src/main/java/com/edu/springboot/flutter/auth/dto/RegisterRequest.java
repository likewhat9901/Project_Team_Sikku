package com.edu.springboot.flutter.auth.dto;


import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
public class RegisterRequest {
    private String userid;       // 필수
    private String userpw;       // 필수 (평문으로 옴 → 서버에서 bcrypt 인코딩)
    private String username;     // 선택
    private String email;        // 선택
    private String phoneNumber;  // 선택
}
