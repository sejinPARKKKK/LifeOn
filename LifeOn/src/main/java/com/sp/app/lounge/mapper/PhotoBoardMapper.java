package com.sp.app.lounge.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.lounge.model.PhotoBoard;

@Mapper
public interface PhotoBoardMapper {
	public long PhotoBoardSeq();
	public void insertBoard(PhotoBoard dto) throws SQLException;
	public void updateBoard(PhotoBoard dto) throws SQLException;
	public void deleteBoard(Map<String, Object> map) throws SQLException;
	
	public void updateFile(PhotoBoard dto) throws SQLException;
	public List<PhotoBoard> listFile(long num);
	public PhotoBoard findByFileId(long fileNum);
	public void deleteFile(Map<String, Object> map) throws SQLException;
	
	public int dataCount(Map<String, Object> map);
	public List<PhotoBoard> listBoard(Map<String, Object> map);

	public PhotoBoard findById(Map<String, Object> map);
	public void updateHitCount(long num) throws SQLException;
	public PhotoBoard findByPrev(Map<String, Object> map);
	public PhotoBoard findByNext(Map<String, Object> map);
	
	public void boardLike(Map<String, Object> map) throws Exception;
	public void deleteBoardLike(Map<String, Object> map) throws Exception;
	public int boardLikeCount(long num);
	public PhotoBoard memberBoardLiked(Map<String, Object> map);
	
	public void reply(PhotoBoard dto) throws Exception;
	public int replyCount(Map<String, Object> map);
	public List<PhotoBoard> listReply(Map<String, Object> map);
	public void deleteReply(Map<String, Object> map) throws Exception;
	
	public void replyLike(Map<String, Object> map) throws Exception;
	public Map<String, Object> replyLikeCount(Map<String, Object> map);
	public Optional<Integer> memberReplyLiked(Map<String, Object> map);
}
