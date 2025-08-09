package com.edu.springboot.jpaboard;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;


@Data
@Entity
@Table(name = "comments")
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CommentEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "commentSeqGenerator")
    @SequenceGenerator(
        name = "commentSeqGenerator",      // JPA에서 사용할 이름
        sequenceName = "commentSeq",        // 실제 오라클 시퀀스 이름
        allocationSize = 1                 // 오라클 시퀀스 INCREMENT BY와 일치
    )
    @Column(name = "commentidx")
    private Long commentIdx;

    /*
    LazyInitializationException (지연 로딩 예외 발생)
     -> 세션이 닫힌 후 데이터 접근해서 예외가 발생함.
    // FetchType.LAZY -> FetchType.EAGER로 변경하였음.
    */
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "userid", nullable = false)
    private MemberEntity member;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "boardidx", nullable = false) // 오라클 DB의 컬럼명
    private BoardEntity board;  // JPA에서 사용할 객체 이름(별칭)

    @Column(nullable = false, length = 500)
    private String content;

    @Column
    private Integer likes = 0;

    @Column(name = "postdate", insertable = false, updatable = false)
    private LocalDateTime postDate;
}
