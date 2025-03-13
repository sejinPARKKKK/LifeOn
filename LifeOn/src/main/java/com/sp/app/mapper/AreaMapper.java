package com.sp.app.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.model.Area;

@Mapper
public interface AreaMapper {
	public Long areaSeq();
	public void insertBoard(Area Area) throws SQLException;
	public void insertBoardFile(Area dto) throws SQLException;
	
	public void updateBoard(Area dto) throws SQLException;
	public void deleteBoard(long rvnum) throws SQLException;
	
	public int dataCount(Map<String, Object> map);
	public List<Area> listBoard(Map<String, Object> map);
	public List<Area> bestArea(Map<String, Object> map); // 인기지역
	
	public List<Area> listAreaFile(long rvnum);
	public Area findByFileId(long fileNum);
	public void deleteAreaFile(Map<String, Object> map) throws SQLException;

	public Area findById(long rvnum);
	public void updateHitCount(long num) throws SQLException;
	
	public void boardLike(Map<String, Object> map) throws Exception;
	public void deleteBoardLike(Map<String, Object> map) throws Exception;
	public int boardLikeCount(long num);
	public Area memberBoardLiked(Map<String, Object> map);
	
	public void reply(Area dto) throws Exception;
	public int replyCount(Map<String, Object> map);
	public List<Area> listReply(Map<String, Object> map);
	public void deleteReply(Map<String, Object> map) throws Exception;
	
	public void replyLike(Map<String, Object> map) throws Exception;
	public Map<String, Object> replyLikeCount(Map<String, Object> map);
	public Optional<Integer> memberReplyLiked(Map<String, Object> map);
	
	public List<Area> listCategory();
	public Area findByCategory(long categoryNum);
}
