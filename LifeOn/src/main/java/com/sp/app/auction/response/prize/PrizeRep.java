package com.sp.app.auction.response.prize;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class PrizeRep {

    private long pnum;
    private long smallNum;
    private long bigNum;

    private String thumbnail;
    private String prName;
    private String stDate;
    private String edDate;
    private String prStatus;
    private String sellerName;
    private String tradeType;
    private int finalP;
    private int price;


}
