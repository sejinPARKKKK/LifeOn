package com.sp.app.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.model.Member;

@Mapper
public interface MemberManageMapper {
	public List<Member> listMembers(Map<String, Object> map);
	public int dataCount(Map<String, Object> map);
	
	//회원 활성화상태와 수정일자 반영
	int updateMemberAuthority(Map<String, Object> map);
}
