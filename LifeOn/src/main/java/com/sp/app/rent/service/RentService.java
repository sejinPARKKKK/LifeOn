package com.sp.app.rent.service;

import java.util.List;
import java.util.Map;

import com.sp.app.rent.model.RentProduct;

public interface RentService {
	// 대여물품 등록
	public void insertRentProduct(RentProduct dto, String uploadPath) throws Exception;
	
	// 대여물품 수정
	public void updateRentProduct(RentProduct dto, String uploadPath) throws Exception;
	
	// 대여물품 삭제
	public void deleteRentProduct(long productNum, String uploadPath, long memberNum) throws Exception;
	
	public List<RentProduct> listProductFile(long productNum);
	public RentProduct findByFileId(long fileNum);
	public void deleteRentProductFile(Map<String, Object> map) throws Exception;
	
	public boolean deleteUploadFile(String uploadPath, String filename);
	
	// 대여물품 리스트 조회
	public int dataCount(Map<String, Object> map); // 리스트에 출력되는 물품개수
	public List<RentProduct> listRentProduct(Map<String, Object> map); // 전체 물품 리스트
	public List<RentProduct> bestListRentProduct(Map<String, Object> map); // 베스트 물품 리스트
	
	public RentProduct findById(long productNum); // 선택한 물품정보 보기
	public List<RentProduct> findByMemberProduct(Map<String, Object> map); // 판매자가 파는 물품리스트
	
	// 대여물품 찜하기
	public void insertMemberLikeProduct(Map<String, Object> map) throws Exception;
	public void deleteMemberLikeProduct(Map<String, Object> map) throws Exception;
	public int productLikeCount(long num);
	public boolean isMemberProductLiked(Map<String, Object> map);
	
	// 상품 카테고리 목록
	public RentProduct findByCategory(long categoryNum);
	public List<RentProduct> listCategory(); // 대분류
	public List<RentProduct> listSubCategory(long categoryNum); // 소분류
}
