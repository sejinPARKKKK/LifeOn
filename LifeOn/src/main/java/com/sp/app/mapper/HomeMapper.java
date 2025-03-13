package com.sp.app.mapper;

import com.sp.app.model.LendingPage;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface HomeMapper {


    List<LendingPage> findByInterior();
    List<LendingPage> findByEvent();
    List<LendingPage> findByTip();

    List<LendingPage> findByPrizeMain();
    List<LendingPage> findByRegion();
    List<LendingPage> findByRegionMeeting();

    List<LendingPage> findByPolicy();


}
