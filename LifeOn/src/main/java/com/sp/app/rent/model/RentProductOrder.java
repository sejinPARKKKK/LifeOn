package com.sp.app.rent.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class RentProductOrder {
	private long num; // 회원번호
	private long pnum; // 상품번호 // ORD_DETAIL
	
	// POINT_RECORD
	private int memberPoint; // 회원 잔여포인트
	private long sellerNum; // 판매자 회원번호
	
	private long prnum; // 포인트내역번호
	private String prec; // 적요
	private String pret; // 유형
	private int prep; // 발생포인트
	private int pretp; // 남은 총 포인트
	private String prepd; // 포인트 발생일 : SYSDATE(DEFAULT)
	
	// 주문 ORD
	private long onum; // 주문번호 // ORD_DETAIL // ORD_PRODCUT_RENT
	private String od; // 주문일시 : SYSDATE(DEFAULT)
	private int op; // 총금액 (대여비 + 보증금)
	private int odpp; // 배송금액
	private int oup; // 사용한포인트
	private int ofp; // 최종결제금액
	private String os; // 주문상태 (결제전, 결제완료)
	
	// 주문 상세 ORD_DETAIL
	private long odnum; // 주문상세번호
	private int odq; // 구매수량 (대여일)
	private int odp; // 상품가격 (1일 대여비)
	private int ods; // 주문상세상태 : 0(DEFAULT)
	
	// 물품대여 주문 ORD_PRODCUT_RENT
	private String opsd; // 대여시작일
	private String oped; // 대여종료일
	
	private String oprs; // 회원대여상태 : 대여대기, 대여중, 반납
	
	private String prs; // 물품대여상태 : 대여가능, 대여중, 대여불가능
	private String pname; // 물품명
	private String pph; // 썸네일사진
	private int prp; // 대여비(1일기준)
	private int prlp; // 보증금
	private String renter; // 대여자닉네임
	
	private int oplp; // 납부보증금
	// 대여종료일 후 반납하지 않고 연락 두절인 경우 판매자에게 주는 금액
	private String opld; // 연체기간
	// 대여종료일 후 반납하지 않을 경우 일자를 저장하여 그 기간만큼 1일 대여비를 환불받을 보증금에서 제외
}
