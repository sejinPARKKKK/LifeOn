package com.sp.app.rent.controller;

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

import com.sp.app.common.PaginateUtil;
import com.sp.app.common.StorageService;
import com.sp.app.model.SessionInfo;
import com.sp.app.rent.model.RentProduct;
import com.sp.app.rent.model.RentProductOrder;
import com.sp.app.rent.service.RentService;
import com.sp.app.rent.service.RentServiceOrder;

import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping(value = "/market/rent/*")
public class RentController {
	private final RentService service;
	private final RentServiceOrder orderService;
	private final StorageService storageService;
	private final PaginateUtil paginateUtil;
	
	private String uploadPath;
	
	@PostConstruct
	public void init() {
		uploadPath = this.storageService.getRealPath("/uploadPath/rent");		
	}
	
	@GetMapping("main")
	public String RentList(
			@RequestParam(name = "cbn", defaultValue = "0") long categoryNum,
			@RequestParam(name = "csn", defaultValue = "0") long subCategoryNum,
			@RequestParam(name = "page", defaultValue = "1") int current_page,
			@RequestParam(name = "schType", defaultValue = "productName") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			Model model,
			HttpSession session,
			HttpServletRequest req) throws Exception {
		
		try {
			int size = 12;
			int total_page = 0;
			int dataCount = 0;
			
			kwd = URLDecoder.decode(kwd, "utf-8");
			
			List<RentProduct> listCategory = service.listCategory(); 
			List<RentProduct> listSubCategory = service.listSubCategory(categoryNum);
			
			Map<String, Object> map = new HashMap<>();
			map.put("cbn", categoryNum);
			map.put("csn", subCategoryNum);
			map.put("schType", schType);
			map.put("kwd", kwd);
			
			if (categoryNum != 0) {
				for (int i = 0; i < listCategory.size(); i++) {
					if (listCategory.get(i).getCbn() == categoryNum) {
						model.addAttribute("largeCate", listCategory.get(i).getCbc());
					}
				}
			} else if (subCategoryNum != 0) {
				for (int i = 0; i < listCategory.size(); i++) {
					for (int j = 0; j < listCategory.get(i).getListSub().size(); j++) {
						if (listCategory.get(i).getListSub().get(j).getCsn() == subCategoryNum) {
							model.addAttribute("largeCate", listCategory.get(i).getCbc());
							model.addAttribute("smallCate", listCategory.get(i).getListSub().get(j).getCsc());
						}
					}
				}
			}
			
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
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
			
			List<RentProduct> list = service.listRentProduct(map);
			List<RentProduct> bestList = service.bestListRentProduct(map);
			
			String cp = req.getContextPath();
			
			String listUrl = cp + "/market/rent/main";
			String articleUrl = cp + "/market/rent/article";
			
			String query = "page=" + current_page;
			
			if (! kwd.isBlank()) {
				String qs = "schType=" + schType + "&kwd=" + URLEncoder.encode(kwd, "utf-8");
				
				listUrl += "?" + qs;
				query += "&" + qs;
			}
			
			if (info != null && info.getNum() > 0) {
				map.put("num", info.getNum());

				for (int i = 0; i < list.size(); i++) {
					map.put("pnum", list.get(i).getPnum());
					
					boolean isMemberProductLiked = service.isMemberProductLiked(map);
					
					if (isMemberProductLiked) {
						list.get(i).setMemberLiked(1);
					} else {
						list.get(i).setMemberLiked(-1);
					}
				}
			}
			
			String paging = paginateUtil.paging(current_page, total_page, listUrl);
			
			model.addAttribute("listCategory", listCategory);
			model.addAttribute("listSubCategory", listSubCategory);
			model.addAttribute("list", list);
			model.addAttribute("bestList", bestList);
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
			log.info("RentList : ", e);
		}
		
		return "market/rent/main";
	}
	
	@GetMapping("write")
	public String writeForm(Model model) throws Exception {
		
		List<RentProduct> listCategory = service.listCategory();
		
		model.addAttribute("listCategory", listCategory);
		model.addAttribute("mode", "write");
		
		return "market/rent/write";
	}
	
	@PostMapping("write")
	public String writeSubmit(RentProduct dto,
			Model model, HttpSession session, HttpServletRequest req) throws Exception {
		
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			dto.setNum(info.getNum());
			
			service.insertRentProduct(dto, uploadPath);
			
		} catch (Exception e) {
			log.info("writeSubmit : ", e);
		}
		
		return "redirect:/market/rent/main";
	}
	
	@ResponseBody
	@PostMapping("listSubCategory")
	public List<RentProduct> getSmallCategories(@RequestParam(name = "cbn") int categoryNum) {
		return service.listSubCategory(categoryNum);
	}
	
	@GetMapping("article/{pnum}")
	public String article(
			@PathVariable(name = "pnum") long productNum,
			@RequestParam(name = "page") String page,
			@RequestParam(name = "schType", defaultValue = "productName") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			Model model,
			HttpSession session) throws Exception {
		
		String query = "page=" + page;
		
		try {
			kwd = URLDecoder.decode(kwd, "utf-8");
			if (! kwd.isBlank()) {
				query += "&schType=" + schType + "&kwd=" + URLEncoder.encode(kwd, "utf-8");
			}
			
			RentProduct dto = Objects.requireNonNull(service.findById(productNum));
			
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			Map<String, Object> map = new HashMap<>();
			map.put("schType", schType);
			map.put("kwd", kwd);
			map.put("pnum", productNum);
			map.put("num", dto.getNum());
			
			List<RentProduct> memberProduct = service.findByMemberProduct(map);
			List<RentProduct> listFile = service.listProductFile(productNum);
			
			map.put("num", info.getNum());
			
			boolean isMemberLiked = service.isMemberProductLiked(map);
			
			model.addAttribute("dto", dto);
			model.addAttribute("memberProduct", memberProduct);
			model.addAttribute("memberProductSize", memberProduct.size());
			model.addAttribute("listFile", listFile);
			
			model.addAttribute("isMemberLiked", isMemberLiked);
			
			model.addAttribute("pnum", productNum);

			model.addAttribute("query", query);
			model.addAttribute("page", page);
			
			return "market/rent/article";
			
		} catch (NullPointerException e) {
		} catch (Exception e) {
			log.info("article : ", e);
		}
		
		return "redirect:/market/rent/main?" + query;
	}
	
	@GetMapping("update")
	public String updateForm(
			@RequestParam(name = "pnum") long productNum,
			@RequestParam(name = "page") String page,
			Model model,
			HttpSession session) throws Exception {
		
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			RentProduct dto = Objects.requireNonNull(service.findById(productNum));
			
			if (! info.getNickName().equals(dto.getNickname())) {
				return "redirect:/market/rent/main?page=" + page;
			}
			
			List<RentProduct> listFile = service.listProductFile(productNum);
			
			List<RentProduct> listCategory = service.listCategory();
			List<RentProduct> listSubCategory = service.listSubCategory(dto.getCbn());
			
			model.addAttribute("listCategory", listCategory);
			model.addAttribute("listSubCategory", listSubCategory);

			model.addAttribute("cbn", dto.getCbn());
			model.addAttribute("csn", dto.getCsn());
			
			model.addAttribute("dto", dto);
			model.addAttribute("listFile", listFile);
			model.addAttribute("page", page);
			model.addAttribute("mode", "update");
			
			return "market/rent/write";
			
		} catch (NullPointerException e) {
		} catch (Exception e) {
			log.info("updateForm : ", e);
		}
		
		return "redirect:/market/rent/main?page=" + page;
	}
	
	@PostMapping("update")
	public String updateSubmit(RentProduct dto,
			@RequestParam(name = "page") String page,
			HttpSession session) throws Exception {
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			dto.setNum(info.getNum());
			dto.setNickname(info.getNickName());
			service.updateRentProduct(dto, uploadPath);
			
		} catch (Exception e) {
			log.info("updateSubmit : ", e);
		}
		return "redirect:/market/rent/main?page=" + page;
	}
	
	@ResponseBody
	@PostMapping("deleteFile")
	public Map<String, ?> deleteFile(@RequestParam(name = "ppnum") long fileNum,
			HttpSession session) throws Exception {
		Map<String, Object> model = new HashMap<>();
		
		String state = "false";
		
		try {
			RentProduct dto = Objects.requireNonNull(service.findByFileId(fileNum));
			
			service.deleteUploadFile(uploadPath, dto.getPpp());
			service.deleteUploadFile(uploadPath, dto.getPph());
			
			Map<String, Object> map = new HashMap<>();
			map.put("field", "ppnum");
			map.put("pnum", fileNum);
				
			service.deleteRentProductFile(map);
			
			state = "true";
			
		} catch (NullPointerException e) {
			log.info("deleteFile : ", e);
		} catch (Exception e) {
			log.info("deleteFile : ", e);
		}
		
		model.put("state", state);
		return model;
	}
	
	@GetMapping("delete")
	public String deleteProduct(@RequestParam(name = "pnum") long productNum,
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
			
			service.deleteRentProduct(productNum, uploadPath, info.getNum());
			
		} catch (Exception e) {
			log.info("deleteProduct : ", e);
		}
		
		return "redirect:/market/rent/main?" + query;
	}
	
	@ResponseBody
	@PostMapping("insertProductLike")
	public Map<String, ?> insertProductLike(
			@RequestParam(name = "pnum") long productNum,
			@RequestParam(name = "memberLiked") boolean memberLiked,
			HttpSession session) {
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		int productLikeCount = 0;
		
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			Map<String, Object> map = new HashMap<>();
			map.put("pnum", productNum);
			map.put("num", info.getNum());
			map.put("nickname", info.getNickName());
			
			if (memberLiked) {
				service.deleteMemberLikeProduct(map);
			} else {
				service.insertMemberLikeProduct(map); 
			}
			
			productLikeCount = service.productLikeCount(productNum);
			
		} catch (DuplicateKeyException e) {
			state ="liked";
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("state", state);
		model.put("productLikeCount", productLikeCount);
		
		return model;
	}
	
	@PostMapping("insertOrder")
	@ResponseBody
	public Map<String, Object> insertOrder(RentProductOrder dto, HttpSession session) {
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			dto.setNum(info.getNum());
			
			state = orderService.insertRentProductOrder(dto);
			
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("state", state);
		
		return model;
	}
}
