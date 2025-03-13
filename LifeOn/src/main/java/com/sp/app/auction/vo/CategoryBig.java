package com.sp.app.auction.vo;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Builder
public class CategoryBig {

    private int cbn;

    private String cbc;

    public CategoryBig(int cbn, String cbc) {
        this.cbn = cbn;
        this.cbc = cbc;
    }


}
