package com.edu.springboot.restApi;


import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.ObjectMapper;

/*
 * 파이썬 경로설정, 모듈 설치 필요
 * 경로설정: ProcessBuilder 부분
 * 모듈설치(cmd에서):
 * 	C:\01DevelopKits\miniconda3\python.exe -m pip install pandas requests python-dotenv
 */

@RestController
public class RankingApiController {
	
	@Value("${naver.api.id}")
	private String apiId;
	
	@Value("${naver.api.secret}")
	private String apiSecret;
	
	@GetMapping("/api/ranking")
	// Map<String, Object>	{"key": value} 형태의 JSON
    public Map<String, Object> getRanking(@RequestParam(name="category") String category){
		try {
			//===========디버깅==============
			// Python 스크립트 경로 객체 생성
	        File scriptFile = new File("src/main/python/ranking.py");

	        // 절대 경로 출력
	        System.out.println("▶ Python 스크립트 절대 경로: " + scriptFile.getAbsolutePath());
	        System.out.println("▶ 파일 존재 여부: " + scriptFile.exists());

	        // 존재하지 않으면 즉시 리턴
	        if (!scriptFile.exists()) {
	            return Map.of("error", "Python 스크립트를 찾을 수 없습니다.");
	        }
	        
	        System.out.println("Java PATH=" + System.getenv("PATH"));
	        System.out.println("category=" + category);
	        //============================
	        
	        // 외부 프로그램(여기서는 Python)을 실행하기 위한 도구 (python.exe 경로 설정 필수)
            ProcessBuilder pb = new ProcessBuilder("C:\\01DevelopKits\\Python313\\python.exe", 
            		"src/main/python/ranking.py", category);	// category는 py파일에 넘길 인자
            pb.environment().put("NAVER_AD_API_CLIENT_ID", apiId);
            pb.environment().put("NAVER_AD_API_CLIENT_SECRET", apiSecret);
            pb.redirectErrorStream(false);	//true: 오류 메시지도 같이 읽을 수 있도록 설정
            Process process = pb.start();	//ranking.py 실행
            
            // stdout 읽기
            BufferedReader reader = new BufferedReader(
            		new InputStreamReader(process.getInputStream(), "MS949"));
            StringBuilder output = new StringBuilder(); //Python이 출력한 결과를 한 줄씩 모아 저장할 변수 선언
            String line;	//한줄을 담을 변수
            // 한줄씩 읽어서 output에 담기
            while ((line = reader.readLine()) != null) {
                output.append(line).append("\n");
            }
            
            // stderr 읽기
            BufferedReader errorReader = new BufferedReader(
                    new InputStreamReader(process.getErrorStream(), "MS949"));
            StringBuilder errorOutput = new StringBuilder();
            while ((line = errorReader.readLine()) != null) {
                errorOutput.append(line).append("\n");
            }
            
            process.waitFor();	//Python 프로그램이 끝날 때까지 기다림
            
            // JSON 문자열 → Map으로 변환
            ObjectMapper mapper = new ObjectMapper();	//JSON 문자열을 Java 객체로 변환하기 위한 도구(Jackson 라이브러리)
            
            //디버깅용
            System.out.println("[DEBUG] Python STDOUT:\n" + output);
            System.err.println("[DEBUG] Python STDERR:\n" + errorOutput);
            
            //JSON 문자열을 Map<String, Object>로 변환하여 리턴
            return mapper.readValue(output.toString(), Map.class);
            
		} catch (Exception e) {
			e.printStackTrace();
            return Map.of("error", "Python 실행 중 오류 발생");
		}
    }
}
