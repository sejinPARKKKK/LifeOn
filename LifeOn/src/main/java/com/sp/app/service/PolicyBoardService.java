package com.sp.app.service;

import java.util.List;
import java.util.Map;

import com.sp.app.model.PolicyBoard;
import com.sp.app.model.PolicyReply;

public interface PolicyBoardService {
	public void insertBoard(PolicyBoard dto, String uploadPath) throws Exception;
	public List<PolicyBoard> listBoard(Map<String, Object> map);
	public int dataCount(Map<String, Object> map);
	
	public PolicyBoard findById(long num);
	public void updateHitCount(long num) throws Exception;
	public PolicyBoard findByPrev(Map<String, Object> map);
	public PolicyBoard findByNext(Map<String, Object> map);
	
	public void updateBoard(PolicyBoard dto, String uploadPath) throws Exception;
	public boolean deleteUploadFile(String uploadPath, String filename);

	public void deleteBoard(long num, String uploadPath, String id, int grade) throws Exception;

	//게시글 좋아요
	public void insertBoardLike(Map<String, Object> map) throws Exception;
	public void deleteBoardLike(Map<String, Object> map) throws Exception;
	public int boardLikeCount(long psnum);
	public boolean isUserBoardLiked(Map<String, Object> map);

	//댓글
	public void insertReply(PolicyReply dto) throws Exception;
	public int replyCount(Map<String, Object> map);
	public List<PolicyReply> listReply(Map<String,Object> map);
	public void deleteReply(Map<String, Object> map) throws Exception;
	
	
	//댓글의 답글
	public List<PolicyReply> listReplyAnswer(Map<String,Object> map);
	public int replyAnswerCount(Map<String, Object> map);
	
	//댓글 좋아요 /싫어요
	public void insertReplyLike(Map<String,Object> map) throws Exception;
	public Map<String, Object> replyLikeCount(Map<String, Object> map);
	
	
}
