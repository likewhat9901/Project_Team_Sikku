package com.edu.springboot.jpaboard;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
@Table(name = "BOARD_REPORT")
public class BoardReportEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "reportSeqGenerator")  // IDENTITY → SEQUENCE로 변경
    @SequenceGenerator(
        name = "reportSeqGenerator",     // JPA에서 사용할 이름
        sequenceName = "REPORT_SEQ",     // 실제 오라클 시퀀스 이름
        allocationSize = 1               // 오라클 시퀀스 INCREMENT BY와 일치
    )
    @Column(name = "REPORT_IDX")
    private Long reportIdx;

    @Column(name = "BOARD_IDX", nullable = false)
    private Long boardIdx;

    @Column(name = "USER_ID", nullable = false, length = 255)
    private String userId;

    @Column(name = "CONTENT", nullable = false, length = 255)
    private String content;

    @Column(name = "REPORT_DATE", columnDefinition = "DATE DEFAULT SYSDATE")
    private LocalDateTime reportDate;

    // 연관관계 매핑 (선택사항)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "BOARD_IDX", insertable = false, updatable = false)
    private BoardEntity board;

    @PrePersist
    protected void onCreate() {
        if (this.reportDate == null) {
            this.reportDate = LocalDateTime.now();
        }
    }
}
