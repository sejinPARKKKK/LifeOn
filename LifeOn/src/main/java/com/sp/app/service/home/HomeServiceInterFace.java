package com.sp.app.service.home;

import com.sp.app.model.LendingPage;

import java.util.List;
import java.util.Map;

public interface HomeServiceInterFace {

    List<LendingPage> findByInterior();
    List<LendingPage> findByEvent();
    List<LendingPage> findByTip();

    List<LendingPage> findByPrizeMain();
    List<LendingPage> findByRegion();
    List<LendingPage> findByRegionMeeting();

    List<LendingPage> findByPolicy();


}
