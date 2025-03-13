<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<style type="text/css">
.reply-info {
	padding-left: 180px;
}
</style>

<div class="cont">
	<div class="reply-info">
		<span class="reply-count">댓글 ${replyCount}개</span> 
		<span class="reply-count">목록, ${pageNo}/${total_page} 페이지</span>
	</div>

	<table class="table table-borderless">
		<c:forEach var="prize" items="${listReply}">
			<tr class="border table-light">
				<td width="50%">
					<div class="row reply-writer">
						<div class="col-1">
							<i class="bi bi-person-circle text-muted icon"></i>
						</div>
						<div class="col-auto align-self-center">
							<div class="name">${prize.nickName}</div>
							<div class="date">${prize.reg_date}</div>
						</div>
					</div>
				</td>
				<td width="50%" align="right" class="align-middle"><span
					class="reply-dropdown"><i class="bi bi-three-dots-vertical"></i></span>
					<div class="reply-menu">
						<c:choose>
							<c:when test="${sessionScope.member.nickName==prize.nickName}">
								<div class="deleteReply reply-menu-item"
                                     data-replyNum="${prize.replyNum}" data-pageNo="${pageNo}">삭제</div>
								<div class="hideReply reply-menu-item"
									data-replyNum="${prize.replyNum}"
									data-showReply="${prize.showReply}">${prize.showReply==1?"숨김":"표시"}</div>
							</c:when>
							<c:when test="">
								<div class="deleteReply reply-menu-item"
                                     data-replyNum="${prize.replyNum}" data-pageNo="${pageNo}">삭제</div>
								<div class="blockReply reply-menu-item">차단</div>
							</c:when>
							<c:otherwise>
								<div class="notifyReply reply-menu-item">신고</div>
								<div class="blockReply reply-menu-item">차단</div>
							</c:otherwise>
						</c:choose>
					</div></td>
			</tr>
			<tr>
				<td colspan="2" valign="top"
					class="${prize.showReply == 0 ? 'text-primary text-opacity-50':''}">${prize.content}</td>
			</tr>

			<tr>
				<td>
					<button type="button" class="btn btn-light btnReplyAnswerLayout"
						data-replyNum="${prize.replyNum}">
						답글 <span id="answerCount${prize.replyNum}">${prize.answerCount}</span>
					</button>
				</td>
				<td align="right" data-userLiked="${prize.userLiked}">
					<button type="button" class="btn btn-light btnSendReplyLike"
                            data-replyNum="${prize.replyNum}" data-replyLike="1" title="좋아요"
                            style="color:${prize.userLiked==1?'blue':'black'};">
						<i class="bi bi-hand-thumbs-up"></i> <span>${prize.likeCount}</span>
					</button>
					<button type="button" class="btn btn-light btnSendReplyLike"
                            data-replyNum="${prize.replyNum}" data-replyLike="0" title="싫어요"
                            style="color:${prize.userLiked==0?'red':'black'};">
						<i class="bi bi-hand-thumbs-down"></i> <span>${prize.disLikeCount}</span>
					</button>
				</td>
			</tr>

			<tr class="reply-answer">
				<td colspan="2">
					<div class="border rounded">
						<div id="listReplyAnswer${prize.replyNum}" class="answer-list"></div>
						<div>
							<textarea class="form-control m-2"></textarea>
						</div>
						<div class="text-end pe-2 pb-1">
							<button type="button" class="btn btn-light btnSendReplyAnswer"
								data-replyNum="${prize.replyNum}">답글 등록</button>
						</div>
					</div>
				</td>
			</tr>
		</c:forEach>
	</table>
</div>
<div class="page-navigation">${paging}</div>