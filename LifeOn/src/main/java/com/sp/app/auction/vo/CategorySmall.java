package com.sp.app.auction.vo;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Builder
public class CategorySmall {
    
    private int csn;
    private String csc;
    private int cbn;
    
    
    public CategorySmall(int csn, String csc, int cbn) {
        this.csn = csn;
        this.csc = csc;
        this.cbn = cbn;
    }
    

    @Override
    public String toString() {
        return "CategorySmall{" +
                "categorySmallId=" + csn +
                ", categorySmallName='" + csc + '\'' +
                ", categoryBigId=" + cbn +
                '}';
    }
    
}
