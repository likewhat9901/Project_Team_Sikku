package com.edu.springboot.restApi;

import lombok.Data;

@Data
public class WeatherDTO {
    private String tm;   	// 시간
    private String stnNm;   // 지점명
    private String ta;   	// 기온
    private String rn;   	// 강수량
    private String ws;   	// 풍속
    private String wd;   	// 풍향
    private String hm;   	// 습도
    private String ss;   	// 일조
}
