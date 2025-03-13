package com.sp.app.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.sp.app.common.MyUtil;
import com.sp.app.common.StorageService;
import com.sp.app.mapper.MeetingMapper;
import com.sp.app.model.Meeting;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class MeetingServiceImpl implements MeetingService{
	private final MeetingMapper mapper;
	private final StorageService storageService;
	private final MyUtil myUtil;
	
	@Override
	public void insertBoard(Meeting dto) throws Exception {
		try {
			long seq = mapper.meetingSeq();
			dto.setPsnum(seq);
			
			mapper.insertBoard(dto);

		} catch (Exception e) {
			log.info("insertBoard : ", e);
			
			throw e;
		}
	}
	@Override
	public List<Meeting> listCategory() {
		List<Meeting> list = null;
		
		try {
			list = mapper.listCategory();
		} catch (Exception e) {
			log.info("listCategory : ", e);
		}
		return list;
	}
	
	@Override
	public Meeting findByCategory(long categoryNum) {
		 Meeting dto = null;
		
		try {
			dto = mapper.findByCategory(categoryNum);
		} catch (Exception e) {
			log.info("findByCategory : ", e);
		}
		
		return dto;
	}
	
	@Override
	public void updateBoard(Meeting dto) throws Exception {
		try {
			
			mapper.updateBoard(dto);
			
		} catch (Exception e) {
			log.info("updateBoard : ", e);
			
			throw e;
		}
		
	}
	@Override
	public void deleteBoard(long psnum, String nickname, long num) throws Exception {
			try {
			
				Meeting dto = findById(psnum);
				
				if (dto == null || (dto.getNum() != num)) {
				    return;
				}
				
				Map<String, Object> map = new HashMap<>();
				map.put("psnum", psnum);
				
				
				mapper.deleteBoard(psnum);
				
			} catch (Exception e) {
				log.info("deleteBoard : ", e);
				
				throw e;
			}
		
	}
	@Override
	public List<Meeting> listBoard(Map<String, Object> map) {
		List<Meeting> list = null;

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
	public Meeting findById(long num) {
		Meeting dto = null;

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
			Meeting dto = mapper.memberBoardLiked(map);
			if (dto != null) {
				result = true;
			}
		} catch (Exception e) {
			log.info("memberBoardLiked : ", e);
		}
		
		return result;
	}
	@Override
	public void reply(Meeting dto) throws Exception {
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
	public List<Meeting> listReply(Map<String, Object> map) {
		List<Meeting> list = null;
		
		try {
			list = mapper.listReply(map);
			
			for (Meeting dto : list) {
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
	
	