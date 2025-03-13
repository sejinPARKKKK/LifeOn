package com.sp.app.service;


import java.util.List;
import java.util.Map;

import com.sp.app.model.Member;

public interface MemberManageService {
	List<Member> listMembers(Map<String, Object> map);
	int dataCount(Map<String, Object> map);
	
	int updateMemberAuthority(Map<String, Object> map);
}
