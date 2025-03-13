package com.sp.app.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class Order {
	//주문테이블
	private long onum; //주문번호
	private String od; //주문일시
	private int op; //총금액
	private int odpp; //배송금액
	private int oup; //사용한포인트
	private int ofp; //최종결제금액
	private String os; //주문상태
	private long num; //회원번호
	
	//주문상세 테이블
	private long odnum; // 주문상세번호
	private int odq; //구매수량
	private int odp; //상품 가격
	private int ods; //주문상세상태
	private long pnum; //상품번호
	
	
	//총포인트
	private int totalPoint;
	
	private String pname; //상품명
	private String pph;// 상품썸네일사진
	
}
