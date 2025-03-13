package com.sp.app.model;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class PolicyBoard {

	private long psnum;
	private String subject;
	private String content;
	private String reg_date;
	private int hitcount;
	private String userId;
	private String nickname;
	
	private String savefilename;
	private String originalfilename;
	private int block;
	private MultipartFile selectFile;
	
	private int boardLikeCount;
}
