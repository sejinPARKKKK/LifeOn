package com.sp.app.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.sp.app.common.MyUtil;
import com.sp.app.common.StorageService;
import com.sp.app.exception.StorageException;
import com.sp.app.mapper.AreaMapper;
import com.sp.app.model.Area;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class AreaServiceImpl implements AreaService{
	private final AreaMapper mapper;
	private final StorageService storageService;
	private final MyUtil myUtil;
	
	@Override
	public void insertBoard(Area dto, String uploadPath) throws Exception {
		try {
			// 썸네일
			if (! dto.getThpFile().isEmpty()) {
				String filename = storageService.uploadFileToServer(dto.getThpFile(), uploadPath);
				dto.setThp(filename);
			}
			
			Long rvnum = mapper.areaSeq();
			
			dto.setRvnum(rvnum);
			mapper.insertBoard(dto);
			
			if(! dto.getSelectFile().isEmpty()) {
				insertBoardFile(dto, uploadPath);
			}
			
		} catch (Exception e) {
			log.info("insertBoard : ", e);
			
			throw e;
		}
	}
	
	private void insertBoardFile(Area dto, String uploadPath) throws Exception {
		for (MultipartFile mf : dto.getSelectFile()) {
			try {
				String saveFilename = Objects.requireNonNull(storageService.uploadFileToServer(mf, uploadPath));
				
				dto.setSsfname(saveFilename);
				
				mapper.insertBoardFile(dto);
			} catch (NullPointerException e) {
			} catch (StorageException e) {
			} catch (Exception e) {
				throw e;
			}
		}
	}

	@Override
	public void updateBoard(Area dto, String uploadPath) throws Exception {
		try {
			if (dto.getThpFile() != null && ! dto.getThpFile().isEmpty()) {
				deleteUploadFile(uploadPath, dto.getThp());
				
				String filename = storageService.uploadFileToServer(dto.getThpFile(), uploadPath);
				dto.setThp(filename);
			}
			
			mapper.updateBoard(dto);;
			
			if (! dto.getSelectFile().isEmpty()) {
				insertBoardFile(dto, uploadPath);
			}
			
		} catch (Exception e) {
			log.info("updateBoard : ", e);
			
			throw e;
		}
	}

	@Override
	public void deleteBoard(long rvnum, String uploadPath, long num) throws Exception {
		try {
			List<Area> listFile = listAreaFile(rvnum);
			if (listFile != null) {
				for (Area dto : listFile)
					deleteUploadFile(uploadPath, dto.getThp());
			}
			
			Area dto = findById(rvnum);
			if (dto == null || (dto.getNum() != num)) {
			    return;
			}
			
			deleteUploadFile(uploadPath, dto.getThp());
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("field", "rvnum");
			map.put("rvnum", rvnum);
			deleteAreaFile(map);
			
			mapper.deleteBoard(rvnum);
			
		} catch (Exception e) {
			log.info("deleteBoard : ", e);
			
			throw e;
		}
	}
	@Override
	public List<Area> listBoard(Map<String, Object> map) {
		List<Area> list = null;

		try {
			list = mapper.listBoard(map);
			
		} catch (Exception e) {
			log.info("listBoard : ", e);
		}

		return list;
	}
	
	@Override
	public List<Area> bestArea(Map<String, Object> map) {
		List<Area> list = null;
		
		try {
			list = mapper.bestArea(map);
			
		} catch (Exception e) {
			log.info("bestArea : ", e);
		}
		
		return list;
	}
	
	@Override
	public Area findById(long rvnum) {
		Area dto = null;

		try {
			dto = mapper.findById(rvnum);
		} catch (Exception e) {
			log.info("findById : ", e);
		}

		return dto;
	}
	@Override
	public List<Area> listAreaFile(long rvnum) {
		List<Area> list = null;
		
		try {
			list = mapper.listAreaFile(rvnum);
		} catch (Exception e) {
			log.info("listAreaFile : ", e);
		}
		
		return list;
	}
	
	@Override
	public Area findByFileId(long fileNum) {
		Area dto = null;
		
		try {
			dto = mapper.findByFileId(fileNum);
		} catch (Exception e) {
			log.info("findByFileId : ", e);
		}
		
		return dto;
	}
	
	@Override
	public void deleteAreaFile(Map<String, Object> map) throws Exception {
		try {
			mapper.deleteAreaFile(map);
		} catch (Exception e) {
			log.info("deleteAreaFile : ", e);
			
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
	public void updateHitCount(long num) throws Exception {
		try {
			mapper.updateHitCount(num);
		} catch (Exception e) {
			log.info("updateHitCount : ", e);
			
		}
	}
	@Override
	public void boardLike(Map<String, Object> map) throws Exception {
		try {
			mapper.boardLike(map);
		} catch (Exception e) {
			log.info("boardLike : ", e);
			
			throw e;
		}
		
	}
	@Override
	public void deleteBoardLike(Map<String, Object> map) throws Exception {
		try {
			mapper.deleteBoardLike(map);
		} catch (Exception e) {
			log.info("deleteBoardLike : ", e);
			
			throw e;
		}	
		
	}
	@Override
	public int boardLikeCount(long num) {
		int result = 0;
		try {
			result = mapper.boardLikeCount(num);
		} catch (Exception e) {
			log.info("boardLikeCount : ", e);
		}
		
		return result;
	}
	@Override
	public boolean memberBoardLiked(Map<String, Object> map) {
		boolean result = false;
		
		try {
			Area dto = mapper.memberBoardLiked(map);
			if (dto != null) {
				result = true;
			}
		} catch (Exception e) {
			log.info("memberBoardLiked : ", e);
		}
		
		return result;
	}
	@Override
	public void reply(Area dto) throws Exception {
		try {
			mapper.reply(dto);
		} catch (Exception e) {
			log.info("reply : ", e);
			
			throw e;
		}
	}
	@Override
	public int replyCount(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = mapper.replyCount(map);
		} catch (Exception e) {
			log.info("replyCount : ", e);
		}
		
		return result;
	}
	@Override
	public List<Area> listReply(Map<String, Object> map) {
		List<Area> list = null;
		
		try {
			list = mapper.listReply(map);
			
			for (Area dto : list) {
				dto.setRpcontent(myUtil.htmlSymbols(dto.getRpcontent()));
				
				map.put("rpnum", dto.getRpnum());
				map.put("psnum", dto.getRvnum());
				dto.setNickname(dto.getNickname());
				dto.setMemberLiked(memberReplyLiked(map));
			}
			
		} catch (Exception e) {
			log.info("listReply : ", e);
		}
		
		return list;
	}
	
	protected int memberReplyLiked(Map<String, Object> map) {
		int result = -1;
		
		try {
			result = mapper.memberReplyLiked(map).orElse(-1);
		} catch (Exception e) {
			log.info("userReplyLiked : ", e);
		}
		
		return result;
	}
	
	@Override
	public void deleteReply(Map<String, Object> map) throws Exception {
		try {
			mapper.deleteReply(map);
		} catch (Exception e) {
			log.info("deleteReply : ", e);
			
			throw e;
		}
	}
	@Override
	public void replyLike(Map<String, Object> map) throws Exception {
		try {
			mapper.replyLike(map);
		} catch (Exception e) {
			log.info("replyLike : ", e);
			
			throw e;
		}
		
		
	}
	@Override
	public Map<String, Object> replyLikeCount(Map<String, Object> map) {
Map<String, Object> countMap = null;
		
		try {
			countMap = mapper.replyLikeCount(map);
		} catch (Exception e) {
			log.info("replyLikeCount : ", e);
		}
		return countMap;
		}

	@Override
	public Area findByCategory(long categoryNum) {
		Area dto = null;
		
		try {
			dto = mapper.findByCategory(categoryNum);
		} catch (Exception e) {
			log.info("findByCategory : ", e);
		}
		
		return dto;
	}
	@Override
	public List<Area> listCategory() {
		List<Area> list = null;
		
		try {
			list = mapper.listCategory();
		} catch (Exception e) {
			log.info("listCategory : ", e);
		}
		return list;
	}

}
	