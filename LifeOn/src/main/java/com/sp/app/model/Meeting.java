package com.sp.app.model;

import org.springframework.beans.factory.annotation.Value;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class Meeting {
	private long psnum; // 글번호
    private long num; // 회원번호
    private String id; 
    
    private String nickname; 
    private String profile_image;
	private String subject;
	private String content;
	private String ies;
	private String loca;
	private String loca_d;
	private String gender;
	private String age;
	private String person_c;
	private String idaddr;
	private String reg_date;
	private String mdate;
	private int blind;
	
	private int cbn;
	private String cbc;
	
	private int hitCount;
	private int boardLikeCount;
	private int replyCount;
	
	private long rpnum; 
	private String rpcontent; 
	private String rpreg_date; 
	private int rpblind; // 0: Default, 1: 블라인드처리
	private int rplike; // 0 싫어요 1 좋아요
	 
	private int likeCount;
	private int disLikeCount;
	
	@Value("-1") // 초기값
	private int memberLiked;
	
}
