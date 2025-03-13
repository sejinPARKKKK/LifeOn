package com.sp.app.mapper;

import java.sql.SQLException;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sp.app.model.Member;

@Mapper
public interface MemberMapper {
	public Member loginMember(String id);
	
	public void updateLastLogin(String id) throws SQLException;
	
	public void insertMember(Member dto) throws SQLException;
	public void insertMemberDetail(Member dto) throws SQLException;
	
	//public void updateMemberEnabled(Map<String, Object> map) throws SQLException; 시큐리티 안써서 필요없을듯.
	
	//public void updateMemberGrade(Map<String, Object> map) throws SQLException;
	
	public void updateMember(Member dto) throws SQLException;
	public void updateMemberDetail(Member dto) throws SQLException;
	
	public Member findById(String id);
	public Member findByNickName(String nickName);
	
	public void deleteMember(Map<String, Object> map) throws SQLException;
	public void deleteMemberDetail(Map<String, Object> map) throws SQLException;
	
	public Member findByTel( @Param("tel1") String tel1, @Param("tel2") String tel2, @Param("tel3") String tel3 ); //매개변수 2개 이상일 경우에는 @Param 붙여야됨
	
	
}
