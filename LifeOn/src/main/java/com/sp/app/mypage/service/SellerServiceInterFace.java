package com.sp.app.mypage.service;

import com.sp.app.auction.response.prize.PrizeDetailRep;
import com.sp.app.mypage.controller.dto.request.SellerRequest;
import com.sp.app.mypage.controller.dto.response.CategoryResponse;

import java.util.List;
import java.util.Map;

public interface SellerServiceInterFace {

    CategoryResponse findByAllCategory();

    void insertPrize(SellerRequest dto, String uploadPath) throws Exception;

    List<PrizeDetailRep> findBySellerList(Map<String, Object> userId);

    int dataCount(Map<String, Object> map) throws Exception;

    PrizeDetailRep findBySellerDetail(Map<String, Object> map);

    void deleteSeller(long map,String upPath) throws Exception;

    void deleteFileEM(String upPath);
}
