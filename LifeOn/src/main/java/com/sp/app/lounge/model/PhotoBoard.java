package com.sp.app.lounge.model;

import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class PhotoBoard {
	private long psnum; // 글번호
    private long num; // 회원번호
    private String id; 
    private String nickname; 
    private String profile_image;
	private String subject;
	private String content;
	private String thumbnail;
	private String ipaddr;
	private String bdtype;
	private String reg_date;
	private int blind;
	
	private int hitCount;
	private int boardLikeCount;
	private int replyCount;
	
	private long fnum;
	private String ssfname; // 서버 저장 파일명
	private String cpfname; // 클라이언트가 올린 파일
	private  List<MultipartFile> selectFile;
	
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
