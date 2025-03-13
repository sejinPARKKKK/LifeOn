package com.sp.app.model;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class Member {
	
	//회원테이블
	private long num;
	private String id;
	private String pwd;
	private String nickName;
	private int block;
	private String reg_date;
	private String mod_date;
	private String last_login; 
	private int grade;
	private int enabled;
	private String profile_image;
	private MultipartFile profileImageFile;
	
	
	//회원상세테이블
	private String name;
	private String gender;
	private String birth;
	private String email1;
	private String email2;
	private String tel1;
	private String tel2;
	private String tel3;
	private String addr1;
	private String addr2;
	private int post;
}
