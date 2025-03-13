package com.sp.app.admin.service;


import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.sp.app.admin.mapper.ReportMapper;
import com.sp.app.admin.model.Report;


import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class ReportServiceImpl implements ReportService {
	private final ReportMapper mapper;

	@Override
	public List<Report> listReport(Map<String, Object> map) {
		List<Report> list = null;
		
		try {
			list = mapper.listReport(map);
		} catch (Exception e) {
			log.info("listReport : ", e);
		}
		
		
		return list;
	}

	@Override
	public int dataCount(Map<String, Object> map) {
		int result = 0;
		try {
			result = mapper.dataCount(map);
		} catch (Exception e) {
			log.info("dataCount : ", e);
		}
		return result;
	}

	@Override
	public Map<String, Object> getReportDetail(Long repan) {
		List<Map<String, Object>> reportDetail = mapper.findReportDetail(repan);
		
		
		if(reportDetail == null || reportDetail.isEmpty()) {
			return null;
		}
		
		return reportDetail.get(0);
	}

	@Override
	public int deletePost(Long psnum) throws Exception {
		int result = 0;
		try {
			result = mapper.deletePost(psnum);
		} catch (Exception e) {
			log.info("result : " , e);
		}
		
		return result;
	}

	@Override
	public boolean updateStatus(String repan, String repsucboolean, String repsucees) {
		try {
			int updateRows = mapper.updateStatus(repan, repsucboolean, repsucees);
			
			if(updateRows > 0 ) {
				System.out.println(updateRows + "행 업데이트 성공");
				return true;
			} else {
				System.out.println(updateRows + "행 업데이트 실패");
				return false;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	
	
	
}
