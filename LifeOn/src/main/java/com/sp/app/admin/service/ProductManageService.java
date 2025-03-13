package com.sp.app.admin.service;

import java.util.List;
import java.util.Map;

import com.sp.app.admin.model.ProductManage;

public interface ProductManageService {
	
	public List<ProductManage> listBigCategory();
	public List<ProductManage> listSmallCategory(int cbn);
	
	public void insertProduct(ProductManage dto, String uploadPath) throws Exception;
	
	
	public void deleteProduct(long pnum, String uploadPath) throws Exception;
	public List<ProductManage> listProductFile(long pnum);
	
	public void insertTogetherProduct(ProductManage dto) throws Exception;
	public void updateTogetherProduct(ProductManage dto) throws Exception;
	public void deleteTogetherProduct(long pnum) throws Exception;
	
	public void updateSaleComplete(long pnum) throws Exception;
	
	public void updateTogtherQuantity(long pnum, int odq);
	
	public List<ProductManage> listProduct(Map<String, Object> map);
	public int dataCount(Map<String, Object> map);
	
	public List<ProductManage> listTogetherProduct(Map<String, Object> map);
	public int dataCount2(Map<String, Object> map);
	
	public int dataCount3(Map<String, Object> map);
	
	public ProductManage findByPnum(long pnum);
	
	public void updateProductStatus();
	
	public void insertLikeProduct(long pnum, long num);
	public void deleteLikeProduct(long pnum, long num);
	
	public String checkStatus(long pnum);
	public void updatePointRecord(long pnum);
	
	
	
}
