package com.sp.app.lounge.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.sp.app.common.MyUtil;
import com.sp.app.common.StorageService;
import com.sp.app.exception.StorageException;
import com.sp.app.lounge.mapper.FlowBoardMapper;
import com.sp.app.lounge.model.FlowBoard;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class FlowBoardServiceImpl implements FlowBoardService {
	private final FlowBoardMapper mapper;
	private final StorageService storageService;
	private final MyUtil myUtil;

	@Override
	public void insertBoard(FlowBoard dto, String uploadPath) throws Exception {
		try {
			long seq = mapper.FlowBoardSeq();
			dto.setPsnum(seq);
			
			mapper.insertBoard(dto);
			
			if (! dto.getSelectFile().isEmpty()) {
				insertFile(dto, uploadPath);
			}
			
		} catch (Exception e) {
			log.info("insertBoard : " + e);
			
			throw e;
		}
	}

	@Override
	public List<FlowBoard> listBoard(Map<String, Object> map) {
		List<FlowBoard> list = null;

		try {
			list = mapper.listBoard(map);
			
		} catch (Exception e) {
			log.info("listBoard : ", e);
		}

		return list;
	}
	
	@Override
	public List<FlowBoard> sortListBoard(Map<String, Object> map) {
		List<FlowBoard> list = null;
		
		try {
			list = mapper.sortListBoard(map);
			
		} catch (Exception e) {
			log.info("sortListBoard : ", e);
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
	public FlowBoard findById(long num) {
		FlowBoard dto = null;

		try {
			dto = mapper.findById(num);
		} catch (Exception e) {
			log.info("findById : ", e);
		}

		return dto;
	}

	@Override
	public void updateHitCount(long num) throws Exception {
		try {
			mapper.updateHitCount(num);
		} catch (Exception e) {
			log.info("updateHitCount : ", e);
			
			throw e;
		}
	}

	@Override
	public FlowBoard findByPrev(Map<String, Object> map) {
		FlowBoard dto = null;
		
		try {
			dto = mapper.findByPrev(map);
		} catch (Exception e) {
			log.info("findByPrev : ", e);
		}
		
		return dto;
	}

	@Override
	public FlowBoard findByNext(Map<String, Object> map) {
		FlowBoard dto = null;
		
		try {
			dto = mapper.findByNext(map);
		} catch (Exception e) {
			log.info("findByNext : ", e);
		}
		
		return dto;
	}

	@Override
	public void updateBoard(FlowBoard dto, String uploadPath) throws Exception {
		try {
			mapper.updateBoard(dto);
			
			if (! dto.getSelectFile().isEmpty()) {
				insertFile(dto, uploadPath);
			}
			
		} catch (Exception e) {
			log.info("updateBoard : ", e);
			
			throw e;
		}
	}

	@Override
	public void deleteBoard(long num, String uploadPath, String nickname, int grade) throws Exception {
		try {
			List<FlowBoard> listFile = listFile(num);
			if (listFile != null) {
				for (FlowBoard dto : listFile)
					deleteUploadFile(uploadPath, dto.getSsfname());
			}
			
			FlowBoard dto = findById(num);
			if (dto == null || (grade < 1 && !dto.getNickname().equals(nickname))) {
			    return;
			}
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("field", "fnum");
			map.put("psnum", num);
			deleteFile(map);
			
			mapper.deleteBoard(num);
			
		} catch (Exception e) {
			log.info("deleteBoard : ", e);
			
			throw e;
		}
	}

	@Override
	public List<FlowBoard> listFile(long num) {
		List<FlowBoard> listFile =  null;
		
		try {
			listFile = mapper.listFile(num);
		} catch (Exception e) {
			log.info("listFile : ", e);
		}
		return listFile;
	}

	@Override
	public FlowBoard findByFileId(long fileNum) {
		FlowBoard dto = null;
		
		try {
			dto = mapper.findByFileId(fileNum);
		} catch (Exception e) {
			log.info("findByfileId : ", e);
		}
		
		return dto;
	}

	@Override
	public void deleteFile(Map<String, Object> map) throws Exception {
		try {
			mapper.deleteFile(map);
		} catch (Exception e) {
			log.info("deleteFile : ", e);
			
			throw e;
		}
	}
	
	@Override
	public boolean deleteUploadFile(String uploadPath, String filename) {
		return storageService.deleteFile(uploadPath, filename);
	}
	
	protected void insertFile(FlowBoard dto, String uploadPath) throws Exception {
		for (MultipartFile mf : dto.getSelectFile()) {
			try {
				String saveFilename =  Objects.requireNonNull(storageService.uploadFileToServer(mf, uploadPath));

				String originalFilename = mf.getOriginalFilename();

				dto.setCpfname(originalFilename);
				dto.setSsfname(saveFilename);

				mapper.updateFile(dto);
				
			} catch (NullPointerException e) {
			} catch (StorageException e) {
			} catch (Exception e) {
				throw e;
			}
		}
	}

	@Override
	public void insertBoardLike(Map<String, Object> map) throws Exception {
		try {
			mapper.insertBoardLike(map);
		} catch (Exception e) {
			log.info("insertBoardLike : ", e);
			
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
	public boolean isMemberBoardLiked(Map<String, Object> map) {
		boolean result = false;
		
		try {
			FlowBoard dto = mapper.memberBoardLiked(map);
			if (dto != null) {
				result = true;
			}
		} catch (Exception e) {
			log.info("isMemberBoardLiked : ", e);
		}
		
		return result;
	}
	
	@Override
	public void insertBoardBlind(Map<String, Object> map) throws Exception {
		try {
			mapper.insertBoardBlind(map);
		} catch (Exception e) {
			log.info("insertBoardBlind : ", e);
			
			throw e;
		}
	}
	
	@Override
	public Long reprtNum(Map<String, Object> map) {
		Long num = null;
		
		try {
			num = mapper.reprtNum(map);
	        
	        if (num == null) {
	            num = 0L;
			 }
	        
		} catch (Exception e) {
			log.info("reprtNum : ", e);
		}
		
		return num;
	}

	@Override
	public void insertReply(FlowBoard dto) throws Exception {
		try {
			mapper.insertReply(dto);
		} catch (Exception e) {
			log.info("insertReply : ", e);
			
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
	public List<FlowBoard> listReply(Map<String, Object> map) {
		List<FlowBoard> list = null;
		
		try {
			list = mapper.listReply(map);
			
			for (FlowBoard dto : list) {
				dto.setRpcontent(myUtil.htmlSymbols(dto.getRpcontent()));
				
				map.put("rpnum", dto.getRpnum());
				map.put("psnum", dto.getPsnum());
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
			log.info("memberReplyLiked : ", e);
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
	public void insertReplyLike(Map<String, Object> map) throws Exception {
		try {
			mapper.insertReplyLike(map);
		} catch (Exception e) {
			log.info("insertReplyLike : ", e);
			
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
	public void updateReplyBlind(Map<String, Object> map) throws Exception {
		try {
			mapper.updateReplyBlind(map);
		} catch (Exception e) {
			log.info("updateReplyBlind : ", e);
			
			throw e;
		}
		
	}
}
