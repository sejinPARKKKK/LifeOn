package com.sp.app.rent.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.sp.app.rent.mapper.RentOrderMapper;
import com.sp.app.rent.model.RentProductOrder;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class RentServiceOrderImpl implements RentServiceOrder{
	private final RentOrderMapper mapper;
	
	@Override
	public String insertRentProductOrder(RentProductOrder dto) throws Exception { // 물품 대여 신청
		try {
			int myPoint = mapper.memberPoint(dto.getNum()); // 구매자 잔여 포인트 조회
			
			if (myPoint >= dto.getOp()) { // 총 결제 금액보다 보유 포인트가 많으면
				dto.setPrep(-dto.getOp()); // 결제 금액 세팅
				dto.setPretp(myPoint - dto.getOp()); // 총 잔여 포인트 세팅
				
				mapper.insertPoint(dto); // 포인트 테이블에 결제 금액 데이터 추가
				mapper.insertRentProductOrder(dto); // 주문 테이블에 주문내역 추가
				mapper.updateStatus(dto); // 물품대여 게시글 상태 업데이트(대여가능 -> 대여중)
				
				dto.setSellerNum(mapper.sellerNum(dto.getPnum())); // 판매자 회원번호 조회
				myPoint = mapper.memberPoint(dto.getSellerNum()); // 판매자 잔여 포인트 조회
				dto.setPrep(dto.getOdp() * dto.getOdq()); // 판매 금액 세팅
				dto.setPretp(myPoint + dto.getPrep()); // 총 잔여 포인트 세팅
				mapper.sellerInsertPoint(dto); // 판매자에게 구매자가 결제한 포인트 입금
				
			} else {
				return "noPoint"; // 잔여 포인트가 결제 금액보다 적을 경우 예외처리
			}
			
		} catch (Exception e) {
			log.info("insertRentProductOrder : ", e); // 예외 로그 노출
			return "false"; // 실패처리
		}
		
		return "true"; // 성공처리
	}
	
	@Override
	public void updateRentProductOrder(RentProductOrder dto) throws Exception {
		// TODO 반납이 완료될 경우 보증금처리, 반납되지 않을 경우 연체기간 업데이트
		
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
	public List<RentProductOrder> listRentProductOrder(Map<String, Object> map) {
		List<RentProductOrder> list = null;
		
		try {
			list = mapper.listRentProductOrder(map);
			
		} catch (Exception e) {
			log.info("listRentProductOrder : ", e);
		}
		
		return list;
	}
}
