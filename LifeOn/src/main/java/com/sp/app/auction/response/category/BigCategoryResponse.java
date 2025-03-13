package com.sp.app.auction.response.category;

import com.sp.app.auction.response.prize.PrizeRep;
import com.sp.app.auction.vo.CategorySmall;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class BigCategoryResponse {
    private long cbn;
    private List<CategorySmall> categoryList;
    private String categoryType;
    private String categoryBigName;
    private String categoryName;
    private List<List<PrizeRep>> prizeList;



}
