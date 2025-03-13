package com.sp.app.auction.response.prize;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class PrizeDetailRep {

    private long pnum;
    private String thumbnail;
    private String prName;

    private String sellerName;

    private String upToDate;
    private String stDate;
    private String edDate;

    private String prStatus;
    private String tradeType;

    private int finalP;
    private int price;

    private String prContent;

    private List<String> prImgList;



}
