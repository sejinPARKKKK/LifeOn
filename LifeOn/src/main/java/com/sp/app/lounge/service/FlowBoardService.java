package com.sp.app.lounge.service;

import java.util.List;
import java.util.Map;

import com.sp.app.lounge.model.FlowBoard;

public interface FlowBoardService {
	public void insertBoard(FlowBoard dto, String uploadPath) throws Exception;
	public List<FlowBoard> listBoard(Map<String, Object> map);
	public List<FlowBoard> sortListBoard(Map<String, Object> map);
	public int dataCount(Map<String, Object> map);
	public FlowBoard findById(long num);
	public void updateHitCount(long num) throws Exception;
	public FlowBoard findByPrev(Map<String, Object> map);
	public FlowBoard findByNext(Map<String, Object> map);
	public void updateBoard(FlowBoard dto, String uploadPath) throws Exception;
	public void deleteBoard(long num, String uploadPath, String nickname, int grade) throws Exception;
	
	// 파일
	public List<FlowBoard> listFile(long num);
	public FlowBoard findByFileId(long fileNum);
	public void deleteFile(Map<String, Object> map) throws Exception;

	public boolean deleteUploadFile(String uploadPath, String filename);
	
	// 게시글 좋아요
	public void insertBoardLike(Map<String, Object> map) throws Exception;
	public void deleteBoardLike(Map<String, Object> map) throws Exception;
	public int boardLikeCount(long num);
	public boolean isMemberBoardLiked(Map<String, Object> map);
	
	// 게시글 신고
	public void insertBoardBlind(Map<String, Object> map) throws Exception;
	public Long reprtNum(Map<String, Object> map);
	
	// 댓글
	public void insertReply(FlowBoard dto) throws Exception;
	public int replyCount(Map<String, Object> map);
	public List<FlowBoard> listReply(Map<String, Object> map);
	public void deleteReply(Map<String, Object> map) throws Exception;
	
	// 댓글 좋아요
	public void insertReplyLike(Map<String, Object> map) throws Exception;
	public Map<String, Object> replyLikeCount(Map<String, Object> map);
	
	// 댓글 신고
	public void updateReplyBlind(Map<String, Object> map) throws Exception;
}
