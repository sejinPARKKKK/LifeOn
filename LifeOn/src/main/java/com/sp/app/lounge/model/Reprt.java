package com.sp.app.lounge.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class Reprt {
	// REPORT
	private long repnum; // 신고번호
	private String repr; // 신고사유
	private String repd; // 신고등록일
	
	private long repan; // 신고된 게시글 글번호 psnum
	private int repat;// 신고된 게시글 카테고리
	
	private long num; // 회원번호
}
