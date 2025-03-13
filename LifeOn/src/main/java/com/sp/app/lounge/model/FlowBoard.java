package com.sp.app.lounge.model;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class FlowBoard {
	// FREE_BOARD
    private long psnum; // 글번호
    private long num; // 회원번호
    private String id; // 회원아이디
    private String nickname; // 회원닉네임
    private String profile_image; // 회원프로필
    private String subject; // 글제목
    private String content; // 글내용
    private String reg_date; // 글등록일
    private String uddate; // 글수정일
    private String ipaddr; // ip주소
    
    private int blind; // 0: Default, 1: 블라인드처리
    private int hitCount; // 조회수
    
    // 댓글갯수 FREE_BOARD_REPLY,
    private int replyCount;
    // 즐겨찾기개수 FREE_BOARD_FAV
    private int boardLikeCount;
	
    // 파일 FREE_BOARD_FILE
    private long fnum; // 파일번호
	private String ssfname; // 서버에 저장된 파일명
	private String cpfname; // 클라이언트가 올린 파일명(원본파일명)
	private List<MultipartFile> selectFile;
	
	// 댓글 FREE_BOARD_REPLY
	private long rpnum; // 댓글번호
	private String rpcontent; // 댓글내용
	private String rpreg_date; // 댓글등록일
	private int rpblind; // 0: Default, 1: 블라인드처리
	private int rplike; // 0: 싫어요, 1: 좋아요
	
	// 댓글좋아요 FREE_BOARD_LIKE
	private int likeCount;
	private int disLikeCount;
	
	@Value("-1") // 초기값
	private int memberLiked;
}
