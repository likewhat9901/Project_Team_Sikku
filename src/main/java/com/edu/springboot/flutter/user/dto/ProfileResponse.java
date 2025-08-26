package com.edu.springboot.flutter.user.dto;

import com.edu.springboot.jpaboard.MemberEntity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ProfileResponse {

    private String userId;
    private String authority;
    private Integer enabled;
    private String username;
    private String phonenumber;
    private String email;
    private String address;
    private String profileImgPath;
    
    public static ProfileResponse fromEntity(MemberEntity m) {
        return new ProfileResponse(
                m.getUserId(),
                m.getAuthority(),
                m.getEnabled(),
                m.getUsername(),
                m.getPhonenumber(),
                m.getEmail(),
                m.getAddress(),
                m.getProfileImgPath()
        );
    }
    
}
