package com.sp.app.chat;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

/*
 * 1) client -> server  type
 * connect : 처음 접속한 경우 - uid, nickName
 * message : 채팅 메세지 전송 - chatMsg
 * whisper : 귓속말 - receiver, chatMsg
 * 
 * 2) server -> client : type
 *  userList : 처음 접속한 경우 접속한 사용자 리스트 전송 - users(배열)
 *  userConnect : 다른 접속자에게 지금 접속한 유저 전송 - uid, nickName
 *  message : 채팅 메시지 - uid, nickName, chatMsg
 *  whisper : 귓속말 - uid, nickName, chatMsg
 *  userDisconnect : 접속한 사용자들에게 접속 해제한 유저 전송 = uid, nickName 
 	- Jackson 라이브러리
    : Java 에서 JSON 데이터를 처리하는 라이브러리
    : Spring Boot 에는 기본적으로 Jackson 라이브러리가 내장
    - ObjectMapper
    : Jackson의 핵심 클래스
    : JSON 을 java 객체로 변환하거나, Java 객체를 JSON 문자열로 변환하는데 사용
  - JsonNode 
    : JSON 데이터를 트리 구조로 다룰 수 있는 객체
    : 이를 통해 JSON 데이터를 동적으로 처리 
 */

@Slf4j
@Service
public class MySocketHandler extends TextWebSocketHandler {
	private Map<String, User> connectUsers = new Hashtable<>();

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		super.afterConnectionEstablished(session);
			
		// WebSocket이 연결되고 사용이 준비될 때 호출
	}

	@Override
	public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) throws Exception {
		super.handleMessage(session, message);
	
		// 클라이언트로부터 메세지가 도착했을 때 호출
		ObjectMapper mapper = new ObjectMapper();
		JsonNode jsonReceive = null;
		
		try {
			jsonReceive = mapper.readTree(message.getPayload().toString());
		} catch (Exception e) {
			return;
		}
		
		String type = jsonReceive.get("type").asText().trim();
		if(type == null || type.isBlank()) {
			log.info("type error...");
			return;
		}
		
		try {
			if(type.equals("connect")) {
				//처음 접속 사실을 받은 경우
				
				//접속한 사용자 아이디를 키로 session과 유저의 정보를 저장
				String uid = jsonReceive.get("uid").asText().trim();
				String nickName = jsonReceive.get("nickName").asText().trim();
				
				User user = User.builder()
						.uid(uid)
						.nickName(nickName)
						.session(session)
						.build();
				
				connectUsers.put(uid, user);
				
				//처음 접속한 유저에게 현재 접속중이 다른 유저 전송
				Iterator<String> it = connectUsers.keySet().iterator();
				List<List<Object>> arrUsers = new ArrayList<>();
				while(it.hasNext()) {
					String key = it.next();
					if(uid.equals(key)) {
						continue;
					}
					
					User vo = connectUsers.get(key);
					
					List<Object> list = Arrays.asList(vo.getUid(), vo.getNickName());
					arrUsers.add(list);
				}
				Map<String, Object> connectList = new HashMap<>();
				connectList.put("type", "userList");
				connectList.put("users", arrUsers);
				
				sendTextMessageToOne(mapToString(connectList), session);
			
				// 다른 접속 유저에게 접속 자실을 알림
				Map<String, Object> connectUser = new HashMap<>();
				connectUser.put("type", "userConnect");
				connectUser.put("uid", uid);
				connectUser.put("nickName", nickName);
				
				sendTextMessageToAll(mapToString(connectUser), uid);
				
			} else if(type.equals("message")) {
				// 채팅 문자열을 전송 받은 경우
				User user = getUser(session);
				String msg = jsonReceive.get("chatMsg").asText();
				
				Map<String, Object> map = new HashMap<>();
				map.put("type", "message");
				map.put("chatMsg", msg);
				map.put("uid", user.getUid());
				map.put("nickName", user.getNickName());
				
				sendTextMessageToAll(mapToString(map), user.getUid());
			} else if(type.equals("whisper")) {
				// 귓속말을 전송 받은 경우
				User user = getUser(session);
				String msg = jsonReceive.get("chatMsg").asText();
				String receiver = jsonReceive.get("receiver").asText();
				
				User receiverUser = connectUsers.get(receiver);
				if(receiverUser == null) {
					return;
				}
				
				Map<String, Object> map = new HashMap<>();
				map.put("type", "whisper");
				map.put("chatMsg", msg);
				map.put("uid", user.getUid());
				map.put("nickName", user.getNickName());
				
				sendTextMessageToOne(mapToString(map), receiverUser.getSession());
			}
			
		} catch (Exception e) {
			log.info("handleMessage : ", e);
		}
	}
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		super.afterConnectionClosed(session, status);
		
		// WebSocket 연결이 닫힌 경우 호출
		String uid = removeUser(session);
		
		log.info("remove session : " + uid);
	}
	
	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		super.handleTransportError(session, exception);
		
		// 에러가 발생한 경우
		removeUser(session);
	}
	
	protected void sendTextMessageToOne(String message, WebSocketSession session) {
		// 특정 유저에세 메시지 전송
		try {
			if(session.isOpen()) {
				session.sendMessage(new TextMessage(message));
			}
		} catch (Exception e) {
			// 예외가 발생하면 유저 삭제
			removeUser(session);
		}
	}
	
	// 접속된 모든 사용자에게 메시지 전송
		protected void sendTextMessageToAll(String message, String exclude) {
			Iterator<String> it = connectUsers.keySet().iterator();
			
			while(it.hasNext()) {
				String key = it.next();
				if(exclude != null && exclude.equals(key)) { // 제외할 사람
					continue;
				}
				
				User user = connectUsers.get(key);
				WebSocketSession session = user.getSession();
				
				try {
					if(session.isOpen()) {
						session.sendMessage(new TextMessage(message));
					}
				} catch (Exception e) {
					// 예외가 발생하면 유저 삭제
					removeUser(session);
				}
			}
		}
	
		protected User getUser(WebSocketSession session) {
			// session 에 대한 접속 유저의 정보 반환
			Iterator<String> it = connectUsers.keySet().iterator();
			
			while(it.hasNext()) {
				String key = it.next();
				
				User vo = connectUsers.get(key);
				if(vo.getSession() == session) {
					return vo;
				}
			}
			
			return null;
		}	
		
	protected String removeUser(WebSocketSession session) {
		// session 에 대한 유저 정보 삭제(채팅방을 나간 유저 삭제)
		User user = getUser(session);
		
		if(user == null) {
			return null;
		}
		
		try {
			// 다른 클라이언트에게 접속 해제 사실을 알림
			Map<String, Object> model = new HashMap<>();
			model.put("type", "userDisconnect");
			model.put("uid", user.getUid());
			model.put("nickName", user.getNickName());
			
			sendTextMessageToAll(mapToString(model), user.getUid());
			
		} catch (Exception e) {
			log.info("removeUser : ", e);
		} finally {
			try {
				user.getSession().close();
			} catch (Exception e2) {
			}
		}
		
		connectUsers.remove(user.getUid()); // Map에 저장된 정보 삭제
		
		return user.getUid();
	}
	
	// Map을 JSON 문자열로 반환
		protected String mapToString(Map<String, Object> map) throws Exception {
			ObjectMapper mapper = new ObjectMapper();
			
			// Map을 JSON 문자열로 반환
			return mapper.writeValueAsString(map);
		}
}
