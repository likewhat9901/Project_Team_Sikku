package com.edu.springboot.jpaboard;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
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
@Table(name = "BOARD_IMAGE")
public class BoardImageEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "IMAGE_IDX")
    private Long imageIdx;
    
    // BoardEntity와 N:1 관계 설정
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "BOARD_IDX", nullable = false)
    private BoardEntity board;

    @Column(name = "ORIGINAL_NAME")
    private String originalName;
    
    @Column(name = "SAVED_NAME")
    private String savedName;
    
    @Column(name = "FILEPATH")
    private String filePath;

}

