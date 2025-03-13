package com.sp.app.admin.model;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class VisitorLog {
	private Long id; // 방문 로그 ID
	private LocalDateTime visitDate; // 방문시간
	private String sessionId; // 세션ID
}
