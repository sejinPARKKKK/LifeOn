package com.sp.app.auction.service;

import com.sp.app.auction.response.category.AllCategoryResponse;
import com.sp.app.auction.response.category.BigCategoryResponse;
import com.sp.app.auction.response.prize.PrizeDetailRep;
import com.sp.app.auction.response.prize.PrizeRep;

import java.util.List;
import java.util.Map;

public interface AuctionServiceInterface {

    String biddingMoney(Map<String, Object> map);

    AllCategoryResponse findByAllCategory(Map<String, Object> paginationMap);

    BigCategoryResponse findByAllCategoryBig(Map<String, Object> map);

    PrizeDetailRep findByPrize(Map<String, Object> map);


    int dataCount(Map<String, Object> map);

    void updatePrizeStatus(Map<String, Object> map);
    Long findByUserId(Map<String, Object> map);
}
