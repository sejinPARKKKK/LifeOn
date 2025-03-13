package com.sp.app.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.model.Meeting;

@Mapper
public interface MeetingMapper {
	public Long meetingSeq();
	public void insertBoard(Meeting dto) throws SQLException;
	public void updateBoard(Meeting dto) throws SQLException;
	public void deleteBoard(long psnum) throws SQLException;
	
	public int dataCount(Map<String, Object> map);
	public List<Meeting> listBoard(Map<String, Object> map);

	public Meeting findById(long num);
	public void updateHitCount(long num) throws SQLException;
	
	public void boardLike(Map<String, Object> map) throws Exception;
	public void deleteBoardLike(Map<String, Object> map) throws Exception;
	public int boardLikeCount(long num);
	public Meeting memberBoardLiked(Map<String, Object> map);
	
	public void reply(Meeting dto) throws Exception;
	public int replyCount(Map<String, Object> map);
	public List<Meeting> listReply(Map<String, Object> map);
	public void deleteReply(Map<String, Object> map) throws Exception;
	
	public void replyLike(Map<String, Object> map) throws Exception;
	public Map<String, Object> replyLikeCount(Map<String, Object> map);
	public Optional<Integer> memberReplyLiked(Map<String, Object> map);
	
	public List<Meeting> listCategory();
	public Meeting findByCategory(long categoryNum);
}
