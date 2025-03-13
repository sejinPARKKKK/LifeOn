package com.sp.app.mypage.controller;

import com.sp.app.auction.response.prize.PrizeDetailRep;
import com.sp.app.common.MyUtil;
import com.sp.app.common.PaginateUtil;
import com.sp.app.common.StorageService;
import com.sp.app.model.SessionInfo;
import com.sp.app.mypage.controller.dto.request.SellerRequest;
import com.sp.app.mypage.controller.dto.response.CategoryResponse;
import com.sp.app.mypage.service.SellerServiceInterFace;
import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/mypage/seller")
@RequiredArgsConstructor
@Slf4j
public class SellerController {

    private final SellerServiceInterFace sellerService;
    private final StorageService storageService;
    private final PaginateUtil paginateUtil;
    private final MyUtil myUtil;

    private String uploadPath;

    @PostConstruct
    public void init() {
        uploadPath = storageService.getRealPath("/uploads/seller");
    }

    @GetMapping("/info")
    public ModelAndView main(
            @RequestParam(name = "page", defaultValue = "1") int current_page,
            @RequestParam(name = "stDate", defaultValue = "") String stDate,
            @RequestParam(name = "edDate", defaultValue = "") String edDate,
            @RequestParam(name = "tradeType", defaultValue = "all") String tradeType,
            HttpSession session, HttpServletRequest req) {
        ModelAndView mav = new ModelAndView("mypage/seller/seller_main");
        Map<String, Object> map = new HashMap<>();
        try {

            SessionInfo info = (SessionInfo) session.getAttribute("member");
            long userId = info.getNum();
            map.put("userId", userId);

            int size = 5;
            int total_page = 0;
            int dataCount = 0;

            map.put("stDate", stDate);
            map.put("edDate", edDate);
            map.put("tradeType", tradeType);

            dataCount = sellerService.dataCount(map);
            total_page = paginateUtil.pageCount(dataCount, size);
            current_page = Math.min(current_page, total_page);

            int offset = (current_page - 1) * size;
            if (offset < 0) offset = 0;

            map.put("offset", offset);
            map.put("size", size);

            String cp = req.getContextPath();
            String listUrl = cp + "/admin/productManage/list";
            String query = "page=" + current_page;


            List<PrizeDetailRep> prizeRep = sellerService.findBySellerList(map);

            String paging = paginateUtil.paging(current_page, total_page, listUrl);

            mav.addObject("stDate", stDate);
            mav.addObject("edDate", edDate);
            mav.addObject("prizeList", prizeRep);
            mav.addObject("dataCount", dataCount);
            mav.addObject("size", size);
            mav.addObject("page", current_page);
            mav.addObject("total_page", total_page);
            mav.addObject("paging", paging);


            mav.addObject("query", query);


        } catch (Exception e) {
            log.info("main : ", e);
            mav = new ModelAndView("redirect:/member/login");
            return mav;
        }

        return mav;
    }

    @GetMapping("/registration")
    public ModelAndView registrationPage() {
        ModelAndView mav = new ModelAndView("mypage/seller/auction/auction_registration");

        CategoryResponse respList = sellerService.findByAllCategory();


        mav.addObject("category", respList);
        mav.addObject("mode", "write");

        return mav;
    }

    @PostMapping("/write")
    public ModelAndView writeSubmit(SellerRequest dto,
                                    HttpSession session, HttpServletRequest req) throws Exception {
        ModelAndView mav = new ModelAndView();
        try {
            SessionInfo info = (SessionInfo) session.getAttribute("member");

            dto.setUserId(info.getNum());
            sellerService.insertPrize(dto, uploadPath);

        } catch (Exception e) {
            log.info("writeSubmit : ", e);
        }

        mav.setViewName("redirect:/mypage/seller/info");
        return mav;
    }


    // TODO 판매 수정
    // 이미지 교체 추가해야함
    @GetMapping("/update")
    public ModelAndView registrationUpdatePage(@RequestParam(name = "pnum") long pNum, HttpSession session) {

        ModelAndView mav = new ModelAndView("mypage/seller/auction/auction_registration");
        SessionInfo info = (SessionInfo) session.getAttribute("member");

        long userId = info.getNum();

        CategoryResponse respList = sellerService.findByAllCategory();

        Map<String, Object> map = new HashMap<>();
        map.put("userId", userId);
        map.put("pnum", pNum);

        PrizeDetailRep prizeDetailRep = sellerService.findBySellerDetail(map);
        // TODO 이미지 파일 가져오기

        mav.addObject("prize", prizeDetailRep);
        mav.addObject("category", respList);
        mav.addObject("mode", "update");

        return mav;
    }

    @PostMapping("/seller-update")
    public ModelAndView registrationUpdate(@RequestParam(name = "pnum") long pNum, HttpSession session) {
        ModelAndView mav = new ModelAndView("redirect:/mypage/seller/info");

        return mav;       
    }


    // TODO  판매 삭제
    // TODO 사진 삭제 추가해야함
    @GetMapping("/seller-delete")
    public ModelAndView deleteSeller(@RequestParam(name = "pnum") long pNum) {

        ModelAndView mav = new ModelAndView("redirect:/mypage/seller/info");
        try {
            sellerService.deleteSeller(pNum,uploadPath);
        } catch (Exception e) {
            log.info("deleteSeller : ", e);

        }

        return mav;
    }


    // TODO 낙찰처리 시스템
    @PostMapping("/bidding")
    public ModelAndView biddingSeller(@RequestParam(name = "pnum") long pNum, HttpSession session) {

        ModelAndView mav = new ModelAndView("mypage/seller/auction/auction_registration");
        SessionInfo info = (SessionInfo) session.getAttribute("member");

        long userId = info.getNum();

        CategoryResponse respList = sellerService.findByAllCategory();

        Map<String, Object> map = new HashMap<>();
        map.put("userId", userId);
        map.put("pNum", pNum);

        mav.addObject("category", respList);
        mav.addObject("mode", "update");

        return mav;
    }



    @GetMapping("/deleteFile")
    public void fileDelete(){
        sellerService.deleteFileEM(uploadPath);
    }


}
