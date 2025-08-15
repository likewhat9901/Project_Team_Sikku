package com.edu.springboot.qnaBoard;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

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
import lombok.Setter;


@Getter
@Setter
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
    
    private String writerid;
    private String writer;//
    private String title;//글쓰기할때 post로 보낼거

    @Lob //Large Object: CLOB, BLOB 등 대용량 텍스트나 파일 필드에 사용
    private String content;//글쓰기할때 post로 보낼거
    
    private String category;//글쓰기할때 post로 보낼거
    private String secretflag;//글쓰기할때 post로 보낼거
    private String noticeflag = "N"; //이거는 디폴트 되어 있는데, 글쓰기 해보고
    //디폴트 안들어가면 밑에다 persist로 값 집어넣어주기
    private String answerstatus = "대기"; //이거는 디폴트 되어 있는데, 글쓰기 해보고
    //디폴트 안들어가면 밑에다 persist로 값 집어넣어주기

    @Lob //Large Object: CLOB, BLOB 등 대용량 텍스트나 파일 필드에 사용
    private String answercontent;

    private Integer views = 0;
    private Integer likes = 0;
    
    private LocalDateTime postdate = LocalDateTime.now();
    private LocalDateTime updatedate = LocalDateTime.now();
    
    
    public String getFormattedPostdate() {
        return postdate != null ? postdate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) : "";
    }

    public String getFormattedUpdatedate() {
        return updatedate != null ? updatedate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) : "";
    }

}



