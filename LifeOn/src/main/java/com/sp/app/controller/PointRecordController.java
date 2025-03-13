package com.sp.app.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sp.app.common.PaginateUtil;
import com.sp.app.model.Member;
import com.sp.app.model.PointRecord;
import com.sp.app.model.SessionInfo;
import com.sp.app.service.MemberService;
import com.sp.app.service.PointRecordService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/point/*")
public class PointRecordController {
	private final PointRecordService service;
	private final PaginateUtil paginateUtil;
	private final MemberService mservice;
	
	@GetMapping("mypage")
	public String handlePoint(@RequestParam(name = "page", defaultValue = "1") int current_page,
			@RequestParam(name = "schType", defaultValue = "all") String schType,
			Model model,
			HttpSession session,
			HttpServletRequest req) throws Exception {
		
		try {
			int size = 10;
			int total_page = 0;
			int dataCount = 0;
			int totalPoint = 0;
			Map<String, Object> map = new HashMap<>();
			map.put("schType", schType);
			
			SessionInfo member = (SessionInfo) session.getAttribute("member");
			map.put("num", member.getNum());
			
			//회원정보 가져오자
			Member dto = mservice.findById(member.getId());
			
			model.addAttribute("dto2", dto);
			
			
			totalPoint = service.totalPoint(member.getNum());
			dataCount = service.dataCount(map);
			total_page = paginateUtil.pageCount(dataCount, size);
			current_page = Math.min(current_page, total_page);
			
			
			int offset = (current_page - 1) * size;
			if(offset < 0) offset = 0;
			
			map.put("offset", offset);
			map.put("size", size);
			
			String cp = req.getContextPath();
			String listUrl = cp + "/point/mypage";
			String query = "page=" + current_page;
			
			if(schType.length() != 0) {
				String qs = "schType=" + schType;
				listUrl += "?" +qs;
				query += "&" + qs;
			}
			
			List<PointRecord> list = service.listPoint(map); 
			String paging = paginateUtil.paging(current_page, total_page, listUrl);
			
			model.addAttribute("totalPoint", totalPoint);
			
			model.addAttribute("list", list);
			model.addAttribute("dataCount", dataCount);
			model.addAttribute("size", size);
			model.addAttribute("page", current_page);
			model.addAttribute("total_page", total_page);
			model.addAttribute("paging", paging);
			
			model.addAttribute("schType", schType);
			model.addAttribute("query", query);
			
		} catch (Exception e) {
			log.info("mypage : ", e);
		}
		
		
		
		return "mypage/home";
	}
	
	@PostMapping("charge")
	public String charge(@RequestParam Map<String, Object> paramMap,
			HttpSession session) {
		try {
			int totalPoint = 0;
			SessionInfo member = (SessionInfo) session.getAttribute("member");
			paramMap.put("num", member.getNum());
			
			totalPoint = service.totalPoint(member.getNum());
			paramMap.put("totalPoint", totalPoint);
			
			service.insertChargeAndCard(paramMap);
			
		} catch (Exception e) {
			log.info("charge : ", e);
		}
		
		return "redirect:/point/mypage";
	}
	
	
	
}
