package com.sp.app.rent.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.rent.model.RentProductOrder;

@Mapper
public interface RentOrderMapper {
	// 대여물품 주문
	public void insertRentProductOrder(RentProductOrder dto) throws SQLException;
	
	// 회원 포인트 조회
	public int memberPoint(long num); // 회원 잔여 포인트
	public void insertPoint(RentProductOrder dto) throws SQLException;
	
	public long sellerNum(long num); // 판매자 회원번호
	public void sellerInsertPoint(RentProductOrder dto) throws SQLException;
	
	// 대여물품 상태, 보증금 연체기간 수정
	public void updateStatus(RentProductOrder dto) throws SQLException;
	public void updateRentProductOrder(RentProductOrder dto) throws SQLException;
	
	// 대여 판매리스트
	public int dataCount(Map<String, Object> map); // 판매리스트에 출력되는 물품개수
	public List<RentProductOrder> listRentProductOrder(Map<String, Object> map); // 판매된 전체 물품 리스트
	
	// 연체된 경우 연체기간, 보증금 업데이트
}
