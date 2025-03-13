package com.sp.app.admin.controller;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sp.app.common.MyUtil;
import com.sp.app.common.PaginateUtil;
import com.sp.app.model.Member;
import com.sp.app.service.MemberManageService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/admin/memberManage/*")
public class MemberManageController {

	private final MemberManageService service;
	private final PaginateUtil paginateUtil;
	private final MyUtil myUtil;
	
	@GetMapping("main")
	public String memberManage(Model model, @RequestParam(name="page", defaultValue = "1") int current_page,
			@RequestParam(name = "schType", defaultValue = "all") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			@RequestParam(name = "role", defaultValue = "all") String role,
			HttpServletRequest req, HttpSession session) throws Exception{
		try {
			int size = 10;
			int total_page = 0;
			int dataCount = 0;
			
		
			
			kwd = URLDecoder.decode(kwd, "utf-8");
			
			Map<String, Object> map = new HashMap<>();
			map.put("schType", schType);
			map.put("kwd", kwd);
			
			// 역할 필터링 조건 추가
			if(! role.equals("all")) {
				map.put("role", role);
			}
			
			dataCount = service.dataCount(map);
			total_page = paginateUtil.pageCount(dataCount, size);
			
			current_page = Math.min(current_page, total_page);
			
			int offset = (current_page -1) * size;
			if(offset < 0) offset = 0;
			
			map.put("offset", offset);
			map.put("size", size);
		
			//회원 목록 조회
			List<Member> memberList = service.listMembers(map);
			
			String cp = req.getContextPath();
			String query = "page=" + current_page;
			String listUrl = cp + "/admin/memberManage/main";
			
			//쿼리 문자열 생성
			List<String> queryParams = new ArrayList<>();
					
			if(! kwd.isBlank()) {
				 queryParams.add("schType=" + schType + "&kwd=" + URLEncoder.encode(kwd, "utf-8"));
				
			}
			if(!role.equals("all")) {
				queryParams.add("role=" + role);
			}
			
			if(!queryParams.isEmpty()) {
				listUrl += "?" + String.join("&", queryParams);
				query += "&" + String.join("&", queryParams);
			}
			
			
			String paging = paginateUtil.paging(current_page, total_page, listUrl);
	
			model.addAttribute("memberList", memberList);
			model.addAttribute("dataCount", dataCount);

			model.addAttribute("size", size);
			model.addAttribute("page", current_page);
			model.addAttribute("total_page", total_page);
			model.addAttribute("query", query);
			model.addAttribute("paging", paging);
			
			model.addAttribute("schType", schType);
			model.addAttribute("kwd", kwd);		
			model.addAttribute("role", role); //현재 선택된 역할을 뷰에 전달 
		} catch (Exception e) {
			log.info("list : ", e);
		}
		
		return "admin/memberManage/main";
		
	}
	
	@PostMapping("/updateMemberAuthority")
	public String updateMemberAuthority(@RequestParam Map<String, Object> map) {
		try {
			int result = service.updateMemberAuthority(map);
			
		} catch (Exception e) {
			log.error("회원 활성화 상태 업데이트 오류 : ", e);
		}
		return "redirect:/admin/memberManage/main";
	}
}
