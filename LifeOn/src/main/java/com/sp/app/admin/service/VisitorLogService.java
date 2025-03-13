package com.sp.app.admin.service;

import java.util.List;
import java.util.Map;

public interface VisitorLogService {

	//총 회원수
	int countTotalMembers();
	
	//오늘 가입자 
	int countTodayNewMembers();
	
	//회원 연령대
	List<Map<String, Object>> MemberAgeDistribution();
	
	//남녀 성비
	List<Map<String, Object>> getGenderRatio();
}
