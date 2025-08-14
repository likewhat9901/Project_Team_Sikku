package com.edu.springboot.mydiary;

import java.util.Date;

import lombok.Data;

@Data
public class PlantMetrics {
    private Long plantidx;
    private Date latestDate;

    private Float latestHeight;     // 가장 최근 키
    private Float deltaHeight7d;    // 7일 전 대비 변화
    private Float deltaHeight30d;   // 30일 전 대비 변화

    private Integer latestFruit;    // 가장 최근 열매 수
    private Integer deltaFruit7d;   // 7일 전 대비 변화
    private Double weeklyAvgFruitInc; // 최근 4주 주간 평균 증가
}