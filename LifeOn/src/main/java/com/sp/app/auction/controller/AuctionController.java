package com.sp.app.auction.controller;

import com.sp.app.auction.response.category.AllCategoryResponse;
import com.sp.app.auction.response.category.BigCategoryResponse;
import com.sp.app.auction.response.prize.PrizeDetailRep;
import com.sp.app.auction.service.AuctionServiceInterface;
import com.sp.app.common.PaginateUtil;
import com.sp.app.model.SessionInfo;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/auction")
@RequiredArgsConstructor
public class AuctionController {

    private final AuctionServiceInterface auctionService;
    private final PaginateUtil paginateUtil;

    //TODO: 검색어 입력 처리동작 미완
    @GetMapping("")
    public ModelAndView moveMain(@RequestParam(value = "page", required = false, defaultValue = "1") int page,
                                 HttpServletRequest req,
                                 HttpSession session) {
        ModelAndView mav = new ModelAndView("auction/auction_main");
        try {

            SessionInfo member = (SessionInfo) session.getAttribute("member");

            int size = 12;
            Map<String, Object> paginationMap = calculatePagination(new HashMap<>(), size, page, req, "auction");

            AllCategoryResponse allCategory = auctionService.findByAllCategory(paginationMap);
            allCategory.setCategoryType("all");


            String userId = (member != null) ? String.valueOf(member.getNum()) : "none";
            mav.addObject("userId", userId);
            mav.addObject("dataCount", paginationMap.get("dataCount"));
            mav.addObject("paging", paginationMap.get("paging"));
            mav.addObject("page", paginationMap.get("current_page"));
            mav.addObject("size", paginationMap.get("size"));
            mav.addObject("category", allCategory);

        }catch (Exception e) {
            log.error("error", e);
        }

        return mav;
    }

    //TODO: 카테고리 검색어 입력시 처리동작 처리 미완
    @GetMapping("/category")
    public ModelAndView moveCategory(@RequestParam(value = "cbn", required = false, defaultValue = "0") long cbn,
                                     @RequestParam(value = "categoryType", required = false, defaultValue = "") String categoryType,
                                     @RequestParam(value = "categoryBName", required = false, defaultValue = "") String categoryBName,
                                     @RequestParam(value = "categoryName", required = false, defaultValue = "") String categoryName,
                                     @RequestParam(value = "searchType", required = false, defaultValue = "") String searchType,
                                     @RequestParam(value = "searchTerm", required = false, defaultValue = "") String searchTerm,
                                     @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                                     HttpServletRequest req,
                                     HttpSession session) {
        ModelAndView mav = new ModelAndView("auction/auction_main");
        Map<String, Object> map = new HashMap<>();
        int size = 12;
        try {

            SessionInfo member = (SessionInfo) session.getAttribute("member");
            String userId = (member != null) ? String.valueOf(member.getNum()) : "none";
            mav.addObject("userId", userId);

            categoryBName = URLDecoder.decode(categoryBName, StandardCharsets.UTF_8);
            categoryType = URLDecoder.decode(categoryType, StandardCharsets.UTF_8);
            categoryName = URLDecoder.decode(categoryName, StandardCharsets.UTF_8);
            searchType = URLDecoder.decode(searchType, StandardCharsets.UTF_8);
            searchTerm = URLDecoder.decode(searchTerm, StandardCharsets.UTF_8);

            if (categoryType.equals("all")) {
                Map<String, Object> paginationMap = calculatePagination(new HashMap<>(), size, page, req, "auction");

                AllCategoryResponse categories = auctionService.findByAllCategory(paginationMap);
                return mav.addObject("category", setCategoryResponse(categories, "all", null,null, 0));
            } else {
                map.put("categoryType", categoryType);

                if (categoryType.equals("big")) {
                    map.put("cbn", cbn);
                    Map<String, Object> paginationMap = calculatePagination(map, size, page,req,"auction/category");
                    map.putAll(paginationMap);
                    BigCategoryResponse categories = auctionService.findByAllCategoryBig(map);
                    if (categoryName.equals("전체")) {
                        categoryName = categoryBName;
                    }
                    mav.addObject("dataCount", paginationMap.get("dataCount"));
                    mav.addObject("paging", paginationMap.get("paging"));
                    mav.addObject("page", paginationMap.get("current_page"));
                    mav.addObject("size", paginationMap.get("size"));

                    return mav.addObject("category", setCategoryResponse(categories, "big",categoryName, categoryName, (int) cbn));
                } else if (categoryType.equals("small")) {
                    map.put("cbn", cbn);
                    map.put("csc", categoryName);
                    Map<String, Object> paginationMap = calculatePagination(map, size, page,req,"auction/category");
                    map.putAll(paginationMap);
                    BigCategoryResponse categories = auctionService.findByAllCategoryBig(map);
                    mav.addObject("dataCount", paginationMap.get("dataCount"));
                    mav.addObject("paging", paginationMap.get("paging"));
                    mav.addObject("page", paginationMap.get("current_page"));
                    mav.addObject("size", paginationMap.get("size"));
                    return mav.addObject("category", setCategoryResponse(categories, "small", categoryBName,categoryName, (int) cbn));
                }

            }

        } catch (Exception e) {
            log.error("error", e);
        }

        return mav;

    }



    @GetMapping("/prizeDetail")
    public ModelAndView detail(@RequestParam("pnum") int pnum,HttpSession session) {
        Map<String, Object> map = new HashMap<>();
        ModelAndView mav = new ModelAndView("auction/auction_detail");
        try {
            SessionInfo member = (SessionInfo) session.getAttribute("member");
            String userId = (member != null) ? String.valueOf(member.getNum()) : "none";
            mav.addObject("userId", userId);
            map.put("pnum", pnum);
            PrizeDetailRep rep = auctionService.findByPrize(map);
            mav.addObject("prize", rep);

        }catch (Exception e) {
            log.error("error", e);
        }

        return mav;
    }

    @PostMapping("/bidding")
    public String biddingMoney(@RequestParam("prizeId") int pnum,
                             @RequestParam("price") int price,
                             HttpSession session) {
        Map<String, Object> map = new HashMap<>();
        String result = "";
        try {
            SessionInfo member = (SessionInfo) session.getAttribute("member");
            String userId = (member != null) ? String.valueOf(member.getNum()) : "none";
            map.put("pnum", pnum);
            map.put("price", price);
            map.put("userId", userId);
            map.put("type", "입찰");
            result = auctionService.biddingMoney(map);

        }catch (Exception e) {
            log.error("error", e);
            return "입찰에 실패했습니다. 다시 시도해주세요.";
        }
        return result;
    }



    private Map<String, Object> calculatePagination(Map<String, Object> map, int size, int current_page,HttpServletRequest req,String url) {
        Map<String, Object> paginationMap = new HashMap<>();
        int total_page = 0;
        int dataCount = auctionService.dataCount(map);
        if (dataCount != 0) {
            total_page = paginateUtil.pageCount(dataCount, size);
        }

        current_page = Math.min(current_page, total_page);

        int offset = (current_page - 1) * size;
        if (offset < 0) offset = 0;

        String cp = req.getContextPath();
        String query = "page=" + current_page;
        String listUrl = cp + "/" + url ;

        String paging = paginateUtil.paging(current_page, total_page, listUrl);

        paginationMap.put("offset", offset);
        paginationMap.put("size", size);
        paginationMap.put("paging", paging);
        paginationMap.put("dataCount", dataCount);
        paginationMap.put("current_page", current_page);
        paginationMap.put("total_page", total_page);

        return paginationMap;
    }





    private <T> T setCategoryResponse(T categoryResponse, String categoryType,String categoryBigName ,String categoryName, int cbn) {
        if (categoryResponse instanceof AllCategoryResponse) {
            ((AllCategoryResponse) categoryResponse).setCategoryType(categoryType);
            ((AllCategoryResponse) categoryResponse).setCbn(cbn);
        } else if (categoryResponse instanceof BigCategoryResponse) {
            ((BigCategoryResponse) categoryResponse).setCategoryType(categoryType);
            ((BigCategoryResponse) categoryResponse).setCategoryBigName(categoryBigName);
            ((BigCategoryResponse) categoryResponse).setCategoryName(categoryName);
            ((BigCategoryResponse) categoryResponse).setCbn(cbn);
        }
        return categoryResponse;
    }



}
