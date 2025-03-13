package com.sp.app.service;

import java.util.List;
import java.util.Map;

import com.sp.app.model.Meeting;

public interface MeetingService {
	public void insertBoard(Meeting dto) throws Exception;
	public void updateBoard(Meeting dto) throws Exception;
	public void deleteBoard(long psnum, String nickname, long num) throws Exception;
	public List<Meeting> listBoard(Map<String, Object> map);
	public int dataCount(Map<String, Object> map);
	public Meeting findById(long num);
	public void updateHitCount(long num) throws Exception;	
	
	// 스크랩
	public void boardLike(Map<String, Object> map) throws Exception;
	public void deleteBoardLike(Map<String, Object> map) throws Exception;
	public int boardLikeCount(long num);
	public boolean memberBoardLiked(Map<String, Object> map);
	
	// 댓글
	public void reply(Meeting dto) throws Exception;
	public int replyCount(Map<String, Object> map);
	public List<Meeting> listReply(Map<String, Object> map);
	public void deleteReply(Map<String, Object> map) throws Exception;
	
	public void replyLike(Map<String, Object> map) throws Exception;
	public Map<String, Object> replyLikeCount(Map<String, Object> map);
	
	public Meeting findByCategory(long categoryNum);
	public List<Meeting> listCategory();

	
}
