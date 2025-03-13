package com.sp.app.admin.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sp.app.admin.service.CategoryViewService;
import com.sp.app.admin.service.VisitorLogService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin/main/*")
@RequiredArgsConstructor
public class VisitorLogController {
	private final VisitorLogService visitorLogService;
	private final CategoryViewService categoryViewService;
		
	@GetMapping("/totalMembers")
	@ResponseBody
	public int getTotalMembers() {
		return visitorLogService.countTotalMembers();
	}
	
	@GetMapping("/todayNewMembers")
	@ResponseBody
	public int getTodayNewMembers() {
		return visitorLogService.countTodayNewMembers();
	}
	
	@GetMapping("/memberAgeDistribution")
	@ResponseBody
	public List<Map<String, Object>> MemberAgeDistribution() {
		return visitorLogService.MemberAgeDistribution();
	}
	
	@GetMapping("/genderRatio")
	@ResponseBody
	public List<Map<String, Object>> getGenderRatio() {
		List<Map<String, Object>> result = visitorLogService.getGenderRatio();

        // 📌 로그 확인 (JSON 데이터 올바르게 오는지 체크)
        System.out.println("📌 남녀 성비 데이터 반환: " + result);

        return result;
	}
	

	// 카테고리별 조회수 반환 API
	@GetMapping("/viewCounts") 
	@ResponseBody
	public Map<String, Integer> getViewCounts() {
		return categoryViewService.getCategoryViewCounts();
	}
	
}
