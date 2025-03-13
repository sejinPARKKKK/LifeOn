package com.sp.app.admin.service;

import java.time.LocalDate;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;
import lombok.extern.slf4j.Slf4j;


@WebListener
@Slf4j
public class VisitorCounter implements HttpSessionListener {

	private final static AtomicInteger totalVisitors = new AtomicInteger(0); // ✅ 전체 방문자 수
	private final static AtomicInteger activeVisitors = new AtomicInteger(0); // ✅ 현재 활성 세션 수
	private final static Map<LocalDate, Set<String>> dailyVisitors = new ConcurrentHashMap<>(); // ✅ 오늘 방문자 저장 (중복 방지)

	 @Override
	    public void sessionCreated(HttpSessionEvent event) {
	        HttpSession session = event.getSession();
	        String sessionId = session.getId();
	        log.info("📌 Session Created: {}", sessionId);

	        // ✅ 현재 활성 세션 증가
	        activeVisitors.incrementAndGet();

	        // ✅ 첫 방문 여부 확인
	        if (session.getAttribute("COUNTED") == null) {
	            session.setAttribute("COUNTED", true);
	            totalVisitors.incrementAndGet();
	        }

	        // ✅ 오늘 날짜 기준 방문자 추가
	        LocalDate today = LocalDate.now();
	        dailyVisitors.computeIfAbsent(today, k -> ConcurrentHashMap.newKeySet()).add(sessionId);

	        // ✅ 오래된 데이터 정리 (30일 이상 지난 데이터 삭제)
	        cleanupOldDate();
	    }

	    @Override
	    public void sessionDestroyed(HttpSessionEvent event) {
	        activeVisitors.decrementAndGet(); // ✅ 세션이 종료되면 활성 세션 감소
	    }

	    private void cleanupOldDate() {
	        LocalDate thirtyDaysAgo = LocalDate.now().minusDays(30);
	        dailyVisitors.keySet().removeIf(date -> date.isBefore(thirtyDaysAgo));
	    }

	    // ✅ 전체 방문자 수 반환
	    public static int getTotalVisitorCount() {
	        return totalVisitors.get();
	    }

	    // ✅ 오늘 방문자 수 반환
	    public static int getTodayVisitorCount() {
	        LocalDate today = LocalDate.now();
	        Set<String> visitors = dailyVisitors.get(today);
	        return visitors != null ? visitors.size() : 0;
	    }

	    // ✅ 현재 활성 방문자 수 반환
	    public static int getActiveVisitorCount() {
	        return activeVisitors.get();
	    }
	
}
