package com.edu.springboot.qnaBoard;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "qna_board")
public class QnaBoardEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "qna_seq_gen")
    @SequenceGenerator(name = "qna_seq_gen", sequenceName = "qna_board_seq", allocationSize = 1)
    private Long idx;

    private Long writerid;
    private String writer;
    private String title;

    @Lob //Large Object: CLOB, BLOB 등 대용량 텍스트나 파일 필드에 사용
    private String content;

    private String category;
    private String secretflag;
    @Column(name = "noticeflag")
    private String noticeflag;
    private String answerstatus;

    @Lob //Large Object: CLOB, BLOB 등 대용량 텍스트나 파일 필드에 사용
    private String answercontent;

    private Integer views;
    private Integer likes;
    
    private LocalDateTime postdate;
    private LocalDateTime updatedate;

}


