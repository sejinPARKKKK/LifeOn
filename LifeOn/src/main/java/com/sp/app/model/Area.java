package com.sp.app.model;

import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class Area {
	private long rvnum; // 글번호
    private long num; // 회원번호
    private String id; 
    private String thp; // 썸네일사진
    private MultipartFile thpFile;
    
	private long fnum; // 파일번호
	private String ssfname; // 서버에 저장된 파일경로
	private List<MultipartFile> selectFile;
    
    private String nickname; 
    private String profile_image;
	private String rvsubject;
	private String rssubject;// 서브제목
	private String rvcontent;
	private String rvreg_date;
	private int blind;
	
	private int lnum; // 지하철역 노선
	private String ssname;
	
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
