package com.sp.app.admin.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class Report {
	private long repnum; // 신고번호
	private String repr; // 신고내용
	private String repd; // 신고날짜
	private long repan; // 신고게시글번호
	private int repat; // 신고게시글테이블
	private long num; // 회원번호
	
	private String nickname; // 닉네임
	private String repsucees; //신고처리일
	private String repsucboolean; //신고처리여부
}
