package com.sp.app.lounge.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.lounge.model.FlowBoard;

@Mapper
public interface FlowBoardMapper {
	public long FlowBoardSeq();
	public void insertBoard(FlowBoard dto) throws SQLException;
	public void updateBoard(FlowBoard dto) throws SQLException;
	public void deleteBoard(long num) throws SQLException;
	
	// 파일
	public void updateFile(FlowBoard dto) throws SQLException;
	public List<FlowBoard> listFile(long num);
	public FlowBoard findByFileId(long fileNum);
	public void deleteFile(Map<String, Object> map) throws SQLException;
	
	public int dataCount(Map<String, Object> map);
	public List<FlowBoard> listBoard(Map<String, Object> map);
	public List<FlowBoard> sortListBoard(Map<String, Object> map);
	
	public FlowBoard findById(Long num);
	public void updateHitCount(long num) throws SQLException;
	public FlowBoard findByPrev(Map<String, Object> map);
	public FlowBoard findByNext(Map<String, Object> map);
	
	// 게시글 좋아요
	public void insertBoardLike(Map<String, Object> map) throws SQLException;
	public void deleteBoardLike(Map<String, Object> map) throws SQLException;
	public int boardLikeCount(long num);
	public FlowBoard memberBoardLiked(Map<String, Object> map);
	
	// 게시글 신고
	public void insertBoardBlind(Map<String, Object> map) throws SQLException;
	public Long reprtNum(Map<String, Object> map);
	
	// 댓글
	public void insertReply(FlowBoard dto) throws SQLException;
	public int replyCount(Map<String, Object> map);
	public List<FlowBoard> listReply(Map<String, Object> map);
	public void deleteReply(Map<String, Object> map) throws SQLException;
	
	// 댓글 좋아요
	public void insertReplyLike(Map<String, Object> map) throws SQLException;
	public Map<String, Object> replyLikeCount(Map<String, Object> map);
	public Optional<Integer> memberReplyLiked(Map<String, Object> map);
	
	// 댓글 신고
	public void updateReplyBlind(Map<String, Object> map) throws SQLException;
}
