package com.edu.springboot.jpaboard;

import jakarta.persistence.*;
import lombok.Data;
import lombok.ToString;

import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "hlike")
/* 순환 참조 발생
 -> 자동 생성되는 toString 메서드에서 board 필드는 제외 */
@ToString(exclude = {"board"})
public class LikeEntity {

    @Id
    /* DB가 자동으로 이 필드 값을 증가시키며 생성 */
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "LIKE_IDX") // 컬럼명 명시
    private Long likeIdx;

    // BoardEntity와 N:1 관계 설정
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "BOARD_IDX", nullable = false)
    private BoardEntity board; 

    @Column(name="USER_ID", nullable = false, length = 255)
    private String userId;

    @Column(name="LIKEDDATE", nullable = false)
    private LocalDateTime likedDate;
    

}
