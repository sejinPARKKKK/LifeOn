package com.sp.app.admin.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.sp.app.admin.mapper.VisitorLogMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class VisitorLogServiceImpl implements VisitorLogService {

	private final VisitorLogMapper visitorLogMapper;

	@Override
	public int countTotalMembers() {
		return visitorLogMapper.countTotalMembers();
	}

	@Override
	public int countTodayNewMembers() {
		return visitorLogMapper.countTodayNewMembers();
	}

	@Override
	public List<Map<String, Object>> MemberAgeDistribution() {
		return visitorLogMapper.MemberAgeDistribution();
	}

	@Override
	public List<Map<String, Object>> getGenderRatio() {
		return visitorLogMapper.getGenderRatio();

	}
	
	
}
