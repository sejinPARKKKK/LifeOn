package com.sp.app.rent.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.sp.app.common.StorageService;
import com.sp.app.exception.StorageException;
import com.sp.app.rent.mapper.RentMapper;
import com.sp.app.rent.model.RentProduct;
import com.sp.app.rent.model.RentProductSub;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class RentServiceImpl implements RentService {
	private final RentMapper mapper;
	private final StorageService storageService;

	@Override
	public void insertRentProduct(RentProduct dto, String uploadPath) throws Exception {
		try {
			// 썸네일 이미지
			if (! dto.getPphFile().isEmpty()) {
				String filename = storageService.uploadFileToServer(dto.getPphFile(), uploadPath);
				dto.setPph(filename);
			}
			
			// 상품 저장
			Long productNum = mapper.productSeq();
			
			dto.setPnum(productNum);
			mapper.insertRentProduct(dto);
			
			// 추가 이미지 저장
			if(! dto.getSelectFile().isEmpty()) {
				insertProductFile(dto, uploadPath);
			}
			
		} catch (Exception e) {
			log.info("insertRentProduct : ", e);
			
			throw e;
		}
	}
	
	private void insertProductFile(RentProduct dto, String uploadPath) throws Exception {
		for (MultipartFile mf : dto.getSelectFile()) {
			try {
				String saveFilename = Objects.requireNonNull(storageService.uploadFileToServer(mf, uploadPath));
				
				dto.setPpp(saveFilename);
				
				mapper.insertRentProductFile(dto);
			} catch (NullPointerException e) {
			} catch (StorageException e) {
			} catch (Exception e) {
				throw e;
			}
		}
	}

	@Override
	public void updateRentProduct(RentProduct dto, String uploadPath) throws Exception {
		try {
			if (dto.getPphFile() != null && ! dto.getPphFile().isEmpty()) {
				deleteUploadFile(uploadPath, dto.getPph());
				
				String filename = storageService.uploadFileToServer(dto.getPphFile(), uploadPath);
				dto.setPph(filename);
			}
			
			mapper.updateProduct(dto);
			mapper.updateRentProduct(dto);
			
			if (! dto.getSelectFile().isEmpty()) {
				insertProductFile(dto, uploadPath);
			}
			
		} catch (Exception e) {
			log.info("updateRentProduct : ", e);
			
			throw e;
		}
	}

	@Override
	public void deleteRentProduct(long productNum, String uploadPath, long memberNum) throws Exception {
		try {
			List<RentProduct> listFile = listProductFile(productNum);
			if (listFile != null) {
				for (RentProduct dto : listFile)
					deleteUploadFile(uploadPath, dto.getPpp());
			}
			
			RentProduct dto = findById(productNum);
			if (dto == null || (dto.getNum() != memberNum)) {
			    return;
			}
			
			deleteUploadFile(uploadPath, dto.getPph());
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("field", "pnum");
			map.put("pnum", productNum);
			deleteRentProductFile(map);
			
			mapper.deleteRentProduct(productNum);
			
		} catch (Exception e) {
			log.info("deleteRentProduct : ", e);
			
			throw e;
		}
	}

	
	@Override
	public List<RentProduct> listProductFile(long productNum) {
		List<RentProduct> list = null;
		
		try {
			list = mapper.listProductFile(productNum);
		} catch (Exception e) {
			log.info("listProductFile : ", e);
		}
		
		return list;
	}

	@Override
	public RentProduct findByFileId(long fileNum) {
		RentProduct dto = null;
		
		try {
			dto = mapper.findByFileId(fileNum);
		} catch (Exception e) {
			log.info("findByFileId : ", e);
		}
		
		return dto;
	}

	@Override
	public void deleteRentProductFile(Map<String, Object> map) throws Exception {
		try {
			mapper.deleteRentProductFile(map);
		} catch (Exception e) {
			log.info("deleteRentProductFile : ", e);
			
			throw e;
		}
	}
	
	@Override
	public boolean deleteUploadFile(String uploadPath, String filename) {
		return storageService.deleteFile(uploadPath, filename);
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
	public RentProduct findByCategory(long categoryNum) {
		RentProduct dto = null;
		
		try {
			dto = mapper.findByCategory(categoryNum);
		} catch (Exception e) {
			log.info("findByCategory : ", e);
		}
		
		return dto;
	}

	@Override
	public List<RentProduct> listRentProduct(Map<String, Object> map) {
		List<RentProduct> list = null;

		try {
			list = mapper.listRentProduct(map);
			
		} catch (Exception e) {
			log.info("listRentProduct : ", e);
		}

		return list;
	}
	
	@Override
	public List<RentProduct> bestListRentProduct(Map<String, Object> map) {
		List<RentProduct> list = null;
		
		try {
			list = mapper.bestListRentProduct(map);
			
		} catch (Exception e) {
			log.info("bestListRentProduct : ", e);
		}
		
		return list;
	}

	@Override
	public RentProduct findById(long productNum) {
		RentProduct dto = null;

		try {
			dto = mapper.findById(productNum);
		} catch (Exception e) {
			log.info("findById : ", e);
		}

		return dto;
	}

	@Override
	public List<RentProduct> findByMemberProduct(Map<String, Object> map) {
		List<RentProduct> list = null;
		
		try {
			list = mapper.findByMemberProduct(map);
		} catch (Exception e) {
			log.info("findByPrev : ", e);
		}
		
		return list;
	}
	
	@Override
	public void insertMemberLikeProduct(Map<String, Object> map) throws Exception {
		try {
			mapper.insertMemberLikeProduct(map);
		} catch (Exception e) {
			log.info("insertMemberLikeProduct : ", e);
			
			throw e;
		}
	}

	@Override
	public void deleteMemberLikeProduct(Map<String, Object> map) throws Exception {
		try {
			mapper.deleteMemberLikeProduct(map);
		} catch (Exception e) {
			log.info("deleteMemberLikeProduct : ", e);
			
			throw e;
		}	
	}

	@Override
	public int productLikeCount(long num) {
		int result = 0;
		try {
			result = mapper.productLikeCount(num);
		} catch (Exception e) {
			log.info("productLikeCount : ", e);
		}
		
		return result;
	}

	@Override
	public boolean isMemberProductLiked(Map<String, Object> map) {
		boolean result = false;
		
		try {
			RentProduct dto = mapper.memberProductLiked(map);
			if (dto != null) {
				result = true;
			}
		} catch (Exception e) {
			log.info("isMemberProductLiked : ", e);
		}
		
		return result;
	}

	@Override
	public List<RentProduct> listCategory() {
		List<RentProduct> list = null;
		
		try {
			list = mapper.listCategory();
			
			for(RentProduct dto : list) {
				List<RentProductSub> listSub = new ArrayList<>();
				
				List<RentProduct> listSubCategory = listSubCategory(dto.getCbn());
				for(RentProduct dto2 : listSubCategory) {
					RentProductSub sub = new RentProductSub();
					sub.setCsn(dto2.getCsn());
					sub.setCsc(dto2.getCsc());
					listSub.add(sub);
				}
				
				dto.setListSub(listSub);
			}
			
		} catch (Exception e) {
			log.info("listCategory : ", e);
		}
		
		return list;
	}

	@Override
	public List<RentProduct> listSubCategory(long categoryNum) {
		List<RentProduct> list = null;
		
		try {
			list = mapper.listSubCategory(categoryNum);
		} catch (Exception e) {
			log.info("listSubCategory : ", e);
		}
		
		return list;
	}
}
