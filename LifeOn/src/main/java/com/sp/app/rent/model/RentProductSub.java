package com.sp.app.rent.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class RentProductSub {
	private long csn; // 카테고리 소분류 번호
	private String csc; // 카테고리 소분류 상세
}
