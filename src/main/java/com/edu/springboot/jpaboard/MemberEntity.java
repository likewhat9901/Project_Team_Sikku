package com.edu.springboot.jpaboard;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

/*
CREATE TABLE hmember (
  member_idx     NUMBER         PRIMARY KEY,
  userid         VARCHAR2(20)   NOT NULL UNIQUE,
  password       VARCHAR2(50)   NOT NULL,
  email          VARCHAR2(30)   UNIQUE,
  address        VARCHAR2(100),
  username       VARCHAR2(10)   NOT NULL UNIQUE,
  phonenumber    VARCHAR2(20)   NOT NULL,
  role           NUMBER(2)      NOT NULL CHECK (role IN (0, 1)),
  grade          NUMBER(1)      DEFAULT 1 CHECK (grade IN (1, 2, 3)), 
  created_at     DATE DEFAULT SYSDATE
);
*/

@Data
@Entity
@Table(name = "hmember")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "memberSeqGenerator")
    @SequenceGenerator(
        name = "memberSeqGenerator",      // JPA에서 사용할 이름
        sequenceName = "memberSeq",        // 실제 오라클 시퀀스 이름
        allocationSize = 1                 // 오라클 시퀀스 INCREMENT BY와 일치
    )
    @Column(name = "memberIdx")
    private Long memberIdx;

    @Column(name = "userid", nullable = false, unique = true, length = 20)
    private String userid;

    @Column(name = "password", nullable = false, length = 50)
    private String password;

    @Column(name = "email", unique = true, length = 30)
    private String email;

    @Column(name = "address", length = 100)
    private String address;

    @Column(name = "username", nullable = false, unique = true, length = 10)
    private String username;

    @Column(name = "phonenumber", nullable = false, length = 20)
    private String phoneNumber;

    @Column(name = "role", nullable = false)
    private Integer role;

    @Column(name = "grade")
    private Integer grade;

    @Column(name = "created_at", insertable = false, updatable = false)
    private LocalDateTime createdAt;
}
