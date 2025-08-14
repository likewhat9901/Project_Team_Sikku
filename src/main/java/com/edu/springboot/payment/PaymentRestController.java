package com.edu.springboot.payment;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

@RestController
public class PaymentRestController {
	
	@Value("${toss.widget.secret-key}")
    private String WIDGET_SECRET_KEY; // 토스 시크릿 키

    @PostMapping("/confirm")
    public ResponseEntity<?> confirmPayment(@RequestBody Map<String, Object> request) {
        String paymentKey = (String) request.get("paymentKey");
        String orderId = (String) request.get("orderId");
        Integer amount = Integer.valueOf(request.get("amount").toString());

        // 시크릿 키 인코딩 (Basic Auth)
        String encodedAuth = Base64.getEncoder()
                .encodeToString((WIDGET_SECRET_KEY + ":").getBytes(StandardCharsets.UTF_8));
        String authorizationHeader = "Basic " + encodedAuth;

        // 요청 Body 구성
        Map<String, Object> body = new HashMap<>();
        body.put("orderId", orderId);
        body.put("amount", amount);
        body.put("paymentKey", paymentKey);

        // HTTP 요청 설정
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Authorization", authorizationHeader);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);

        // RestTemplate 호출
        RestTemplate restTemplate = new RestTemplate();
        try {
            ResponseEntity<Map> response = restTemplate.exchange(
                    "https://api.tosspayments.com/v1/payments/confirm",
                    HttpMethod.POST,
                    entity,
                    Map.class
            );
            // 결제 성공 응답
            return ResponseEntity.status(response.getStatusCode()).body(response.getBody());
        } catch (Exception e) {
            // 결제 실패 응답
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("error", e.getMessage()));
        }
    }
    
    
}
