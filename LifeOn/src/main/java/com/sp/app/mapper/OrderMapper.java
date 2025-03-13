package com.sp.app.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.model.Order;
import com.sp.app.model.PointRecord;

@Mapper
public interface OrderMapper {
	public void insertOrder(Order dto);
	public void insertOrderDetail(Order dto);
	
	public int getTotalOdq(long pnum);
	
	public int dataCount(Map<String, Object> map);
	public List<Order> listOrder(Map<String, Object> map);
}
