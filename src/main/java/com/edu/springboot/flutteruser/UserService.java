package com.edu.springboot.flutteruser;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edu.springboot.flutteruser.dto.RegisterRequest;
import com.edu.springboot.flutteruser.dto.UserResponse;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {

	private final UserRepo userRepo;
    private final BCryptPasswordEncoder passwordEncoder;

    @Transactional
    public UserResponse register(RegisterRequest req) {
        if (userRepo.existsByUserid(req.getUserid())) {
            throw new IllegalArgumentException("이미 존재하는 아이디입니다.");
        }

        User saved = userRepo.save(
            User.builder()
                .userid(req.getUserid())
                .userpw(passwordEncoder.encode(req.getUserpw())) // ✅ BCrypt 해시
                .authority("ROLE_USER")                         // ✅ 권한
                .enabled(1)                                     // ✅ 활성화
                .username(req.getUsername())
                .phoneNumber(req.getPhoneNumber())
                .email(req.getEmail())
                .address(req.getAddress())
                .build()
        );
        return new UserResponse(saved.getUserid(), saved.getUsername(), saved.getEmail());
    }
}