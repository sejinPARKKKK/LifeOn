package com.sp.app.admin.controller;

import java.math.BigDecimal;
import java.net.URI;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
import com.sp.app.model.PolicyBoard;
import com.sp.app.model.PolicyReply;
import com.sp.app.model.SessionInfo;
import com.sp.app.service.PolicyBoardService;

import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/policy/*")
public class PolicyBoardController {
	private final PolicyBoardService service;
	private final StorageService storageService;
	private final PaginateUtil paginateUtil;
	private final MyUtil myUtil;
	
	private String uploadPath;
	
	@PostConstruct // 생성자 호출후 한번 실행 
	public void init() {
		// 파일을 저장할 실제 경로
		uploadPath = storageService.getRealPath("/uploads/policy");
	}
	
	@GetMapping("list")
	public String list(
			@RequestParam(name = "page", defaultValue = "1") int current_page,
			@RequestParam(name = "schType", defaultValue = "all") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			Model model,
			HttpServletRequest req, HttpSession session) throws Exception {
		
		try {
			int size = 10;
			int total_page = 0;
			int dataCount = 0;
			
			kwd = URLDecoder.decode(kwd, "utf-8");
			
			Map<String, Object> map = new HashMap<>();
			map.put("schType", schType);
			map.put("kwd", kwd);
			
			dataCount = service.dataCount(map);
			total_page = paginateUtil.pageCount(dataCount, size);
			
			current_page = Math.min(current_page, total_page);
			
			int offset = (current_page -1) * size;
			if(offset < 0) offset = 0;
			
			map.put("offset", offset);
			map.put("size", size);
			
			List<PolicyBoard> list = service.listBoard(map);
			
			String cp = req.getContextPath();
			String query = "page=" + current_page;
			String listUrl = cp + "/policy/list";
			
			if(! kwd.isBlank()) {
				String qs  = "schType=" + schType + "&kwd=" +
						URLEncoder.encode(kwd, "utf-8");

				listUrl += "?" + qs;
				query += "&"  + qs;
				
			}
			
			String paging = paginateUtil.paging(current_page, total_page, listUrl);
			
			model.addAttribute("list", list);
			model.addAttribute("dataCount", dataCount);
			model.addAttribute("size", size);
			model.addAttribute("page", current_page);
			model.addAttribute("total_page", total_page);
			model.addAttribute("query", query);
			model.addAttribute("paging", paging);
			
			model.addAttribute("schType", schType);
			model.addAttribute("kwd", kwd);				
			
			
			
		} catch (Exception e) {
			log.info("list : ", e);
		}
		return "policy/list";
	}
	
	@GetMapping("write")
	public String writeForm(Model model) throws Exception {
		model.addAttribute("mode", "write");
		return "policy/write";
	}
	
	@PostMapping("write")
	public String writeSubmit(PolicyBoard dto, HttpSession session) throws Exception {
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			dto.setUserId(info.getId());
			
			service.insertBoard(dto, uploadPath);
			
		} catch (Exception e) {
			log.info("writeSubmit: ", e);
		}
		return "redirect:/policy/list";
	}
	
	@GetMapping("article/{psnum}")
	public String article(
			@PathVariable("psnum") long psnum,
			@RequestParam(name = "page",  required = false, defaultValue = "1") String page,
			@RequestParam(name = "schType", defaultValue = "all") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			Model model,
			HttpSession session) throws Exception {
		
		String query = "page=" + page;
		
		try {
			kwd = URLDecoder.decode(kwd, "utf-8");
			if(! kwd.isBlank()) {
				query += "$schType=" + schType + "&kwd="
						+ URLEncoder.encode(kwd, "utf-8");
			}
			
			//조회수 
			service.updateHitCount(psnum);
			
			//게시글 가져오기
			PolicyBoard dto = Objects.requireNonNull(service.findById(psnum));
			
			Map<String, Object> map = new HashMap<>();
			map.put("schType", schType);
			map.put("kwd", kwd);
			map.put("psnum", psnum);
			
			PolicyBoard prevDto = service.findByPrev(map);
			PolicyBoard nextDto = service.findByNext(map);
			
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			map.put("userId", info.getId());
			boolean isUserLiked = service.isUserBoardLiked(map);
			
			model.addAttribute("dto", dto);
			model.addAttribute("prevDto", prevDto);
			model.addAttribute("nextDto", nextDto);
			
			model.addAttribute("isUserLiked", isUserLiked);
			
			
			model.addAttribute("query", query);
			model.addAttribute("page", page);
			
		
			
			return "policy/article";
		} catch (NullPointerException e) {
		} catch (Exception e) {
			log.info("article : ", e);
		}
		
		
		return "redirect:/policy/list?" + query;	
	
	}
	
	@GetMapping("update")
	public String updateForm(
			@RequestParam(name="psnum") long psnum,
			@RequestParam(name= "page") String page,
			Model model,
			HttpSession session) throws Exception {
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			PolicyBoard dto = Objects.requireNonNull(service.findById(psnum));
		
			if(! info.getId().equals(dto.getUserId())) {
				return "redirect:/policy/list?page=" + page;
				
			}
			model.addAttribute("dto", dto);
			model.addAttribute("page", page);
			model.addAttribute("mode", "update");
		
			return "policy/write";
		} catch (NullPointerException e) {
		} catch (Exception e) {
			log.info("updateForm : ", e);
		}
		
		return "redirect:/policy/list?page=" + page;
	}
	
	@PostMapping("update")
	public String updateSubmit(PolicyBoard dto,
			@RequestParam(name ="page") String page) {
		
		try {
			service.updateBoard(dto, page);
			
		} catch (Exception e) {
			log.info("updateSubmit:", e);
		}
		
		return "redirect:/policy/list?page=" + page;
	}
	
	@GetMapping("deleteFile")
	public String deleteFile(@RequestParam(name="psnum") long psnum,
			@RequestParam(name="page") String page,
			HttpSession session) {
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			PolicyBoard dto = Objects.requireNonNull(service.findById(psnum));
			
			if(! info.getId().equals(dto.getUserId())) {
				return "redirect:policy/list?page=" + page;
			}
			
			if(dto.getSavefilename() != null) {
				service.deleteUploadFile(uploadPath, dto.getSavefilename());
				
				dto.setSavefilename("");
				dto.setOriginalfilename("");
				service.updateBoard(dto, uploadPath);
			}
			
			return "redirect:/policy/update?psnum=" + psnum + "&page=" + page;
		} catch (NullPointerException e) {
		} catch (Exception e) {
			log.info("deleteFile : ", e);
		}
		return "redirect:/policy/list?page=" + page;
	}
	
	@GetMapping("delete")
	public String deleteBoard(@RequestParam(name="psnum") long psnum, 
			@RequestParam(name= "schType", defaultValue="all") String schType,
			@RequestParam(name= "kwd", defaultValue = "") String kwd, 
			@RequestParam(name= "page") String page,
			HttpSession session) {
		
		String query = "page=" + page;
		
		try {
			kwd=URLDecoder.decode(kwd, "utf-8");
			if(! kwd.isBlank()) {
				query += "&schType=" + schType + "&kwd="
						+ URLEncoder.encode(kwd,"utf-8");
			}
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			service.deleteBoard(psnum, uploadPath, info.getId(), info.getGrade());
		} catch (Exception e) {

		}
		return "redirect:/policy/list?" + query;
	
	}
	
	@GetMapping("download")
	public ResponseEntity<?> download(
			@RequestParam(name ="psnum") long psnum,
			HttpServletRequest req) throws Exception {
		
		try {
			PolicyBoard dto = Objects.requireNonNull(service.findById(psnum));
			
			return storageService.downloadFile(uploadPath, dto.getSavefilename(), dto.getOriginalfilename());
			
		} catch (NullPointerException e) {
		} catch (Exception e) {
			log.info("download", e);
		}
		
		String url = req.getContextPath() + "/policy/downloadFailed";
		
		return ResponseEntity
				.status(HttpStatus.FOUND)
				.location(URI.create(url))
				.build();
	}
	
	@GetMapping("downloadFailed")
	public String downloadFailed() {
		return "error/downloadFailure";
	}
	
	
	//게시글 좋아요 추가/삭제 : AJAX-JSON
	@ResponseBody
	@PostMapping("insertBoardLike")
	public Map<String, ?> insertBoardLike(
			@RequestParam(name ="psnum") long psnum,
			@RequestParam(name ="userLiked") boolean userLiked,
			HttpSession session) {
		
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		int boardLikeCount = 0;
		
		try {
			SessionInfo info = 
					(SessionInfo)session.getAttribute("member");
			
			Map<String, Object> map = new HashMap<>();
			map.put("psnum", psnum);
			map.put("userId", info.getId());
			
			if(userLiked) {
				service.deleteBoardLike(map); // 좋아요 해제
			} else {
				service.insertBoardLike(map); // 좋아요 추가
			}
			
			boardLikeCount = service.boardLikeCount(psnum);
			
		} catch (DuplicateKeyException e) {
			state = "liked";
		} catch(Exception e) {
			state = "false";
		}
		
		model.put("state", state);
		model.put("boardLikeCount", boardLikeCount);
		
		return model;
	}
	
	//댓글 및 댓글의 답글 등록 : AJAX-JSON
	@PostMapping("insertReply")
	@ResponseBody
	public Map<String, Object> insertReply(PolicyReply dto, HttpSession session) {
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			dto.setUserId(info.getId());
			
			service.insertReply(dto);
			
		} catch (Exception e) {
			state="false";
		}
		model.put("state", state);
		
		return model;
	}
	
	//댓글 리스트 : AJAX - TEXT
	@GetMapping("listReply")
	public String listReply(
			@RequestParam(name = "psnum") long psnum,
			@RequestParam(name ="pageNo", defaultValue = "1") int current_page,
			Model model,
			HttpServletResponse resp,
			HttpSession session ) throws Exception {
		
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			int size = 5;
			int total_page = 0;
			int dataCount = 0;
			
			Map<String, Object> map = new HashMap<>();
			map.put("psnum", psnum);
			map.put("userId", info.getId());
			
			dataCount = service.replyCount(map);
			total_page = paginateUtil.pageCount(dataCount, size);
			current_page = Math.min(current_page, total_page);
			
			int offset = (current_page -1) * size;
			if(offset < 0 ) offset = 0;
			
			map.put("offset",  offset);
			map.put("size", size);
			
			List<PolicyReply> listReply = service.listReply(map);
			
			
			
			
			String paging = paginateUtil.pagingMethod(
					current_page, total_page, "listPage");
			
			model.addAttribute("listReply", listReply);
			model.addAttribute("pageNo", current_page);
			model.addAttribute("replyCount", dataCount);
			model.addAttribute("total_page", total_page);
			model.addAttribute("paging", paging);
			
			
		} catch (Exception e) {
			log.info("listReply : " , e);
			
			resp.sendError(406);
			throw e;
		}
		
		return "policy/listReply";
	}
	
	//댓글 및 댓글의 답글 삭제 : AJAX-JSON
	@ResponseBody
	@PostMapping("deleteReply")
	public Map<String, ?> deleteReply(@RequestParam Map<String, Object> paramMap) {
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		try {
			service.deleteReply(paramMap);
			
		} catch (Exception e) {
			state = "false";
		}
		model.put("state", state);
		return model;
	}
	
	@GetMapping("listReplyAnswer")
	public String listReplyAnswer(
			@RequestParam Map<String, Object> paramMap,
			Model model,
			HttpServletResponse resp,
			HttpSession session	) throws Exception {
		
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			paramMap.put("userId", info.getId());
			
			List<PolicyReply> listAnswer = service.listReplyAnswer(paramMap);
			
			model.addAttribute("listAnswer", listAnswer);
		} catch (Exception e) {
			log.info("listReplyAnswer : ", e);
			
			resp.sendError(406);
			throw e;
		}
		
		return "policy/listReplyAnswer";
	}
	
	@ResponseBody
	@PostMapping("countReplyAnswer")
	public Map<String, ?> countReplyAnswer(
			@RequestParam Map<String, Object> paramMap,
			HttpSession session) throws Exception {
		
		Map<String, Object> model = new HashMap<>();
		
		int count = 0;
		
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			paramMap.put("userId", info.getId());
			
			count = service.replyAnswerCount(paramMap);
			
		} catch (Exception e) {
			log.info("countReplyAnswer : ", e);
		}
		model.put("count", count);
		
		return model;
	}
	
	//댓글의 좋아요/싫어요 추가 : AJAX-JSON
	@ResponseBody
	@PostMapping("insertReplyLike")
	public Map<String, ?> insertReplyLike(
			@RequestParam Map<String, Object> paramMap,
			HttpSession session) {
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		int likeCount = 0;
		int disLikeCount = 0;
		
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			paramMap.put("userId", info.getId());
			service.insertReplyLike(paramMap);
			
			Map<String, Object> countMap = service.replyLikeCount(paramMap);
			
			likeCount = ((BigDecimal)countMap.get("LIKECOUNT")).intValue();
			disLikeCount =((BigDecimal)countMap.get("DISLIKECOUNT")).intValue();
			
			
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
