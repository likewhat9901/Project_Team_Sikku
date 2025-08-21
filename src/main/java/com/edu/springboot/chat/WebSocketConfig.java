package com.edu.springboot.chat;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

//웹 소켓 연결 설정
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer{
	
	@Override
	public void configureMessageBroker(MessageBrokerRegistry config) {
		// /topic 이 붙은 목적지를 구독하는 클라이언트에게 메세지 전달
        config.enableSimpleBroker("/topic");
        // 클라이언트가 메세지를 보낼때 목적지의 접두사
        config.setApplicationDestinationPrefixes("/app");
	}
	
	//stomp 엔드포인트 등록.
	@Override
	public void registerStompEndpoints(StompEndpointRegistry registry) {
		//myChatServer를 엔드포인트로 설정 및 연결 시작
		registry.addEndpoint("/myChatServer").withSockJS();
	}
}
