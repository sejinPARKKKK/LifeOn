package com.sp.app.controller;

import com.sp.app.common.PaginateUtil;
import com.sp.app.model.LendingPage;
import com.sp.app.service.home.HomeService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@Slf4j
public class HomeController {

    private final PaginateUtil paginateUtil;
    private final HomeService homeService;

    @GetMapping("/")
    public ModelAndView handleHome() {
        ModelAndView mav = new ModelAndView("main/home");


        // TODO 지역정보 미완
        mav.addObject("interior", homeService.findByInterior());
        mav.addObject("event", homeService.findByEvent());
        mav.addObject("prizeMain", homeService.findByPrizeMain());
        mav.addObject("tip", homeService.findByTip());
//        mav.addObject("region", homeService.findByRegion());
        mav.addObject("regionMeeting", homeService.findByRegionMeeting());
        mav.addObject("policy", homeService.findByPolicy());



        return mav;
    }


}
