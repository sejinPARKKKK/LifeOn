package com.sp.app.lounge.controller;

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
import com.sp.app.exception.StorageException;
import com.sp.app.lounge.model.FlowBoard;
import com.sp.app.lounge.model.Reprt;
import com.sp.app.lounge.service.FlowBoardService;
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
@RequestMapping(value = "/lounge2/*")
public class FlowBoardController {
	private final FlowBoardService service;
	private final StorageService storageService;
	private final PaginateUtil paginateUtil;
	private final MyUtil myUtil;
	
	private String uploadPath;
	
	@PostConstruct
	public void init() {
		uploadPath = storageService.getRealPath("/uploadPath/daily");
	}
	
	@GetMapping("daily")
	public String dailyList(@RequestParam(name = "page", defaultValue = "1") int current_page,
			@RequestParam(name = "schType", defaultValue = "all") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			Model model,
			HttpServletRequest req) throws Exception {
		
		try {
			int size = 10;
			int total_page = 0;
			int dataCount = 0;
			
			kwd = URLDecoder.decode(kwd, "utf-8");
			
			Map<String, Object> map = new HashMap<>();
			map.put("schType", schType);
			map.put("kwd", kwd);
			
			dataCount = service.dataCount(map);
			if (dataCount != 0) {
				total_page = paginateUtil.pageCount(dataCount, size);
			}
			
			current_page = Math.min(current_page, total_page);
			
			int offset = (current_page - 1) * size;
			if (offset < 0) offset = 0;
			
			map.put("offset", offset);
			map.put("size", size);
			
			// 모든 리스트 출력
			List<FlowBoard> list = service.listBoard(map);
			
			// 조회순 리스트 출력
			map.put("sortCd", "hit");
			model.addAttribute("hitList", service.sortListBoard(map));
			
			// 댓글순 리스트 출력
			map.put("sortCd", "reply");
			model.addAttribute("replyList", service.sortListBoard(map));
			
			// 좋아요순 리스트 출력
			map.put("sortCd", "like");
			model.addAttribute("likeList", service.sortListBoard(map));
			
			String cp = req.getContextPath();
			String query = "page=" + current_page;
			String listUrl = cp + "daily";
			String articleUrl = cp + "daily/article";
			
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
			model.addAttribute("paging", paging);
			
			model.addAttribute("schType", schType);
			model.addAttribute("kwd", kwd);
			model.addAttribute("query", query);
			
		} catch (Exception e) {
			log.info("dailyList : ", e);
		}
		
		return "lounge2/daily/list";
	}
	
	@GetMapping("daily/write")
	public String dailyWriteForm(Model model) throws Exception {
		model.addAttribute("mode", "write");
		return "lounge2/daily/write";
	}
	
	@PostMapping("daily/write")
	public String dailyWriteSubmit(FlowBoard dto,
			HttpSession session, HttpServletRequest req) throws Exception {
		
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			dto.setNum(info.getNum());
			dto.setId(info.getId());
			dto.setNickname(info.getNickName());
			dto.setIpaddr(req.getRemoteAddr());
			
			service.insertBoard(dto, uploadPath);
			
		} catch (Exception e) {
			log.info("writeSubmit : ", e);
		}
		
		return "redirect:/lounge2/daily";
	}
	
	@GetMapping("daily/article/{psnum}")
	public String dailyArticle(
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
			
			FlowBoard dto = Objects.requireNonNull(service.findById(num));
			
			dto.setContent(myUtil.htmlSymbols(dto.getContent()));
			
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			Map<String, Object> map = new HashMap<>();
			map.put("schType", schType);
			map.put("kwd", kwd);
			map.put("psnum", num);
			map.put("num", info.getNum());
			
			FlowBoard prevDto = service.findByPrev(map);
			FlowBoard nextDto = service.findByNext(map);
			
			List<FlowBoard> listFile = service.listFile(num);
			
			boolean isMemberLiked = service.isMemberBoardLiked(map);
			
			Long reprNnum = service.reprtNum(map);
			
			model.addAttribute("dto", dto);
			model.addAttribute("prevDto", prevDto);
			model.addAttribute("nextDto", nextDto);
			model.addAttribute("listFile", listFile);
			
			model.addAttribute("isMemberLiked", isMemberLiked);
			
			model.addAttribute("reprtNum", reprNnum);

			model.addAttribute("query", query);
			model.addAttribute("page", page);
			
			return "lounge2/daily/article";
			
		} catch (NullPointerException e) {
		} catch (Exception e) {
			log.info("dailyArticle : ", e);
		}
		
		return "redirect:/lounge2/daily?" + query;
	}
	
	@GetMapping("daily/update")
	public String dailyUpdateForm(
			@RequestParam(name = "psnum") long num,
			@RequestParam(name = "page") String page,
			Model model,
			HttpSession session) throws Exception {
		
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			FlowBoard dto = Objects.requireNonNull(service.findById(num));
			
			if (! info.getNickName().equals(dto.getNickname())) {
				return "redirect:/lounge2/daily?page=" + page;
			}
			
			List<FlowBoard> listFile = service.listFile(num);
			
			model.addAttribute("dto", dto);
			model.addAttribute("listFile", listFile);
			model.addAttribute("page", page);
			model.addAttribute("mode", "update");
			
			return "lounge2/daily/write";
			
		} catch (NullPointerException e) {
		} catch (Exception e) {
			log.info("updateForm : ", e);
		}
		
		return "redirect:/lounge2/daily/list?page=" + page;
	}
	
	@PostMapping("daily/update")
	public String dailyUpdateSubmit(FlowBoard dto,
			@RequestParam(name = "page") String page,
			HttpSession session) throws Exception {
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			dto.setNum(info.getNum());
			dto.setNickname(info.getNickName());
			service.updateBoard(dto, uploadPath);
			
		} catch (Exception e) {
			log.info("dailyUpdateSubmit : ", e);
		}
		return "redirect:/lounge2/daily?page=" + page;
	}
	
	@ResponseBody
	@PostMapping("daily/deleteFile")
	public Map<String, ?> dailyDeleteFile(@RequestParam(name = "fnum") long fileNum,
			HttpSession session) throws Exception {
		Map<String, Object> model = new HashMap<>();
		
		String state = "false";
		
		try {
			FlowBoard dto = Objects.requireNonNull(service.findByFileId(fileNum));
			
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
	
	@GetMapping("daily/delete")
	public String dailyDeleteBoard(@RequestParam(name = "psnum") long num,
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
			
			service.deleteBoard(num, uploadPath, info.getNickName(), info.getGrade());
			
		} catch (Exception e) {
			log.info("dailyDeleteBoard : ", e);
		}
		
		return "redirect:/lounge2/daily?" + query;
	}
	
	@GetMapping("daily/download")
	public ResponseEntity<?> dailyDownload(
			@RequestParam(name = "fnum") long fileNum,
			HttpServletRequest req) throws Exception {
		
		try {
			FlowBoard dto = Objects.requireNonNull(service.findByFileId(fileNum));
			
			return storageService.downloadFile(uploadPath, dto.getSsfname(), dto.getCpfname());
			
		} catch (NullPointerException | StorageException e) {
			log.info("download : ", e);
		} catch (Exception e) {
			log.info("download : ", e);
		}
		
		String url = req.getContextPath() + "/lounge2/daily/downloadFailed";
		
		return ResponseEntity
				.status(HttpStatus.FOUND)
				.location(URI.create(url))
				.build();
	}
	
	@GetMapping("daily/downloadFailed")
	public String dailyDownloadFailed() {
		return "error/downloadFailure";
	}
	
	@ResponseBody
	@PostMapping("daily/insertBoardLike")
	public Map<String, ?> dailyInsertBoardLike(
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
				service.insertBoardLike(map); 
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
	
	@PostMapping("daily/boardBlind")
	@ResponseBody
	public Map<String, Object> dailyBoardBlind(Reprt dto, HttpSession session) {
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			Map<String, Object> map = new HashMap<>();
			
			map.put("num",info.getNum());
			map.put("repr",dto.getRepr());
			map.put("repan",dto.getRepan());
			
			service.insertBoardBlind(map);
			
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("state", state);
		
		return model;
	}
	
	@PostMapping("daily/insertReply")
	@ResponseBody
	public Map<String, Object> dailyInsertReply(FlowBoard dto, HttpSession session) {
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			dto.setNum(info.getNum());
			dto.setPsnum(dto.getPsnum());
			service.insertReply(dto);
			
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("state", state);
		
		return model;
	}
		
	@GetMapping("daily/listReply")
	public String dailyListReply(FlowBoard dto,
			@RequestParam(name = "rpnum") long num,
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
			
			List<FlowBoard> listReply = service.listReply(map);
			
			String paging = paginateUtil.pagingMethod(current_page, total_page, "listPage");
			
			model.addAttribute("listReply", listReply);
			model.addAttribute("pageNo", current_page);
			model.addAttribute("replyCount", dataCount);
			model.addAttribute("total_page", total_page);
			model.addAttribute("paging", paging);
			
		} catch (Exception e) {
			log.info("dailyListReply : ", e);
			
			resp.sendError(406);
			throw e;
		}
		
		return "lounge2/daily/listReply";
	}
	
	@ResponseBody
	@PostMapping("daily/deleteReply")
	public Map<String, ?> dailyDeleteReply(@RequestParam Map<String, Object> paramMap) {
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
	@PostMapping("daily/insertReplyLike")
	public Map<String, ?> dailyInsertReplyLike(
			@RequestParam Map<String, Object> paramMap,
			HttpSession session) {
		
		Map<String , Object> model = new HashMap<>();
		
		String state = "true";
		int likeCount = 0;
		int disLikeCount = 0;
		
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			paramMap.put("num", info.getNum());
			service.insertReplyLike(paramMap);
			
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
	
	@ResponseBody
	@PostMapping("daily/replyBlind")
	public Map<String, ?> dailyReplyBlind(
			@RequestParam Map<String, Object> paramMap,
			HttpSession session) {
		
		Map<String , Object> model = new HashMap<>();
		
		String state = "true";
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			paramMap.put("num", info.getNum());
			
			service.updateReplyBlind(paramMap);
			
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("state", state);
		
		return model;
	}
}
