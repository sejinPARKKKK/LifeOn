package com.sp.app.rent.model;

import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class RentProduct {
	// 상품정보 통합테이블 PRODUCT
	private long pnum; // 상품번호 // PRODUCT_PICTURE
	private String ptype; // 상품유형 : 물품대여
	private String pname; // 상품명
	private String pct; // 상품내용
	private String pph; // 썸네일사진 : 파일경로저장
	private MultipartFile pphFile;
	
	private long num; // 회원번호
	private String nickname; // 회원닉네임
	private String profile_image; // 회원프로필
	
    // 찜개수 MEMBER_LIKED
    private int productLikeCount;
	
	@Value("-1") // 초기값
	private int memberLiked;
	
	// 카테고리 테이블
	// CATEGORY_BIG
	private long cbn; // 카테고리 대분류 번호 // CATEGORY_SMALL
	private String cbc; // 카테고리 대분류 상세
	
	// CATEGORY_SMALL
	private long csn; // 카테고리 소분류 번호 // PRODUCT
	private String csc; // 카테고리 소분류 상세
	
	// 하위 카테고리
	private List<RentProductSub> listSub;
	
	// 상품사진 테이블 PRODUCT_PICTURE
	private long ppnum; // 상품사진번호
	private String ppp; // 서버에 저장된 파일경로
	private List<MultipartFile> selectFile;
	
	// 물품대여 상품정보 PRODUCT_RENT
	private int prp; // 대여비(1일기준)
	private String prd; // 상품등록날짜 : SYSDATE(DEFAULT)
	
	private String prs; // 대여상태 : 대여가능, 대여중, 대여불가능
	private String pra; // 거래위치
	private String prad; // 거래상세주소
	
	private int prlp; // 보증금
}
