package com.sp.app.lounge.service;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.sp.app.common.MyUtil;
import com.sp.app.common.StorageService;
import com.sp.app.exception.StorageException;
import com.sp.app.lounge.mapper.PhotoBoardMapper;
import com.sp.app.lounge.model.PhotoBoard;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class PhotoBoardServiceImpl implements PhotoBoardService{
	private final PhotoBoardMapper mapper;
	private final StorageService storageService;
	private final MyUtil myUtil;
	
	@Override
	public void insertBoard(PhotoBoard dto, String uploadPath) throws Exception {
		try {
			long seq = mapper.PhotoBoardSeq();
			dto.setPsnum(seq);

			mapper.insertBoard(dto);

			// 파일 업로드
			if (! dto.getSelectFile().isEmpty()) {
				insertFile(dto, uploadPath);
			}
			
		} catch (Exception e) {
			log.info("insertBoard : ", e);
			
			throw e;
		}
	}

	@Override
	public List<PhotoBoard> listBoard(Map<String, Object> map) {
		List<PhotoBoard> list = null;

		try {
			list = mapper.listBoard(map);
			
		} catch (Exception e) {
			log.info("listBoard : ", e);
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
	public PhotoBoard findById(Map<String, Object> map) {
		PhotoBoard dto = null;
		
		try {
			dto = mapper.findById(map);
			
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
			
		}
	}


	@Override
	public void deleteBoard(String bdtype, long psnum, String uploadPath, String nickname, int grade) throws Exception {
		try {
			
			Map<String, Object> map = new HashMap<>();
			map.put("bdtype", bdtype);
			map.put("field", "fnum");
			map.put("psnum", psnum);
			
			deleteFile(map);
			
			PhotoBoard dto = findById(map);
			
			if(dto == null || (grade < 51 && ! dto.getNickname().equals(nickname))) {
				return;
			}
			
			mapper.deleteBoard(map);
			
		} catch (Exception e) {
			log.info("deleteBoard : ", e);
			
			throw e;
		}
	}
	
	@Override
	public boolean deleteUploadFile(String uploadPath, String filename) {
		return storageService.deleteFile(uploadPath, filename);

	}
	

	@Override
	public List<PhotoBoard> listFile(long num) {
		List<PhotoBoard> listFile =  null;
		
		try {
			listFile = mapper.listFile(num);
			
		} catch (Exception e) {
			log.info("listFile : ", e);
		}
		return listFile;
	}

	@Override
	public void updateFile(PhotoBoard dto) throws SQLException {
		// TODO Auto-generated method stub
		
	}
	
	@Override
	public PhotoBoard findByFileId(long fileNum) {
		PhotoBoard dto = null;
		
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
	
	protected void insertFile(PhotoBoard dto, String uploadPath) throws Exception {
		for (MultipartFile mf : dto.getSelectFile()) {
			try {
				String saveFilename = Objects.requireNonNull(storageService.uploadFileToServer(mf, uploadPath));
				
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
	public void updateBoard(PhotoBoard dto, String uploadPath) throws Exception {
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
	public PhotoBoard findByPrev(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public PhotoBoard findByNext(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
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
			PhotoBoard dto = mapper.memberBoardLiked(map);
			if (dto != null) {
				result = true;
			}
		} catch (Exception e) {
			log.info("memberBoardLiked : ", e);
		}
		
		return result;
	}
	
	@Override
	public void reply(PhotoBoard dto) throws Exception {
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
	public List<PhotoBoard> listReply(Map<String, Object> map) {
		List<PhotoBoard> list = null;
		
		try {
			list = mapper.listReply(map);
			
			for (PhotoBoard dto : list) {
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
	}
