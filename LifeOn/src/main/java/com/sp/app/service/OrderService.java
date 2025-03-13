package com.sp.app.service;

import java.util.List;
import java.util.Map;

import com.sp.app.model.Order;

public interface OrderService {
	public void insertOrder(Order dto) throws Exception;
	
	public List<Order> listOrder(Map<String, Object> map);
	public int dataCount(Map<String, Object> map);
}
