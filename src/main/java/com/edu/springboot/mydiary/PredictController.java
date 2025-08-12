package com.edu.springboot.mydiary;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
@RequestMapping("/api/predict")
public class PredictController {
	// application.yml에 파이썬실행파일, py파일, csv파일 경로 설정
    @Value("${predict.python.bin}")
    private String pythonBin;

    @Value("${predict.script.path}")
    private String scriptPath;

    @Value("${predict.data.csvdir}")
    private String csvDir;

    private final ObjectMapper mapper = new ObjectMapper();

    //api/predict/outdoor의 요청을 받고 응답 헤더를 json,utf-8로 설정. 하지 않으면 한글 깨짐
    @GetMapping(value="/outdoor", produces = "application/json; charset=UTF-8")
    public ResponseEntity<JsonNode> getOutdoorForecast() {
        try {
            List<String> cmd = new ArrayList<>();
            cmd.add(pythonBin);  cmd.add("-u"); 
            cmd.add(scriptPath); cmd.add("--csvDir"); cmd.add(csvDir);
            
            
            ProcessBuilder pb = new ProcessBuilder(cmd);
            pb.redirectErrorStream(false);
            // 파이썬 표준출력/에러 UTF-8 강제
            pb.environment().put("PYTHONIOENCODING", "UTF-8"); 
            Process p = pb.start();

            // 30초안에 안되면 강제 종료
            if (!p.waitFor(30, TimeUnit.SECONDS)) {
                p.destroyForcibly();
                return ResponseEntity.status(HttpStatus.REQUEST_TIMEOUT).build();
            }

            //stdout만 JSON으로 파싱
            String stdout = new BufferedReader(
            		new InputStreamReader(p.getInputStream(), StandardCharsets.UTF_8))
            		.lines().collect(java.util.stream.Collectors.joining());
            
            // (선택) stderr는 서버 로그로만 확인
            String stderr = new BufferedReader(
                    new InputStreamReader(p.getErrorStream(), StandardCharsets.UTF_8))
                    .lines().collect(java.util.stream.Collectors.joining());
            if (!stderr.isBlank()) {
                System.err.println("[PY STDERR] " + stderr);
            }
            
            JsonNode json = mapper.readTree(stdout);
            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(json);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
