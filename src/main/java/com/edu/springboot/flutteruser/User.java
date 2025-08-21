package com.edu.springboot.flutteruser;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

// DB 매핑용

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor 
@Builder
@Entity
@Table(name = "MEMBERS")
public class User {
	
	@Id
	@Column(name = "USERID", nullable = false, length = 255)
    private String userid;

    @Column(name = "USERPW", nullable = false, length = 255)
    private String userpw;

    @Column(name = "AUTHORITY", length = 20)
    private String authority;

    @Column(name = "ENABLED", nullable = false)
    private Integer enabled; 

    @Column(name = "USERNAME", length = 255)
    private String username;

    @Column(name = "PHONENUMBER", length = 255)
    private String phoneNumber;

    @Column(name = "EMAIL", length = 255)
    private String email;

    @Column(name = "ADDRESS", length = 200)
    private String address;

    @Column(name = "PROFILEIMGPATH", length = 255)
    private String profileImgPath;

}