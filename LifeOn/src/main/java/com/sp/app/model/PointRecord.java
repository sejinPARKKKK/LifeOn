package com.sp.app.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class PointRecord {
	long prnum; //포인트내역번호
	String prec; //적요
	String pret; //유형 1.적립 2.사용 3.충전
	int prep; //발생포인트
	int pretp; //총포인트
	String prepd; //포인트발생일
	String prevd; //유효기간
	long num; //회원번호
}
