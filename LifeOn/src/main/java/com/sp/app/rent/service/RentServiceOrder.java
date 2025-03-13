package com.sp.app.rent.service;
import java.util.List;
import java.util.Map;

import com.sp.app.rent.model.RentProductOrder;

public interface RentServiceOrder {
	// 대여물품 주문
	public String insertRentProductOrder(RentProductOrder dto) throws Exception;
	
	// 대여물품 상태, 보증금 연체기간 수정
	public void updateRentProductOrder(RentProductOrder dto) throws Exception;
	
	// 대여 판매리스트
	public int dataCount(Map<String, Object> map); // 판매리스트에 출력되는 물품개수
	public List<RentProductOrder> listRentProductOrder(Map<String, Object> map); // 판매된 전체 물품 리스트
	
	// 연체된 경우 연체기간, 보증금 업데이트
}
