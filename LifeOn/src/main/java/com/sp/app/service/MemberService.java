package com.sp.app.service;

import java.util.Map;

import com.sp.app.model.Member;

public interface MemberService {
	public Member loginMember(String id);
	
	public void insertMember(Member dto) throws Exception;
	public void updateLastLogin(String id) throws Exception;

	public Member findById(String id);	
	public Member findByNickName(String id);
	
	public void updateMember(Member dto) throws Exception;
	public void deleteMember(Map<String, Object> map) throws Exception;
	
	public void updateMemberTel(Member dto) throws Exception;
	
	public Member findByTel(String tel1, String tel2, String tel3);
	
}
