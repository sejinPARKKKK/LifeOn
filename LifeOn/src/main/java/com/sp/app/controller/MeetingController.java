package com.sp.app.controller;

import java.math.BigDecimal;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sp.app.common.MyUtil;
import com.sp.app.common.PaginateUtil;
import com.sp.app.common.StorageService;
import com.sp.app.model.Meeting;
import com.sp.app.model.SessionInfo;
import com.sp.app.service.MeetingService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping(value = "/city/meeting/*")
public class MeetingController {
	private final MeetingService service;
	private final StorageService storageService;
	private final PaginateUtil paginateUtil;
	private final MyUtil myUtil;
	
	@GetMapping("main")
	public String MeetingList(
			@RequestParam(name = "cbn", defaultValue = "0") long categoryNum,
			@RequestParam(name = "page", defaultValue = "1") int current_page,
			@RequestParam(name = "schType", defaultValue = "all") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			Model model,
			HttpServletRequest req) throws Exception {
		
		try {
			int size = 15;
			int total_page = 0;
			int dataCount = 0;
			
			kwd = URLDecoder.decode(kwd, "utf-8");
			
			List<Meeting> listCategory = service.listCategory(); 
			
			
			Map<String, Object> map = new HashMap<>();
			map.put("cbn", categoryNum);
			map.put("schType", schType);
			map.put("kwd", kwd);
			
			dataCount = service.dataCount(map);
			if (dataCount != 0) {
				total_page = paginateUtil.pageCount(dataCount, size);
			}
			
			total_page = paginateUtil.pageCount(dataCount, size);
			current_page = Math.min(current_page, total_page);
			
			int offset = (current_page - 1) * size;
			if (offset < 0) offset = 0;
			
			map.put("offset", offset);
			map.put("size", size);
			
			List<Meeting> list = service.listBoard(map);
			
			String cp = req.getContextPath();
			
			String listUrl = cp + "/city/meeting/main";
			String articleUrl = cp + "/city/meeting/article";
			
			String query = "page=" + current_page;
			
			if (! kwd.isBlank()) {
				 String qs = "schType=" + schType + "&kwd=" + URLEncoder.encode(kwd, "utf-8");
				
				listUrl += "?" + qs;
				query += "&" + qs;
			}
			
			String paging = paginateUtil.paging(current_page, total_page, listUrl);
			
			model.addAttribute("listCategory", listCategory);
			model.addAttribute("list", list);
			model.addAttribute("dataCount", dataCount);
			model.addAttribute("size", size);
			
			model.addAttribute("page", current_page);
			model.addAttribute("total_page", total_page);
			model.addAttribute("articleUrl", articleUrl);
			model.addAttribute("paging", paging);
			
			model.addAttribute("cbn", categoryNum);
			model.addAttribute("query", query);
			
			model.addAttribute("schType", schType);
			model.addAttribute("kwd", kwd);
			
		} catch (Exception e) {
			log.info("MeetingList : ", e);
		}
		
		return "city/meeting/main";
	}
	
	@GetMapping("write")
	public String writeForm(Model model) throws Exception {
		
		List<Meeting> Category = service.listCategory();
		
		model.addAttribute("mode", "write");
		model.addAttribute("Category", Category);
		
		return "city/meeting/write";
	}
	
	@PostMapping("write")
	public String writeSubmit(Meeting dto, Model model,
			HttpSession session,HttpServletRequest req) throws Exception {
		
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			dto.setNum(info.getNum());
			dto.setNickname(info.getNickName());
			dto.setIdaddr(req.getRemoteAddr());
			dto.setPsnum(dto.getPsnum());
			
			service.insertBoard(dto);
			
		} catch (Exception e) {
			log.info("writeSubmit : ", e);
		}
		
		return "redirect:/city/meeting/main";
	}
	
	@GetMapping("article/{psnum}")
	public String article(
			@PathVariable(name = "psnum") long num,
			@RequestParam(name = "page") String page,
			@RequestParam(name = "schType", defaultValue = "all") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			Model model,
			HttpSession session) throws Exception {
		
		String query = "page=" + page;
		
		try {
			kwd = URLDecoder.decode(kwd, "utf-8");
			if (! kwd.isBlank()) {
				query += "&schType=" + schType + "&kwd=" + URLEncoder.encode(kwd, "utf-8");
			}
			
			service.updateHitCount(num);
			
			Meeting dto = Objects.requireNonNull(service.findById(num));
			
			dto.setContent(myUtil.htmlSymbols(dto.getContent()));
			
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			Map<String, Object> map = new HashMap<>();
			map.put("schType", schType);
			map.put("kwd", kwd);
			map.put("psnum", num);
			map.put("num", info.getNum());
			
			// RentProduct prevDto = service.findByPrev(map);
			// RentProduct nextDto = service.findByNext(map);
			
			boolean isMemberLiked = service.memberBoardLiked(map);
			
			model.addAttribute("psnum", num);
			model.addAttribute("dto", dto);
			//model.addAttribute("prevDto", prevDto);
			//model.addAttribute("nextDto", nextDto)
			model.addAttribute("isMemberLiked", isMemberLiked);
			model.addAttribute("query", query);
			model.addAttribute("page", page);
			
			return "city/meeting/article";
			
		} catch (NullPointerException e) {
		} catch (Exception e) {
			log.info("article : ", e);
		}
		
		return "redirect:/city/meeting/main?" + query;
	}
	
	@GetMapping("update")
	public String updateForm(
			@RequestParam(name = "psnum") long num,
			@RequestParam(name = "page") String page,
			Model model,
			HttpSession session) throws Exception {
			
			List<Meeting> Category = service.listCategory();
			
			model.addAttribute("Category", Category);
		
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			Meeting dto = Objects.requireNonNull(service.findById(num));
			
			if (! info.getNickName().equals(dto.getNickname())) {
				return "redirect:/city/meeting?page=" + page;
			}	
				
			model.addAttribute("dto", dto);
			model.addAttribute("page", page);
			model.addAttribute("mode", "update");
			
			return "city/meeting/write";
			
		} catch (NullPointerException e) {
		} catch (Exception e) {
			log.info("updateForm : ", e);
		}
		
		return "redirect:/city/meeting/main?page=" + page;
	}
	
	@PostMapping("update")
	public String updateSubmit(
			Meeting dto, @RequestParam(name = "page") String page,
			@RequestParam(name = "psnum") long psnum,
			HttpSession session) throws Exception {
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			dto.setNum(info.getNum());
			dto.setNickname(info.getNickName());
			dto.setPsnum(psnum);
			
			service.updateBoard(dto);
			
		} catch (Exception e) {
			log.info("updateSubmit : ", e);
		}
		return "redirect:/city/meeting/article/" + psnum + "?page=" + page;
	}
	
	@GetMapping("delete")
	public String deleteBoard(@RequestParam(name = "psnum") long num,
			@RequestParam(name = "schType", defaultValue = "all") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			@RequestParam(name = "page") String page,
			HttpSession session) {
		
		String query = "page=" + page;
		
		try {
			kwd = URLDecoder.decode(kwd, "utf-8");
			if (! kwd.isBlank()) {
				query += "&schType=" + schType + "&kwd=" + URLEncoder.encode(kwd, "utf-8");
			}
			
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			service.deleteBoard(num, info.getNickName(), info.getGrade());
			
		} catch (Exception e) {
			log.info("deleteBoard : ", e);
		}
		
		return "redirect:/city/meeting?" + query;
	}
	
	@ResponseBody
	@PostMapping("boardLike")
	public Map<String, ?> boardLike(
			@RequestParam(name = "psnum") long num,
			@RequestParam(name = "memberLiked") boolean memberLiked,
			HttpSession session) {
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		int boardLikeCount = 0;
		
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			Map<String, Object> map = new HashMap<>();
			map.put("psnum", num);
			map.put("num", info.getNum());
			map.put("nickname", info.getNickName());
			
			if (memberLiked) {
				service.deleteBoardLike(map);
			} else {
				service.boardLike(map); 
			}
			
			boardLikeCount = service.boardLikeCount(num);
			
		} catch (DuplicateKeyException e) {
			state ="liked";
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("state", state);
		model.put("boardLikeCount", boardLikeCount);
		
		return model;
	}
	
	@PostMapping("reply")
	@ResponseBody
	public Map<String, Object> reply(Meeting dto, HttpSession session) {
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			dto.setNum(info.getNum());
			dto.setPsnum(dto.getPsnum());
			service.reply(dto);
			
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("state", state);
		
		return model;
	}
		
	@GetMapping("listReply")
	public String listReply(Meeting dto, @RequestParam(name = "rpnum") long num,
			@RequestParam(name = "pageNo", defaultValue = "1") int current_page,
			Model model,
			HttpServletResponse resp,
			HttpSession session) throws Exception {
		
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			int size = 5;
			int total_page = 0;
			int dataCount = 0;
			
			Map<String, Object> map = new HashMap<>();
			map.put("rpnum", num);
			map.put("psnum", dto.getPsnum());
			map.put("rplike", dto.getRplike());
			map.put("num", info.getNum());
			map.put("nickname", info.getNickName());
			
			dataCount = service.replyCount(map);
			total_page = paginateUtil.pageCount(dataCount, size);
			current_page = Math.min(current_page, total_page);
			
			int offset = (current_page - 1) * size;
			if (offset < 0) offset = 0;
			
			map.put("offset", offset);
			map.put("size", size);
			
			List<Meeting> listReply = service.listReply(map);
			
			String paging = paginateUtil.pagingMethod(current_page, total_page, "listPage");
			
			model.addAttribute("listReply", listReply);
			model.addAttribute("pageNo", current_page);
			model.addAttribute("replyCount", dataCount);
			model.addAttribute("total_page", total_page);
			model.addAttribute("paging", paging);
			
		} catch (Exception e) {
			log.info("listReply : ", e);
			
			resp.sendError(406);
			throw e;
		}
		
		return "city/meeting/listReply";
	}
	
	@ResponseBody
	@PostMapping("deleteReply")
	public Map<String, ?> deleteReply(@RequestParam Map<String, Object> paramMap) {
		Map<String , Object> model = new HashMap<>();
		
		String state = "true";
		try {
			service.deleteReply(paramMap);
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("state", state);
		
		return model;
	}
	
	@ResponseBody
	@PostMapping("replyLike")
	public Map<String, ?> insertReplyLike(
			@RequestParam Map<String, Object> paramMap,
			HttpSession session) {
		
		Map<String , Object> model = new HashMap<>();
		
		String state = "true";
		int likeCount = 0;
		int disLikeCount = 0;
		
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			paramMap.put("num", info.getNum());
			service.replyLike(paramMap);
			
			// 좋아요 싫어요 개수
			Map<String, Object> countMap = service.replyLikeCount(paramMap);
			likeCount = ((BigDecimal)countMap.get("LIKECOUNT")).intValue();
			disLikeCount = ((BigDecimal)countMap.get("DISLIKECOUNT")).intValue();
			
		} catch (DuplicateKeyException e) {
			state = "liked";
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("likeCount", likeCount);
		model.put("disLikeCount", disLikeCount);
		model.put("state", state);
		
		return model;
	}
	
}
