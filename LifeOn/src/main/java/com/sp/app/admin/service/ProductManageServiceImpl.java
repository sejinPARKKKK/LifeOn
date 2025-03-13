package com.sp.app.admin.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.sp.app.admin.mapper.ProductManageMapper;
import com.sp.app.admin.model.ProductManage;
import com.sp.app.common.StorageService;
import com.sp.app.exception.StorageException;
import com.sp.app.mapper.OrderMapper;
import com.sp.app.service.PointRecordService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProductManageServiceImpl implements ProductManageService{
	private final ProductManageMapper mapper;
	private final StorageService storageSerivce;
	private final OrderMapper odmapper;
	private final PointRecordService prService;
	@Override
	public List<ProductManage> listBigCategory() {
		List<ProductManage> list = null;
		
		try {
			list = mapper.listBigCategory();
		} catch (Exception e) {
			log.info("listBigCategory : ", e);
		}
		return list;
	}

	@Override
	public List<ProductManage> listSmallCategory(int cbn) {
		List<ProductManage> list = null;
		
		try {
			list = mapper.listSmallCategory(cbn);
		} catch (Exception e) {
			log.info("listSmallCategory : ", e);
		}
		
		return list;
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
	@Override
	public void insertProduct(ProductManage dto, String uploadPath) throws Exception {
		try {
			//썸네일
			String filename = storageSerivce.uploadFileToServer(dto.getPphFile(), uploadPath);
			dto.setPph(filename);
			
			mapper.insertProduct(dto);
			mapper.insertStock(dto);
			insertProductImage(dto, uploadPath);
		} catch (Exception e) { 
			log.info("insertProduct : " , e);
			throw e;
		}
	}
	
	protected void insertProductImage(ProductManage dto, String uploadPath) throws Exception {
		for(MultipartFile mf : dto.getPppFile()) {
			try {
				String ppp = Objects.requireNonNull(storageSerivce.uploadFileToServer(mf, uploadPath)); //서버에서 저장된 파일경로
				
				dto.setPpp(ppp);
				mapper.insertProductImage(dto);
				
			} catch (NullPointerException e) {
				log.info("insertProductImage1 : " , e);
			} catch (StorageException e) {
				log.info("insertProductImage2 : " , e);
			} catch (Exception e) {
				throw e;
			}
		}
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
	@Override
	public void deleteProduct(long pnum, String uplaodPath) throws Exception {
		try {
			ProductManage dto = findByPnum(pnum);
			
			List<ProductManage> listFile = listProductFile(pnum);
			if(listFile != null) {
				for(ProductManage vo : listFile) {
					deleteUploadFile(uplaodPath, vo.getPpp());
				}
			}
			mapper.deleteProductImage(pnum);
			mapper.deleteStock(pnum);
			
			deleteUploadFile(uplaodPath, dto.getPph());
			
			mapper.deleteProduct(pnum);
		
		} catch (Exception e) {
			log.info("deleteProduct : ", e);
			throw e;
		}
		
	}
	
	@Override
	public List<ProductManage> listProductFile(long pnum) {
		List<ProductManage> listFile = null;
		
		try {
			listFile = mapper.listProductFile(pnum);
		} catch (Exception e) {
			log.info("listProductFile : ", e);
		}
		
		return listFile;
	}
	
	
	public boolean deleteUploadFile(String uploadPath, String filename) {
		return storageSerivce.deleteFile(uploadPath, filename);
	}
	
	
	@Override
	public void insertTogetherProduct(ProductManage dto) throws Exception {
		try {
			
			String startStr = dto.getPtsd();
			
			LocalDate start = LocalDate.parse(startStr, DateTimeFormatter.ISO_LOCAL_DATE);		
			LocalDate today = LocalDate.now();

			
			if(today.isBefore(start)) {
				dto.setStatus("진행전");
			} else {
				dto.setStatus("진행중");
			} 
			
			mapper.insertTogetherProduct(dto);
		} catch (Exception e) {
			log.info("insertTogetherProduct : " , e);
			throw e;
		}
		
	}
	@Override
	public void updateTogetherProduct(ProductManage dto) throws Exception {
		try {
			mapper.updateTogetherProduct(dto);
		} catch (Exception e) {
			log.info("updateTogetherProduct : ", e);
			throw e;
		}
	}
	
	
	@Override
	public void updateTogtherQuantity(long pnum, int odq) {
		try {
			mapper.updateTogetherQuantity(pnum, odq);
		} catch (Exception e) {
			log.info("updateTogtherQuantity : ", e);
		}
	}
	
	
	@Override
	public void deleteTogetherProduct(long pnum) throws Exception {
		try {
			ProductManage dto = findByPnum(pnum);
			if(dto == null){
				return;
			}
			mapper.deleteTogetherProduct(pnum);
		} catch (Exception e) {
			log.info("deleteTogetherProduct : ", e);
		}
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
	@Override
	public void updateSaleComplete(long pnum) throws Exception {
		try {
			ProductManage dto = findByPnum(pnum);
			if(dto == null) {
				return;
			}
			mapper.updateSaleComplete(pnum);
			mapper.updateSaleStatus(pnum);
		} catch (Exception e) {
			log.info("updateSaleComplete : ", e);
		}
	}

	
	@Override
	public List<ProductManage> listProduct(Map<String, Object> map) {
		List<ProductManage> list = null;
		
		try {
			list = mapper.listProduct(map);
			
			
		} catch (Exception e) {
			log.info("listProduct : ", e);
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

	@Override
	public List<ProductManage> listTogetherProduct(Map<String, Object> map) {
		List<ProductManage> list = null;
		List<Long> likeList = null;
		//Set<Long> likeList = new HashSet<>(likeList); 성능향상할거면 set으로
		try {
			list = mapper.listTogetherProduct(map);
			
			long num = 0;
			if (map.get("num") != null) {
			        num = ((Number) map.get("num")).longValue(); // ✅ 안전한 변환
			}
			
			if(num > 0) {				
				likeList = mapper.likedProduct(num);
			}
			
			for(ProductManage dto : list) {  //팔린수량 설정, liked 설정 
				dto.setTotalOdq(odmapper.getTotalOdq(dto.getPnum()));
				
				if (num > 0) {
			        dto.setLiked(likeList.contains(dto.getPnum()));
			    } else {
			        dto.setLiked(false); 
			    }
			}
			
			
		} catch (Exception e) {
			log.info("listTogetherProduct : ", e);
		}
		
		return list;
	}

	@Override
	public int dataCount2(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = mapper.dataCount2(map);
			
			
			
		} catch (Exception e) {
			log.info("dataCount2 : ", e);
		}
		return result;
	}
	
	

	@Override
	public int dataCount3(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = mapper.dataCount3(map);
			
			
			
		} catch (Exception e) {
			log.info("dataCount2 : ", e);
		}
		return result;
	}
	
	@Override
	public ProductManage findByPnum(long pnum) {
		ProductManage dto = null;
		
		try {
			dto = mapper.findByPnum(pnum);
		} catch (Exception e) {
			log.info("findByPnum : ", e);
		}
		
		return dto;
	}

	@Scheduled(cron = "0 0 0 * * *")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
	@Override
	public void updateProductStatus() {
		try {
			mapper.updateStatusIng();
			mapper.updateStatusFail();
		} catch (Exception e) {
			log.info("updateProductStatus : ", e);
			log.info("공동구매 상태 자동 업데이트 실행됨! (테스트)");
		}

	}

	@Override
	public void insertLikeProduct(long pnum, long num) {
		try {
			mapper.insertLikeProduct(pnum, num);
		} catch (Exception e) {
			log.info("insertLikeProduct : ", e);
		}
		
	}

	@Override
	public void deleteLikeProduct(long pnum, long num) {
		try {
			mapper.deleteLikeProduct(pnum, num);
		} catch (Exception e) {
			log.info("insertLikeProduct : ", e);
		}
		
	}

	@Override
	public String checkStatus(long pnum) {
		String  result ="";
		try {
			result = mapper.checkStatus(pnum);
		} catch (Exception e) {
			log.info("checkStatus : ", e);
		}
		
		return result;
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
	public void updatePointRecord(long pnum) {
		try {
			
			List<Map<String, Object>> list = mapper.listPointRecord(pnum);
			
			
			for(Map<String, Object> map : list) {
	            long num = ((Number) map.get("NUM")).longValue();  // 회원번호
	            int prep = ((Number) map.get("PREP")).intValue();  // 사용한 포인트 
	            
	            int totalPoint = 0;
	            totalPoint = prService.totalPoint(num);
	            
	            log.debug("num: " + num + ", prep: " + prep + ", totalPoint: " + totalPoint);
	            mapper.insertRefundRecord(num, prep, totalPoint);   
			}
			
			
		} catch (Exception e) {
			log.info("updatePointRecord : ", e);
		}
		
	}












	
	
	
	
	
	
	
	
	
}
