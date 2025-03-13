package com.sp.app.auction.response.category;

import com.sp.app.auction.response.prize.PrizeRep;
import com.sp.app.auction.vo.CategoryBig;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class AllCategoryResponse {
    private long cbn;
    private List<CategoryBig> categoryList;
    private String categoryName;
    private String categoryType;
    private List<List<PrizeRep>> prizeList;


    public AllCategoryResponse() {
    }

    public AllCategoryResponse(List<List<PrizeRep>> prizeList) {
        this.prizeList = prizeList;
    }
}
