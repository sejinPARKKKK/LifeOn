package com.sp.app.mapper;

import com.sp.app.auction.response.prize.PrizeDetailRep;
import com.sp.app.mypage.controller.dto.request.SellerRequest;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface SellerMapper {
    void  insertPrize(SellerRequest dto);

    List<PrizeDetailRep>findBySellerList(Map<String, Object> userId);

    void insertFile(SellerRequest dto);

    int dataCount(Map<String, Object> map);


    void deleteSeller(long map);

    List<PrizeDetailRep> findByPictureList(long num);


}
