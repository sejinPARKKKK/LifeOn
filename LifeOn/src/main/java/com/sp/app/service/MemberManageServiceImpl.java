package com.sp.app.service;


import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;


import com.sp.app.mapper.MemberManageMapper;
import com.sp.app.model.Member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class MemberManageServiceImpl implements MemberManageService {
	private final MemberManageMapper mapper;
	
	@Override
	public List<Member> listMembers(Map<String, Object> map) {
		List<Member> list = null;
		
		try {
			list = mapper.listMembers(map);
			
		} catch (Exception e) {
			log.info("listMembers : ", e);
		}
		
		return list;
	}

	@Override
	public int dataCount(Map<String, Object> map) {
		int result = 0;
		try {
			result = mapper.dataCount(map);
			
		} catch (Exception e) {
			log.info("dataCount:" , e);
		}
		return result;
	}

	@Override
	public int updateMemberAuthority(Map<String, Object> map) {
		int result = 0;
		try {
			result = mapper.updateMemberAuthority(map);
			
		} catch (Exception e) {
			log.error("updateMemberAuthority error: ", e);
		}
		return result;
	}

}
