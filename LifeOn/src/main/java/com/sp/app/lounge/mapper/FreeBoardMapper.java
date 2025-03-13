package com.sp.app.lounge.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.lounge.model.FreeBoard;

@Mapper
public interface FreeBoardMapper {
	public long FreeBoardSeq();
	public void insertBoard(FreeBoard dto) throws SQLException;
	public void updateBoard(FreeBoard dto) throws SQLException;
	public void deleteBoard(long num) throws SQLException;
	
	// 파일
	public void updateFile(FreeBoard dto) throws SQLException;
	public List<FreeBoard> listFile(long num);
	public FreeBoard findByFileId(long fileNum);
	public void deleteFile(Map<String, Object> map) throws SQLException;
	
	public int dataCount(Map<String, Object> map);
	public List<FreeBoard> listBoard(Map<String, Object> map);
	public List<FreeBoard> sortListBoard(Map<String, Object> map);
	
	public FreeBoard findById(Long num);
	public void updateHitCount(long num) throws SQLException;
	public FreeBoard findByPrev(Map<String, Object> map);
	public FreeBoard findByNext(Map<String, Object> map);
	
	// 게시글 좋아요
	public void insertBoardLike(Map<String, Object> map) throws SQLException;
	public void deleteBoardLike(Map<String, Object> map) throws SQLException;
	public int boardLikeCount(long num);
	public FreeBoard memberBoardLiked(Map<String, Object> map);
	
	// 게시글 신고
	public void insertBoardBlind(Map<String, Object> map) throws SQLException;
	public Long reprtNum(Map<String, Object> map);
	
	// 댓글
	public void insertReply(FreeBoard dto) throws SQLException;
	public int replyCount(Map<String, Object> map);
	public List<FreeBoard> listReply(Map<String, Object> map);
	public void deleteReply(Map<String, Object> map) throws SQLException;
	
	// 댓글 좋아요
	public void insertReplyLike(Map<String, Object> map) throws SQLException;
	public Map<String, Object> replyLikeCount(Map<String, Object> map);
	public Optional<Integer> memberReplyLiked(Map<String, Object> map);
	
	// 댓글 신고
	public void updateReplyBlind(Map<String, Object> map) throws SQLException;
	
	// 회원이 즐겨찾기한 리스트
	public List<FreeBoard> memberBoradLike(Map<String, Object> map);
	public int likeDataCount(Map<String, Object> map);
}
