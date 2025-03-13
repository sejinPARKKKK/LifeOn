package com.sp.app.service;

import java.util.List;
import java.util.Map;

import com.sp.app.model.LikeProduct;
import com.sp.app.model.PointRecord;

public interface PointRecordService {
	public List<PointRecord> listPoint(Map<String, Object> map);
	public int dataCount(Map<String, Object> map);
	public int totalPoint(long num);
	
	public void insertChargeAndCard(Map<String, Object> map);
	
	
	//관심상품 list만 구현하면되서 여기다 구현함
	public int dataCount2(Map<String, Object> map);
	public List<LikeProduct> listLikeProduct(Map<String, Object> map);
	
}
