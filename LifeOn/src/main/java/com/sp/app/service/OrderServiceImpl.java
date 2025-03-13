package com.sp.app.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.admin.mapper.ProductManageMapper;
import com.sp.app.admin.model.ProductManage;
import com.sp.app.admin.service.ProductManageService;
import com.sp.app.mapper.OrderMapper;
import com.sp.app.mapper.PointRecordMapper;
import com.sp.app.model.Order;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor 
@Slf4j
public class OrderServiceImpl implements OrderService {
	private final OrderMapper mapper;
	private final ProductManageService productService;
	private final ProductManageMapper mapper2;
	private final PointRecordMapper pointmapper;
	private final PointRecordService pointService;
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
	@Override
	public void insertOrder(Order dto) throws Exception {
		try {
			
			productService.updateTogtherQuantity(dto.getPnum(), dto.getOdq()); //수량 업데이트
			
			dto.setOdpp(0); //배송비
			dto.setOup(dto.getOp()); // 사용한 포인트
			dto.setOfp(dto.getOfp()+ dto.getOdpp()); // 총결제금액
			
			mapper.insertOrder(dto);
			mapper.insertOrderDetail(dto);

			//status 업데이트
			ProductManage pm = productService.findByPnum(dto.getPnum());
			if(pm.getPttq() == mapper.getTotalOdq(dto.getPnum())) { //목표수량 == 총 구매수량
				pm.setStatus("구매성공");
				mapper2.updateStatus(dto.getPnum(), pm.getStatus());
			}
			
			
			int totalPoint = 0;
			totalPoint = pointService.totalPoint(dto.getNum());
			dto.setTotalPoint(totalPoint);
			
			Map<String, Object> map = new HashMap<>();
			
			map.put("prep", -dto.getOp());
			map.put("totalPoint", dto.getTotalPoint());
			map.put("num", dto.getNum());
			
			pointmapper.insertTogetherPoint(map);
			
			
		} catch (Exception e) {
			log.info("insertOrder : " , e);
			throw e;
		}
	}

	@Override
	public List<Order> listOrder(Map<String, Object> map) {
		List<Order> list = null;
		
		try {
			list = mapper.listOrder(map);
		} catch (Exception e) {
			log.info("listPoint : ", e);
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

}
