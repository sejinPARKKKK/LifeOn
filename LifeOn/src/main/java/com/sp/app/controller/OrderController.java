package com.sp.app.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sp.app.admin.model.ProductManage;
import com.sp.app.admin.service.ProductManageService;
import com.sp.app.common.PaginateUtil;
import com.sp.app.model.Member;
import com.sp.app.model.Order;
import com.sp.app.model.SessionInfo;
import com.sp.app.service.MemberService;
import com.sp.app.service.OrderService;
import com.sp.app.service.PointRecordService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping(value = "/market/order/*")
public class OrderController {
	private final MemberService memberService;
	private final ProductManageService productService;
	private final OrderService orderService;
	private final PointRecordService pService;
	private final PaginateUtil paginateUtil;
	
	@GetMapping("payment")
	public String paymentForm(@RequestParam(name = "pnum") long pnum,
			HttpSession session,
			Model model) {
		
		SessionInfo info = (SessionInfo) session.getAttribute("member");
		
		try {
			Member dto1 = Objects.requireNonNull(memberService.findById(info.getId()));
			
			ProductManage dto2 = Objects.requireNonNull(productService.findByPnum(pnum));
			
			model.addAttribute("dto1", dto1);
			model.addAttribute("dto2", dto2);
			
		} catch (Exception e) {
			log.info("paymentForm : ", e);
		}
		
		return "market/order/payment";
	}
	
	
	@PostMapping("payment")
	public String paymentSubmit(Order dto,
			final RedirectAttributes reAttr,
			Model model,
			HttpSession session) {
		
		try {
			//주문들어와서 보유포인트보다 많게 주문할시 새로운창으로
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			int totalPoint = 0;
			totalPoint = pService.totalPoint(info.getNum());
			
			StringBuilder sb = new StringBuilder();
			if(dto.getOp()>totalPoint) {
				sb.append("포인트가 부족합니다.<br>");
				sb.append("결제를 실패했습니다.");
				reAttr.addFlashAttribute("message", sb.toString());
				reAttr.addFlashAttribute("title", "주문실패");
				return "redirect:/member/complete";
			}
			
			orderService.insertOrder(dto);
			
			sb.append("주문이 성공적으로 이루어졌습니다.<br>");
			sb.append("축하합니다.<br>");
			
			reAttr.addFlashAttribute("message", sb.toString());
			reAttr.addFlashAttribute("title", "주문성공");

			return "redirect:/member/complete";	
			
			
		} catch (Exception e) {
			log.info("payment : ", e);
		}
		
		
		return "market/order/payment";
	}
	
	@GetMapping("list")
	public String orderList(@RequestParam(name = "page", defaultValue = "1") int current_page,
			Model model,
			HttpSession session,
			HttpServletRequest req) {
		
		
		try {
			int size = 10;
			int dataCount = 0;
			int total_page = 0;
			Map<String, Object> map = new HashMap<>();
			
			SessionInfo member = (SessionInfo) session.getAttribute("member");
			map.put("num", member.getNum());
			
			dataCount = orderService.dataCount(map);
			total_page = paginateUtil.pageCount(dataCount, size);
			current_page = Math.min(current_page, total_page);
			
			int offset = (current_page - 1) * size;
			if(offset < 0) offset = 0;
			
			map.put("offset", offset);
			map.put("size", size);
			
			String cp = req.getContextPath();
			String listUrl = cp + "/market/order/list";
			String query = "page=" + current_page;
			
			List<Order> list = orderService.listOrder(map);
			String paging = paginateUtil.paging(current_page, total_page, listUrl);
			
			model.addAttribute("list", list);
			model.addAttribute("dataCount", dataCount);
			model.addAttribute("size", size);
			model.addAttribute("page", current_page);
			model.addAttribute("total_page", total_page);
			model.addAttribute("paging", paging);
			
			model.addAttribute("query", query);
			
		} catch (Exception e) {
			log.info("list : ", e);
		}
		
		
		
		return "mypage/order/list";
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
