package com.edu.springboot.chat;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Controller
public class ChatbotController {
	
	private final ChatService chatService;

	// 클라이언트가 입력한 메세지 서버로 전달
    @MessageMapping("/chat.sendMessage")
    public void sendMessage(@Payload ChatRequest.ChatMessageDTO chatMessage) {
        chatService.processMessage(chatMessage);
    }
	// 클라이언트 정보 저장
    @MessageMapping("/chat.addUser")
    public void addUser(@Payload ChatRequest.ChatMessageDTO chatMessage, 
    		SimpMessageHeaderAccessor headerAccessor) {
        headerAccessor.getSessionAttributes().put("username", chatMessage.getSender());
    }
    
    @GetMapping("/chat/chatbot.do")
    public String chatbot(){
    	return "chat/chatbot";
    }

    @GetMapping("/chat/chatstart.do")
    public String chatPage(){
    	return "chat/chatstart";
    }
}
