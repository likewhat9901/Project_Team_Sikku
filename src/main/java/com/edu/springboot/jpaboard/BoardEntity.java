package com.edu.springboot.jpaboard;


import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import jakarta.persistence.OneToMany;
import jakarta.persistence.PrePersist;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;



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
    @Column(name = "boardidx", nullable = false, length = 100)
    private Long boardIdx;

    @Column(name = "userid", nullable = false)
    private String userId; // 외래키 (실제로는 MemberEntity와 연결 가능)

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

//    @Column(columnDefinition = "NUMBER DEFAULT 0")
//    private Integer likes;
    
    // 게시글(Board) 과 좋아요(Like) 는 '1:다(One-to-Many)' 관계를 형성
    
    @OneToMany(mappedBy = "board", fetch = FetchType.EAGER,
    				cascade = CascadeType.ALL, orphanRemoval = true)
    private List<LikeEntity> likes = new ArrayList<>();

    @Column(columnDefinition = "NUMBER DEFAULT 0")
    private Integer report;

    @PrePersist
    protected void onCreate() {
        this.postdate = LocalDateTime.now();
        if (this.category == null) this.category = 1;
        if (this.visitcount == null) this.visitcount = 0;
//        if (this.likes == null) this.likes = 0;
        if (this.report == null) this.report = 0;
    }
}





