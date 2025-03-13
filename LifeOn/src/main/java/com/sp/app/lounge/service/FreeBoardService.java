package com.sp.app.lounge.service;

import java.util.List;
import java.util.Map;

import com.sp.app.lounge.model.FreeBoard;

public interface FreeBoardService {
	public void insertBoard(FreeBoard dto, String uploadPath) throws Exception;
	public List<FreeBoard> listBoard(Map<String, Object> map);
	public List<FreeBoard> sortListBoard(Map<String, Object> map);
	public int dataCount(Map<String, Object> map);
	public FreeBoard findById(long num);
	public void updateHitCount(long num) throws Exception;
	public FreeBoard findByPrev(Map<String, Object> map);
	public FreeBoard findByNext(Map<String, Object> map);
	public void updateBoard(FreeBoard dto, String uploadPath) throws Exception;
	public void deleteBoard(long num, String uploadPath, String nickname, int grade) throws Exception;
	
	// 파일
	public List<FreeBoard> listFile(long num);
	public FreeBoard findByFileId(long fileNum);
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
	public void insertReply(FreeBoard dto) throws Exception;
	public int replyCount(Map<String, Object> map);
	public List<FreeBoard> listReply(Map<String, Object> map);
	public void deleteReply(Map<String, Object> map) throws Exception;
	
	// 댓글 좋아요
	public void insertReplyLike(Map<String, Object> map) throws Exception;
	public Map<String, Object> replyLikeCount(Map<String, Object> map);
	
	// 댓글 신고
	public void updateReplyBlind(Map<String, Object> map) throws Exception;
	
	// 회원이 즐겨찾기한 리스트
	public List<FreeBoard> memberBoradLike(Map<String, Object> map);
	public int likeDataCount(Map<String, Object> map);
}
