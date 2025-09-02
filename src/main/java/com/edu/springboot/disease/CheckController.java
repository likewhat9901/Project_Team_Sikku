package com.edu.springboot.disease;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class CheckController {
	@Value("${predict.python.bin}")
	private String pythonBin;

	@Value("${predict.script.diseasepath}")
	private String scriptPath;

	@RequestMapping("/disease/check.do")
	public String check() {
		return "disease/check";
	}

	// ▼ 프론트에서 fetch('/predict', { method:'POST', body:FormData }) 로 호출
	@PostMapping(value = "/predict", consumes = MediaType.MULTIPART_FORM_DATA_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<?> predict(@RequestParam("fruit") String fruit, @RequestParam("image") MultipartFile image) {
		// ── (1) 기본 입력 검증만 수행: 과일명은 그대로 전달(차단 X)
		if (fruit == null || fruit.isBlank()) {
			return ResponseEntity.badRequest().body(Map.of("error", "과일명을 입력하세요."));
		}
		if (image == null || image.isEmpty()) {
			return ResponseEntity.badRequest().body(Map.of("error", "이미지 파일이 비어 있습니다."));
		}
		String ct = image.getContentType();
		if (ct == null || !ct.startsWith("image/")) {
			return ResponseEntity.badRequest().body(Map.of("error", "이미지 형식만 업로드 가능합니다."));
		}

		Path tmpDir = null;
		try {
			// ── (2) 업로드 이미지를 임시 경로에 저장
			tmpDir = Files.createTempDirectory("disease-");
			String ext = StringUtils.getFilenameExtension(image.getOriginalFilename());
			if (ext == null || ext.isBlank())
				ext = "jpg";
			Path imgPath = tmpDir.resolve("upload." + ext.toLowerCase());
			Files.copy(image.getInputStream(), imgPath, StandardCopyOption.REPLACE_EXISTING);

			// ── (3) 파이썬 CLI 실행 (※ --model 없음. 파이썬이 내부 MODEL_INFO 사용)
			ProcessBuilder pb = new ProcessBuilder(pythonBin, scriptPath, "--fruit", fruit, // ← 그대로 전달
					"--image", imgPath.toAbsolutePath().toString());

			// 한글/TF 로그 최소화
			Map<String, String> env = pb.environment();
			env.put("PYTHONIOENCODING", "utf-8");
			env.put("TF_CPP_MIN_LOG_LEVEL", "2");

			// pb.redirectErrorStream(true);
			Process p = pb.start();

			// stdout(JSON)과 stderr(경고 로그 등)를 분리해서 읽기
			String out;
			try (InputStream is = p.getInputStream()) {
				out = new String(is.readAllBytes(), StandardCharsets.UTF_8).trim();
			}
			String err;
			try (InputStream es = p.getErrorStream()) {
				err = new String(es.readAllBytes(), StandardCharsets.UTF_8).trim();
			}

			int code = p.waitFor();

			// ── (4) 파이썬 출력(JSON) 처리
			ObjectMapper mapper = new ObjectMapper();
			Map<String, Object> result = null;

			// 그대로 파싱
			try {
				result = mapper.readValue(out, new TypeReference<>() {
				});
			} catch (Exception parseErr) {
				// 파이썬이 JSON 외 로그를 섞어낼 경우 대비
				return ResponseEntity.status(500).body(Map.of("error", "예측 결과 파싱 실패", "detail", out));
			}

			// 파이썬이 에러 JSON을 주면(예: 지원하지 않는 과일) 그대로 400으로 전달
			if (result.containsKey("error")) {
				return ResponseEntity.badRequest().body(result);
			}

			// 정상 결과 키 확인
			if (code == 0 && result.containsKey("disease") && result.containsKey("confidence")) {
				return ResponseEntity.ok(result);
			} else {
				return ResponseEntity.status(500).body(Map.of("error", "파이썬 실행 오류", "detail", out));
			}

		} catch (Exception e) {
			return ResponseEntity.status(500).body(Map.of("error", "서버 내부 오류: " + e.getMessage()));
		} finally {
			// ── (5) 임시 파일 정리
			if (tmpDir != null) {
				try {
					Files.walk(tmpDir).sorted((a, b) -> b.compareTo(a)).forEach(path -> {
						try {
							Files.deleteIfExists(path);
						} catch (IOException ignored) {
						}
					});
				} catch (IOException ignored) {
				}
			}
		}
	}
}
