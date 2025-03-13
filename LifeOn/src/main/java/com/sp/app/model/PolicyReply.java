package com.sp.app.model;

import org.springframework.beans.factory.annotation.Value;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Getter
@Setter
@NoArgsConstructor
public class PolicyReply {
	private long replyNum;
	private long psnum;
	private String userId;
	private String nickName;
	private String content;
	private String reg_date;
	private long parentNum;
	private int showReply;
	private int block;
	
	private int answerCount;
	private int likeCount;
	private int disLikeCount;
	
	@Value("-1")
	private int userLiked;
}
