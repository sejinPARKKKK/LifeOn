package com.sp.app.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sp.app.admin.service.VisitorCounter;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
public class HomeManageController {
    @GetMapping("/admin")
    public String handleHome() {
        return "admin/main/home";
    }

    @GetMapping("/admin/main/home")
    public String showAdminHome(Model model) {
    	int totalVisitors = VisitorCounter.getTotalVisitorCount();
        int todayVisitors = VisitorCounter.getTodayVisitorCount();
        
        log.info("🚀 전달할 방문자 데이터: totalVisitors={}, todayVisitors={}", totalVisitors, todayVisitors);
    	
    	model.addAttribute("totalVisitors", VisitorCounter.getTotalVisitorCount()); // ✅ 누적 방문자
        model.addAttribute("todayVisitors", VisitorCounter.getTodayVisitorCount()); // ✅ 오늘 방문자
        return "admin/main/home";
    }


    // ✅ 비동기 요청을 처리하는 API 추가
    @GetMapping("/admin/main/totalVisitors")
    @ResponseBody
    public int getTotalVisitors() {
        return VisitorCounter.getTotalVisitorCount();
    }

    @GetMapping("/admin/main/todayVisitors")
    @ResponseBody
    public int getTodayVisitors() {
        return VisitorCounter.getTodayVisitorCount();
    }
}
