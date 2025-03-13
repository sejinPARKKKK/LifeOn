package com.sp.app.service;

import java.util.List;
import java.util.Map;

import com.sp.app.model.Area;

public interface AreaService {
	public void insertBoard(Area dto, String uploadPath) throws Exception;
	public void updateBoard(Area dto, String uploadPath) throws Exception;
	public void deleteBoard(long rvnum, String uploadPath, long num) throws Exception;
	public List<Area> listBoard(Map<String, Object> map);
	public List<Area> bestArea(Map<String, Object> map); // 인기지역
	public Area findById(long rvnum);
	
	public List<Area> listAreaFile(long rvnum);
	public Area findByFileId(long fileNum);
	public void deleteAreaFile(Map<String, Object> map) throws Exception;
	
	public boolean deleteUploadFile(String uploadPath, String filename);
	
	public int dataCount(Map<String, Object> map);
	public void updateHitCount(long num) throws Exception;	
	
	// 스크랩
	public void boardLike(Map<String, Object> map) throws Exception;
	public void deleteBoardLike(Map<String, Object> map) throws Exception;
	public int boardLikeCount(long num);
	public boolean memberBoardLiked(Map<String, Object> map);
	
	// 댓글
	public void reply(Area dto) throws Exception;
	public int replyCount(Map<String, Object> map);
	public List<Area> listReply(Map<String, Object> map);
	public void deleteReply(Map<String, Object> map) throws Exception;
	
	public void replyLike(Map<String, Object> map) throws Exception;
	public Map<String, Object> replyLikeCount(Map<String, Object> map);
	
	public Area findByCategory(long categoryNum);
	public List<Area> listCategory();

	
}
