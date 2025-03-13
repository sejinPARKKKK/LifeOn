<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<div style="padding: 10px;">
	<c:if test="${replyCount >= 1}">
		<div class="reply-info" style="text-align: left; padding: 0px 5px 10px 5px;">
			<span class="bold">댓글 ${replyCount}개 </span>
			<span>[댓글목록, ${pageNo} / ${total_page} 페이지]</span>
		</div>
	</c:if>
		
	<table class="table table-hover">
		<c:forEach var="dto" items="${listReply}">
		<c:if test="${dto.rpblind == 0}">
			<tr class="border">
				<td style="width: 10%; vertical-align: baseline; padding-left: 15px;">
					<div class="profile" style="margin: 5px; width: 35px; height: 35px; border-radius: 50%; border: 1px solid #e0e0e0; position: relative; overflow: hidden;">
						<img src="${pageContext.request.contextPath}${dto.profile_image}" class="profileImage" style="width: 100%; height: 100%;" name="profileImage" id="profileImage" alt="프로필">
					</div>	
				</td>
				<td style="text-align: left;">
					<div>
						<div style="display: flex; justify-content: space-between; align-items: center;">
							<div class="name" style="font-weight: 600; padding: 5px 0px; display: flex; justify-content: flex-start;">
								${dto.nickname}
							</div>
							<div style="display: flex; justify-content: flex-end;">
								<span class="reply-dropdown" style="cursor: pointer;"><i class="bi bi-three-dots" style="padding-right: 20px;"></i></span>
								<div class="reply-menu" style="display: none; font-size: 11px; background: #fff; color: #333; position: absolute; border: 1px solid #e0e0e0; border-radius: 4px; margin-top: 15px; cursor: pointer;">
									<c:choose>
										<c:when test="${sessionScope.member.nickName == dto.nickname}">
											<div class="deleteReply reply-menu-item" data-replyNum="${dto.rpnum}" data-pageNo="${pageNo}">삭제</div>
										</c:when>
										<c:when test="${sessionScope.member.grade >= 1}">
											<div class="deleteReply reply-menu-item" data-replyNum="${dto.rpnum}" data-pageNo="${pageNo}">삭제</div>
											<div class="blindReply reply-menu-item" data-replyNum="${dto.rpnum}" data-replyBlind="${dto.rpblind}">신고</div>
										</c:when>
										<c:otherwise>
											<div class="notifyReply reply-menu-item">신고</div>
											<div class="blindReply reply-menu-item" data-replyNum="${dto.rpnum}" data-replyBlind="${dto.rpblind}">신고</div>
										</c:otherwise>
									</c:choose>
								</div>
							</div>
						</div>
						<div class="content" style="width: 90%;">${dto.rpcontent}</div>
						<div style="font-size: 12px; color: #777; padding-top: 5px; display: flex; justify-content: space-between; flex-wrap: wrap;">
							<div style="display: flex; justify-content: flex-start; flex-wrap: wrap;">
								${dto.rpreg_date}
							</div>
							<div style="display: flex; justify-content: flex-end; flex-wrap: wrap;">
								<span data-memberLiked="${dto.memberLiked}" style="padding-right: 20px; cursor: pointer;">
									<span class="btnSendReplyLike" data-replyNum="${dto.rpnum}" data-replyLike="1" title="좋아요" style="padding: 3px;">
										<i class="bi ${dto.rplike == 1 && dto.memberLiked == dto.rpnum ? 'bi-heart-fill redColor':'bi-heart'}"></i>
										<span>${dto.likeCount}</span>
									</span>
									<span class="btnSendReplyLike" data-replyNum="${dto.rpnum}" data-replyLike="0" title="싫어요" style="padding: 3px;">
										<i class="bi ${dto.rplike == 0 && dto.memberLiked == dto.rpnum ? 'bi-heartbreak-fill buleColor':'bi-heartbreak'}"></i>
										<span>${dto.disLikeCount}</span>
									</span>	        
								</span>
							</div>
						</div>
					</div>				
				</td>
			</tr>
			</c:if>
			<c:if test="${dto.rpblind == 1}">
			<tr class="border" style="height: 90px;">
				<td style="width: 10%">
				</td>
				<td style="width: 90%; text-align: left; vertical-align: middle;">
					<div style="color: #999;">
						<i class="bi bi-exclamation-circle"></i>&nbsp;&nbsp;신고에 의해 숨김 처리 되었습니다.
					</div>
				</td>
			</tr>
			</c:if>
		</c:forEach>
	</table>
	
	<div class="page-navigation">
		${paging}
	</div>			
</div>
