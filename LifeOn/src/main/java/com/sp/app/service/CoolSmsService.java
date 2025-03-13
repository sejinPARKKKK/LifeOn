package com.sp.app.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.response.SingleMessageSentResponse;
import net.nurigo.sdk.message.service.DefaultMessageService;

@Service
public class CoolSmsService {
	private final DefaultMessageService messageService; 
	
	@Value("${coolsms.sender}")
	private String senderNumber;
	
	public CoolSmsService(@Value("${coolsms.api-key}") String apiKey,
	            @Value("${coolsms.api-secret}") String apiSecret) {
		this.messageService = NurigoApp.INSTANCE.initialize(apiKey, apiSecret, "https://api.coolsms.co.kr");
	}
	
	public void sendSms(String phone, String text) {
		Message message = new Message();
		message.setFrom(senderNumber);
		message.setTo(phone);
		message.setText(text);
		
		try {
			SingleMessageSentResponse response =  this.messageService.sendOne(new SingleMessageSendingRequest(message));
			System.out.println("CoolSMS 응답: " + response);
		} catch (Exception e) {
			System.out.println("CoolSMS 전송 실패: " + e.getMessage());
			// 예외 처리 로직
		}	
	}
	
}
