package com.sp.app.admin.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sp.app.admin.model.Report;

@Mapper
public interface ReportMapper {
	
	public List<Report> listReport(Map<String, Object> map);
	public int dataCount(Map<String, Object> map);

	
	public List<Map<String, Object>> findReportDetail(@Param("repan") Long repan);
	
	public int deletePost(@Param("psnum") Long psnum) throws SQLException;
	
	public int updateStatus(@Param("repan") String repan, @Param("repsucboolean") String repsucboolean, @Param("repsucees") String repsucees);
	
}
