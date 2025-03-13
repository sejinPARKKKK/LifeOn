package com.sp.app.admin.service;

import java.util.List;
import java.util.Map;

import com.sp.app.admin.model.Report;


public interface ReportService {
	public List<Report> listReport(Map<String, Object>map);
	public int dataCount(Map<String, Object> map);

	
	
	public Map<String, Object> getReportDetail(Long repan);
	
	public int deletePost(Long psnum) throws Exception;
	
	boolean updateStatus(String repan, String repsucboolean, String repsucess);
}
