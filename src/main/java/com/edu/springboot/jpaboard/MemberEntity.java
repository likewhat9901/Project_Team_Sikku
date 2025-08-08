package com.edu.springboot.jpaboard;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;


@Data
@Entity
@Table(name = "members")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberEntity {

	@Id
    @Column(name = "userid", length = 30)
    private String userId;

    @Column(name = "userpw", nullable = false, length = 200)
    private String userpw;

    @Column(name = "authority", length = 20, insertable = false) 
    private String authority;

    @Column(name = "enabled", insertable = false) 
    private Integer enabled;

    @Column(name = "username", unique = true, length = 100)
    private String username;

    @Column(name = "phonenumber", unique = true, length = 20)
    private String phonenumber;

    @Column(name = "email", unique = true, length = 100)
    private String email;

    @Column(name = "address", length = 200)
    private String address;
	
}
