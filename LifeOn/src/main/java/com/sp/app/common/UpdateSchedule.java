package com.sp.app.common;

import com.sp.app.auction.response.prize.PrizeDetailRep;
import com.sp.app.auction.response.prize.PrizeRep;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class UpdateSchedule {


    public boolean updatePrize(String date) {

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        LocalDateTime resultDate = LocalDateTime.parse(date.substring(0, 16), formatter);
        // 현재 날짜와 시간
        LocalDateTime currentDateTime = LocalDateTime.now();

        if (currentDateTime.isBefore(resultDate)) {
            return false;
        } else return currentDateTime.isAfter(resultDate);

    }

}
