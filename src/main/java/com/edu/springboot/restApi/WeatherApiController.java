package com.edu.springboot.restApi;


import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;



@RestController
public class WeatherApiController {
	
	@Value("${weather.apikey}")
	private String apiKey;
	
	@GetMapping("/api/weather")
    public List<Map<String, String>> getWeatherJson(){
		List<Map<String, String>> result = new ArrayList<>();
		
		try {
			LocalDateTime now = LocalDateTime.now().minusMinutes(1);
	        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmm");
	        String currentTimeStr = now.format(formatter);
			
			String baseUrl = "https://apihub.kma.go.kr/api/typ01/cgi-bin/url/nph-aws2_min"
					+ "?tm2=" + currentTimeStr
					+ "&stn=0"
					+ "&disp=0"
					+ "&help=1"
					+ "&authKey=" + apiKey;
			
			//URL접속해서 데이터 가져오기. 줄단위로 BufferedReader에 저장
			URL url = new URL(baseUrl);
			BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));
			
			//데이터 파싱 준비
			String line;
			String[] columns = null;
			
			//한 줄씩 API 응답 읽기. null이 나올때까지 반복
			while ((line = in.readLine()) != null) {
				//주석 #로 시작하는 줄은 스킵. 단, YYMMDDHHMI라는 컬럼명이 포함된 줄은 컬럼 배열로 저장
				if (line.startsWith("#")) {
					//주석 줄 중에 컬럼명이 포함된 줄 찾기
					if (line.contains("YYMMDDHHMI")) { 
						//.split("\\s+"): 공백 기준으로 분리. 결과 -> String[] columns
						//columns = {"YYMMDDHHMI", "STN", "WD1", "WS1", "TA", "RN-15m"}
						columns = line.replace("#", "").trim().split("\\s+"); 
					}
					continue;
				}
				//컬럼 유무 확인 & 현재 줄 빈 줄이 아닌지 확인
				if (columns != null && !line.trim().isEmpty()) {
					//공백을 기준으로 잘라서 배열로 만들기
					String[] values = line.trim().split("\\s+");
					if (values.length < columns.length) continue; // 컬럼보다 값이 적으면 skip
					//하나의 줄을 JSON객체처럼 담을 Map 생성. LinkedHashMap을 쓰는 이유는 → 입력 순서를 보존하기 위해서
					Map<String, String> row = new LinkedHashMap<>();
					//컬럼과 데이터를 짝지어서 Map에 추가
					for (int i = 0; i < columns.length; i++) {
						row.put(columns[i], values[i]);
					}
					//완성된 Map을 result 리스트에 추가
					result.add(row);
				}
			}
			in.close();
//        	System.out.println(result);
			
		} catch (Exception e) {
			throw new RuntimeException("날씨 데이터 파싱 실패", e);
		}
		return result;
    }
}
