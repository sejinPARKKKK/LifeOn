package com.sp.app.admin.model;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ProductManage {	
	//상품정보 통합TAB
	private long pnum; //상품번호
	private String ptype; //공동구매
	private String pname; //상품명
	private String pct; //상품내용
	private String pph; //썸네일사진
	private MultipartFile pphFile;
	
	//카테고리TAB
	private int cbn; //카테고리 대번호
	private String cbc; //카테고리 대내용
	private int csn; //카테고리 소번호
	private String csc;//카테고리 소내용
	
	//상품사진TAB
	private long ppnum; //상품사진번호
	private String ppp; //서버에저장된파일경로

	// 스프링에서 파일 받기
	private List<MultipartFile> pppFile; // <input type="file" name="selectFile"

	//공동구매 - 상품재고
	private String ptsc; //업체명
	private int ptsq; //재고량
	private String ptst; //유형(상품등록)
	
	//공동구매 - 상품정보
	private int ptp; //상품원가
	private int ptsp; //상품할인가
	private int pttq; //목표수량
	private int ptq; //상품남은수량
	private String ptd; //상품등록날짜(SYSDATE)
	private String ptsd; //시작날짜
	private String pted; //종료날짜
	private String ptdd; //예상발송일
	private String status;   // 진행전, 진행중, 구매실패, 구매성공
	
	private String asRegister; // Y/N 재고에는 등록되었지만 공동구매에 등록된 상품인지 아닌지 확인하기 위한 컬럼
	
	private int totalOdq; //팔린수량
	private boolean liked; //관심상품
	
}
