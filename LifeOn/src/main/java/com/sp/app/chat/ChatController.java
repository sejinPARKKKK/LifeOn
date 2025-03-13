package com.sp.app.chat;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/chat/*")
public class ChatController {
	@GetMapping("main")
	public String handle(HttpServletRequest req, Model model) {
		
		String cp = req.getContextPath();
		
		//서버 IP 주소 가져오기
		String serverName = req.getServerName();
		int serverPort = req.getServerPort();
		
		//websocket URL 생성
		String url = String.format("ws://%s:%d%s/chat.msg", serverName, serverPort, cp);
		
		log.info("WebSocket URL : " + url);
		
		model.addAttribute("wsURL", url);
	
		return "chat/main";
		
	}
}
