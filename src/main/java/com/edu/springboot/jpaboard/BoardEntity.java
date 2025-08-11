package com.edu.springboot.jpaboard;


import java.time.LocalDateTime;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import jakarta.persistence.PrePersist;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


/*
 * CREATE TABLE hboard (
  board_idx     NUMBER          PRIMARY KEY,
  member_idx   NUMBER          NOT NULL,
  title        VARCHAR2(100)   NOT NULL,
  content      CLOB            NOT NULL,
  ofile        VARCHAR2(255),
  sfile        VARCHAR2(255),
  postdate     DATE            DEFAULT SYSDATE,              
  category     NUMBER(1)       DEFAULT 1 CHECK (category IN (1, 2)),
  visitcount   NUMBER          DEFAULT 0,  
  likes        NUMBER          DEFAULT 0,
  report       NUMBER          DEFAULT 0,
  CONSTRAINT fk_board_member FOREIGN KEY (member_idx) REFERENCES hmember(member_idx)
);
 * 오라클 컬럼명은 언더바(board_idx)를 이용한 스네이크_표기법이므로
 * 자바언어로 작성할때는 자바표준인 카멜 표기법(boardIdx)으로 적습니다. 
*/


@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
@Table(name = "hboard")
public class BoardEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "boardSeqGenerator")
    @SequenceGenerator(
        name = "boardSeqGenerator",      // JPA에서 사용할 이름
        sequenceName = "boardSeq",        // 실제 오라클 시퀀스 이름
        allocationSize = 1                 // 오라클 시퀀스 INCREMENT BY와 일치
    )
    @Column(name = "boardIdx", nullable = false, length = 100)
    private Long boardIdx;

    @Column(nullable = false)
    private Long memberIdx; // 외래키 (실제로는 MemberEntity와 연결 가능)

    @Column(nullable = false, length = 100)
    private String title;

    @Lob
    @Column(nullable = false)
    private String content;

    @Column(length = 255)
    private String ofile;

    @Column(length = 255)
    private String sfile;

    @Column(columnDefinition = "DATE DEFAULT SYSDATE")
    private LocalDateTime postdate;

    @Column(columnDefinition = "NUMBER(1) DEFAULT 1 CHECK (category IN (1, 2))")
    private Integer category;

    @Column(columnDefinition = "NUMBER DEFAULT 0")
    private Integer visitcount;

    @Column(columnDefinition = "NUMBER DEFAULT 0")
    private Integer likes;

    @Column(columnDefinition = "NUMBER DEFAULT 0")
    private Integer report;

    @PrePersist
    protected void onCreate() {
        this.postdate = LocalDateTime.now();
        if (this.category == null) this.category = 1;
        if (this.visitcount == null) this.visitcount = 0;
        if (this.likes == null) this.likes = 0;
        if (this.report == null) this.report = 0;
    }
}





