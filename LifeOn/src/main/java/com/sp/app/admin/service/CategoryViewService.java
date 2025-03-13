package com.sp.app.admin.service;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Service;

@Service
public class CategoryViewService {
	private final Map<String, Integer> categoryViewCount = new ConcurrentHashMap<>();
	
	
	//조회수 증가 메서드
	public void increaseViewCount(String category) {
		categoryViewCount.merge(category, 1, Integer::sum);
		System.out.println("📌 조회수 증가: " + category + " → " + categoryViewCount.get(category));
	}
	
	//조회수 반환
	public Map<String, Integer> getCategoryViewCounts(){
		return categoryViewCount;
	}
}
