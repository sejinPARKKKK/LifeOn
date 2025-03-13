package com.sp.app.lounge.controller;

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
import com.sp.app.lounge.model.PhotoBoard;
import com.sp.app.lounge.service.PhotoBoardService;
import com.sp.app.model.SessionInfo;

import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/lounge1/*")
public class PhotoBoardController {
	private final PhotoBoardService service;
	private final StorageService storageService;
	private final PaginateUtil paginateUtil;
	private final MyUtil myUtil;
	
	private String uploadPath;
	
	@PostConstruct
	public void init() {
		uploadPath = storageService.getRealPath("/uploadPath/lounge1");
	}
	
	/*
	@GetMapping("room")
	public String roomList(Model model) {
		
		model.addAttribute("bdtype", "room");
		
		return "lounge1/list";
	}
	
	@GetMapping("recipe")
	public String recipeList(Model model) {
		
		model.addAttribute("bdtype", "recipe");
		
		return "lounge1/list";
	}
	*/
	
	@GetMapping("{bdtype}/write")
	public String writeForm(@PathVariable(name = "bdtype") String bdtype, Model model) throws Exception {
		/*
		// 로그인 확인
		SessionInfo info = (SessionInfo) session.getAttribute("member");
		if (info == null) {
		// 로그인하지 않은 경우: 로그인 페이지로 리다이렉트
		session.setAttribute("redirectUrl", "/lounge1/write/" + bdtype); // 리다이렉트할 URL을 세션에 저장
		return "redirect:/member/login"; // 로그인 페이지로 리다이렉트
		}
	*/
		// 로그인 상태라면 글쓰기 폼 열기
		model.addAttribute("bdtype", bdtype);
		model.addAttribute("mode", "write");
		
		return "lounge1/write"; // 글쓰기 폼 페이지 반환
	}

	@PostMapping("{bdtype}/write")
	public String writeSubmit(@PathVariable(name = "bdtype") String bdtype, PhotoBoard dto,
			HttpSession session, HttpServletRequest req) throws Exception {
		
			try {
				
		        SessionInfo info = (SessionInfo) session.getAttribute("member");
		        /*
		        if (info == null) {
		            // 로그인하지 않으면 로그인 페이지로 리다이렉트
		            session.setAttribute("redirectUrl", "/lounge1/write/" + bdtype); // 글쓰기 후 돌아올 페이지를 세션에 저장
		            return "redirect:/member/login"; // 로그인 페이지로 리다이렉트
		        }
				*/
				
		    dto.setNum(info.getNum());
		    dto.setId(info.getId());
			dto.setNickname(info.getNickName());
			dto.setIpaddr(req.getRemoteAddr());
			dto.setBdtype(bdtype);
			
			service.insertBoard(dto, uploadPath);
			
		} catch (Exception e) {
			log.info("writeSubmit : ", e);
		}
		
		return "redirect:/lounge1/" + bdtype;
	}
	
	@GetMapping("{bdtype}")
	public String list(@PathVariable(name = "bdtype") String bdtype,
			@RequestParam(name = "page", defaultValue = "1") int current_page,
			@RequestParam(name = "schType", defaultValue = "all") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			Model model,
			HttpServletRequest req) throws Exception {
		
		try {
			int size = 12;
			int total_page = 0;
			int dataCount = 0;
			
			kwd = URLDecoder.decode(kwd, "utf-8");
			
			Map<String, Object> map = new HashMap<>();
			map.put("schType", schType);
			map.put("kwd", kwd);
			map.put("bdtype", bdtype);
			
			dataCount = service.dataCount(map);
			total_page = paginateUtil.pageCount(dataCount, size);
			
			current_page = Math.min(current_page, total_page);
			
			int offset = (current_page - 1) * size;
			if (offset < 0) offset = 0;
			
			map.put("offset", offset);
			map.put("size", size);
			
			List<PhotoBoard> list = service.listBoard(map);
			
			String cp = req.getContextPath();
			String query = "page=" + current_page;
			String listUrl = cp + "/lounge1/" +bdtype; 
			String articleUrl = cp + "/lounge1/" + bdtype + "/article";
			if (! kwd.isBlank()) {
				 String qs = "schType=" + schType + "&kwd=" + URLEncoder.encode(kwd, "utf-8");
				
				listUrl += "?" + qs;
				query += "&" + qs;
			}
			
			String paging = paginateUtil.paging(current_page, total_page, listUrl);
			
			model.addAttribute("list", list);
			model.addAttribute("dataCount", dataCount);
			model.addAttribute("size", size);
			model.addAttribute("page", current_page);
			model.addAttribute("total_page", total_page);
			model.addAttribute("articleUrl", articleUrl);
			model.addAttribute("query", query);
			model.addAttribute("paging", paging);
			
			model.addAttribute("schType", schType);
			model.addAttribute("kwd", kwd);
			
		} catch (Exception e) {
			log.info("list : ", e);
		}
		
		return "lounge1/list";
	}
	
	@GetMapping("{bdtype}/article/{psnum}")
	public String article(@PathVariable(name = "bdtype") String bdtype,
			@PathVariable(name = "psnum") long psnum,
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
			
			service.updateHitCount(psnum);
			
			Map<String, Object> map = new HashMap<>();
			map.put("bdtype", bdtype);
			map.put("psnum", psnum);
			
			PhotoBoard dto = Objects.requireNonNull(service.findById(map));
			
			// dto.setContent(myUtil.htmlSymbols(dto.getContent())); 엔터를 <Br>로 , 스마트 에디터 사용하므로 (태그보임)

			map.put("schType", schType);
			map.put("kwd", kwd);
			
			PhotoBoard prevDto = service.findByPrev(map);
			PhotoBoard nextDto = service.findByNext(map);
			
			List<PhotoBoard> listFile = service.listFile(psnum);
			
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			map.put("num", info.getNum());
			boolean isMemberLiked = service.memberBoardLiked(map);
			
			model.addAttribute("bdtype", bdtype); 
			model.addAttribute("psnum", psnum); 
			model.addAttribute("dto", dto);
			model.addAttribute("prevDto", prevDto);
			model.addAttribute("nextDto", nextDto);
			model.addAttribute("listFile", listFile);
			model.addAttribute("isMemberLiked", isMemberLiked);
			
			model.addAttribute("query", query);
			model.addAttribute("page", page);
			
			return "lounge1/article";
			
		} catch (NullPointerException e) {
		} catch (Exception e) {
			log.info("article : ", e);
		}
		
		return "redirect:/lounge1/" + bdtype + "?" + query;
	}
	
	@GetMapping("{bdtype}/update")
	public String updateForm(@PathVariable(name = "bdtype") String bdtype,
			@RequestParam(name = "psnum") long num,
			@RequestParam(name = "page") String page,
			Model model,
			HttpSession session) throws Exception {
		
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			Map<String, Object> map = new HashMap<>();
			map.put("bdtype", bdtype);
			map.put("psnum", num);
			
			PhotoBoard dto = Objects.requireNonNull(service.findById(map));
			
			if (! info.getNickName().equals(dto.getNickname())) {
				return "redirect:/lounge1/" + bdtype + "?page=" + page;
			}
			
			List<PhotoBoard> listFile = service.listFile(num);
			
			model.addAttribute("dto", dto);
			model.addAttribute("listFile", listFile);
			model.addAttribute("page", page);
			model.addAttribute("mode", "update");
			
			return "lounge1/write";
			
		} catch (NullPointerException e) {
		} catch (Exception e) {
			log.info("updateForm : ", e);
		}
		
		return "redirect:/lounge1/" + bdtype + "?page=" + page;
	}
	
	@PostMapping("{bdtype}/update")
	public String updateSubmit(@PathVariable(name = "bdtype") String bdtype,
			PhotoBoard dto, @RequestParam(name = "page") String page,
			HttpSession session) throws Exception {
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			dto.setNum(info.getNum());
			dto.setNickname(info.getNickName());
			
			service.updateBoard(dto, uploadPath);
			
		} catch (Exception e) {
			log.info("updateSubmit : ", e);
		}
		return "redirect:/lounge1/" + bdtype + "?page=" + page;
	}
	
	@ResponseBody
	@PostMapping("{bdtype}/deleteFile")
	public Map<String, ?> deleteFile(@RequestParam(name = "fnum") long fileNum,
			HttpSession session) throws Exception {
		Map<String, Object> model = new HashMap<>();
		
		String state = "false";
		
		try {
			PhotoBoard dto = Objects.requireNonNull(service.findByFileId(fileNum));
			
			service.deleteUploadFile(uploadPath, dto.getSsfname());
			
			Map<String, Object> map = new HashMap<>();
			map.put("field", "fnum");
			map.put("psnum", fileNum);
				
			service.deleteFile(map);
			
			state = "true";
			
		} catch (NullPointerException e) {
			log.info("deleteFile : ", e);
		} catch (Exception e) {
			log.info("deleteFile : ", e);
		}
		
		model.put("state", state);
		return model;
	}
		
	@GetMapping("{bdtype}/delete")
	public String deleteBoard(@PathVariable(name = "bdtype") String bdtype,
			@RequestParam(name = "psnum") long psnum,
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
			
			service.deleteBoard(bdtype, psnum, uploadPath, info.getNickName(), info.getGrade());
			
		} catch (Exception e) {
			log.info("deleteBoard : ", e);
		}
		
		return "redirect:/lounge1/" + bdtype + "?" + query;
	}
	
	@ResponseBody
	@PostMapping("{bdtype}/boardLike")
	public Map<String, ?> boardLike(@PathVariable(name = "bdtype") String bdtype,
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
	
	@PostMapping("{bdtype}/reply")
	@ResponseBody
	public Map<String, Object> reply(@PathVariable(name = "bdtype") String bdtype,
			PhotoBoard dto, HttpSession session) {
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
		
	@GetMapping("{bdtype}/listReply")
	public String listReply(@PathVariable(name = "bdtype") String bdtype,
			PhotoBoard dto, @RequestParam(name = "rpnum") long num,
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
			
			List<PhotoBoard> listReply = service.listReply(map);
			
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
		
		return "lounge1/listReply";
	}
	
	@ResponseBody
	@PostMapping("{bdtype}/deleteReply")
	public Map<String, ?> deleteReply(@PathVariable(name = "bdtype") String bdtype,
		@RequestParam Map<String, Object> paramMap) {
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
	@PostMapping("{bdtype}/replyLike")
	public Map<String, ?> insertReplyLike(@PathVariable(name = "bdtype") String bdtype,
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