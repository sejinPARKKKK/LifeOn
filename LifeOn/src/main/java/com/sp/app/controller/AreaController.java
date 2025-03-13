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
import com.sp.app.model.Area;
import com.sp.app.model.Meeting;
import com.sp.app.model.SessionInfo;
import com.sp.app.service.AreaService;

import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping(value = "/city/area/*")
public class AreaController {
	private final AreaService service;
	private final StorageService storageService;
	private final PaginateUtil paginateUtil;
	private final MyUtil myUtil;
	
	private String uploadPath;
	
	@PostConstruct
	public void init() {
		uploadPath = this.storageService.getRealPath("/uploadPath/area");		
	}
	
	/*
	@GetMapping("main")
	public String AreaList(Model model) {
		
		return "city/area/main";
	}
	*/
	@GetMapping("main")
	public String AreaList(
			@RequestParam(name = "lnum", defaultValue = "0") long categoryNum,
			@RequestParam(name = "page", defaultValue = "1") int current_page,
			@RequestParam(name = "schType", defaultValue = "all") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			Model model,
			HttpServletRequest req) throws Exception {
		
		try {
			int size = 8;
			int total_page = 0;
			int dataCount = 0;
			
			kwd = URLDecoder.decode(kwd, "utf-8");
			
			List<Area> listCategory = service.listCategory(); 
			
			
			Map<String, Object> map = new HashMap<>();
			map.put("lnum", categoryNum);
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
			
			List<Area> list = service.listBoard(map);
			List<Area> bestList = service.bestArea(map);
			
			String cp = req.getContextPath();
			
			String listUrl = cp + "/city/area/main";
			String articleUrl = cp + "/city/area/article";
			
			String query = "page=" + current_page;
			
			if (! kwd.isBlank()) {
				 String qs = "schType=" + schType + "&kwd=" + URLEncoder.encode(kwd, "utf-8");
				
				listUrl += "?" + qs;
				query += "&" + qs;
			}
			
			String paging = paginateUtil.paging(current_page, total_page, listUrl);
			
			model.addAttribute("listCategory", listCategory);
			model.addAttribute("list", list);
			model.addAttribute("bestList", bestList);
			model.addAttribute("dataCount", dataCount);
			model.addAttribute("size", size);
			
			model.addAttribute("page", current_page);
			model.addAttribute("total_page", total_page);
			model.addAttribute("articleUrl", articleUrl);
			model.addAttribute("paging", paging);
			
			model.addAttribute("lnum", categoryNum);
			model.addAttribute("query", query);
			
			model.addAttribute("schType", schType);
			model.addAttribute("kwd", kwd);
			
		} catch (Exception e) {
			log.info("AreaList : ", e);
		}
		
		return "city/area/main";
	}
	
	@GetMapping("write")
	public String writeForm(Model model) throws Exception {
		
		List<Area> Category = service.listCategory();
		
		model.addAttribute("mode", "write");
		model.addAttribute("Category", Category);
		
		return "city/area/write";
	}
	
	@PostMapping("write")
	public String writeSubmit(Area dto, Model model,
			HttpSession session,HttpServletRequest req) throws Exception {
		
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			dto.setNum(info.getNum());
			dto.setRvnum(dto.getRvnum());
			
			service.insertBoard(dto, uploadPath);
			
		} catch (Exception e) {
			log.info("writeSubmit : ", e);
		}
		
		return "redirect:/city/area/main";
	}
	
	@GetMapping("article/{rvnum}")
	public String article(
			@PathVariable(name = "rvnum") long rvnum,
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
			
			service.updateHitCount(rvnum);
			
			Area dto = Objects.requireNonNull(service.findById(rvnum));
			
			//dto.setRvcontent(myUtil.htmlSymbols(dto.getRvcontent()));
			
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			Map<String, Object> map = new HashMap<>();
			map.put("schType", schType);
			map.put("kwd", kwd);
			map.put("rvnum", rvnum);
			map.put("num", dto.getNum());
			
			List<Area> listFile = service.listAreaFile(rvnum);
			
			map.put("num", info.getNum());
			
			boolean isMemberLiked = service.memberBoardLiked(map);
			
			model.addAttribute("rvnum", rvnum);
			model.addAttribute("dto", dto);
			model.addAttribute("isMemberLiked", isMemberLiked);
			model.addAttribute("listFile", listFile);
			model.addAttribute("query", query);
			model.addAttribute("page", page);
			
			return "city/area/article";
			
		} catch (NullPointerException e) {
		} catch (Exception e) {
			log.info("article : ", e);
		}
		
		return "redirect:/area/city/main?" + query;
	}
	
	@ResponseBody
	@PostMapping("boardLike")
	public Map<String, ?> boardLike(
			@RequestParam(name = "rvnum") long num,
			@RequestParam(name = "memberLiked") boolean memberLiked,
			HttpSession session) {
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		int boardLikeCount = 0;
		
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			Map<String, Object> map = new HashMap<>();
			map.put("rvnum", num);
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
	public Map<String, Object> reply(Area dto, HttpSession session) {
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			dto.setNum(info.getNum());
			dto.setRvnum(dto.getRvnum());
			service.reply(dto);
			
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("state", state);
		
		return model;
	}
		
	@GetMapping("listReply")
	public String listReply(Area dto, @RequestParam(name = "rpnum") long num,
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
			map.put("rvnum", dto.getRvnum());
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
			
			List<Area> listReply = service.listReply(map);
			
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
		
		return "city/area/listReply";
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
