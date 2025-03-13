package com.sp.app.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sp.app.admin.model.Report;
import com.sp.app.admin.service.ReportService;
import com.sp.app.common.PaginateUtil;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/admin/complaintManage/*")
public class ComplaintManageController {
	private final PaginateUtil paginateUtil;
	private final ReportService service;
	
	@GetMapping("list")
	public String complaintManage(@RequestParam(name="page", defaultValue = "1") int current_page,
			Model model, HttpServletRequest req) throws Exception {
		try {
			int size = 10;
			int total_page = 0;
			int dataCount = 0;
			
			Map<String, Object> map = new HashMap<>();
			dataCount = service.dataCount(map);
			if(dataCount != 0) {
				total_page = paginateUtil.pageCount(dataCount, size);
			}
			
			current_page = Math.min(current_page, total_page);
			
			//리스트에 출력할 데이터 가져오기
			int offset = (current_page -1) * size;
			if(offset < 0) offset = 0;
			
			map.put("offset", offset);
			map.put("size", size);
			
			//리포트 리스트
			List<Report> list = service.listReport(map);
			String paging = paginateUtil.paging(current_page, total_page, "listReport");
			String repsucees = "";
			String repsucboolean = "";
			
			model.addAttribute("list", list);
			model.addAttribute("repsucees", repsucees);
			model.addAttribute("repsucboolean", repsucboolean);
			model.addAttribute("page", current_page);
			model.addAttribute("dataCount", dataCount);
			model.addAttribute("total_page", total_page);
			model.addAttribute("paging", paging);
			
		} catch (Exception e) {
			log.info("list", e);
		}	
		return "admin/complaintManage/list";
	}
	
	@GetMapping("reportDetail")
	@ResponseBody
	public Map<String, Object> getReportDetail(@RequestParam(name="repan") Long repan) {
		
		Map<String, Object> reportDetail = service.getReportDetail(repan);
		
		try {
			if(reportDetail == null) {
				reportDetail = new HashMap<>();
				reportDetail.put("title", "제목 없음");
				reportDetail.put("author", "익명");
				reportDetail.put("content", "내용 없음");
			}			
		} catch (Exception e) {
		}


		return reportDetail;
	}
	
	
	@GetMapping("delete")
	@ResponseBody
	public Map<String, Object> deletePost(@RequestParam(name="psnum") Long psnum) throws Exception {
		Map<String, Object> map = new HashMap<>();
		
		try {
			int result = service.deletePost(psnum);
			if (result > 0) {
				map.put("success", true);
				map.put("message", "게시글이 삭제되었습니다.");
			} else {
				map.put("success", false);
				map.put("message", "게시글이 존재하지 않거나 이미삭제되었습니다.");
			}
		} catch (Exception e) {
			log.info("게시글 삭제중 오류 발생", e);
		}
		
		
		
		return map;
	}
	
	
	@PostMapping("updateStatus")
	@ResponseBody
	public Map<String, Object> updateStatus(@RequestBody Map<String, Object> requestData) {
		Map<String, Object> response = new HashMap<>();
		
		try {
			//요청 데이터 추출
			String repan = (String) requestData.get("repan");
			String repsucboolean = (String) requestData.get("repsucboolean"); //처리여부
			String repsucees = (String) requestData.get("repsucees"); //처리일
			
			// 상태 업데이트 실행
			boolean updateSuccess = service.updateStatus(repan, repsucboolean, repsucees);
			
			// 응답 데이터 구성
			if(updateSuccess) {
				response.put("success", true);
				response.put("message", "상태가 성공적으로 업데이트 되었습니다.");
			} else {
				response.put("success", false);
				response.put("message", "상태 업데이트에 실패했습니다.");
				
			}
		} catch (Exception e) {
	        e.printStackTrace(); // 서버 콘솔에 오류 출력
	        response.put("success", false);
	        response.put("message", "서버 오류가 발생했습니다.");
		}
		
		return response;
	}
	
	
	
	
}
