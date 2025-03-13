package com.sp.app.admin.controller;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sp.app.admin.service.CategoryViewService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/layout")
@RequiredArgsConstructor
public class IncreView {
	private final CategoryViewService categoryViewService;
	
	// 조회수 증가 API
	@PostMapping("/{category}")
	public void increaseView(@PathVariable("category") String category) {
		  categoryViewService.increaseViewCount(category);

	}
}
