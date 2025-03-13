<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<c:forEach var="prize" items="${listAnswer}">
	<div class="border-bottom m-1">
		<div class="row p-1">
			<div class="col-auto">
				<div class="row reply-writer">
					<div class="col-1"><i class="bi bi-person-circle text-muted icon"></i></div>
					<div class="col ms-2 align-self-center">
						<div class="name">${prize.nickName}</div>
						<div class="date">${prize.reg_date}</div>
					</div>
				</div>
			</div>
			<div class="col align-self-center text-end">
				<span class="reply-dropdown"><i class="bi bi-three-dots-vertical"></i></span>
				<div class="reply-menu">
					<c:choose>
						<c:when test="${sessionScope.member.id==prize.userId}">
							<div class="deleteReplyAnswer reply-menu-item" data-replyNum="${prize.replyNum}" data-parentNum="${prize.parentNum}">삭제</div>
							<div class="hideReplyAnswer reply-menu-item" data-replyNum="${prize.replyNum}" data-showReply="${prize.showReply}">${prize.showReply==1?"숨김":"표시"}</div>
						</c:when>
						<c:when test="">
							<div class="deleteReplyAnswer reply-menu-item" data-replyNum="${prize.replyNum}" data-parentNum="${prize.parentNum}">삭제</div>
							<div class="blockReplyAnswer reply-menu-item">신고</div>
						</c:when>
						<c:otherwise>
							<div class="notifyReplyAnswer reply-menu-item">신고</div>
							<div class="blockReplyAnswer reply-menu-item">차단</div>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>

		<div class="p-2 ${prize.showReply==0?'text-primary text-opacity-50':''}">
			${prize.content}
		</div>
	</div>
</c:forEach>
