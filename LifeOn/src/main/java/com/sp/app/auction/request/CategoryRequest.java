package com.sp.app.auction.request;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class CategoryRequest {
    private long cbn;
    private int current_page = 1;
    private String categoryType;
    private String categoryName;
    private String searchType;
    private String searchTerm;


}
