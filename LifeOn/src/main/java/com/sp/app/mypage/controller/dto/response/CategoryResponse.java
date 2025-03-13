package com.sp.app.mypage.controller.dto.response;

import com.sp.app.auction.vo.CategoryBig;
import com.sp.app.auction.vo.CategorySmall;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class CategoryResponse {

    List<CategoryBig> bigCategory;
    List<CategorySmall> smallCategory;


}
