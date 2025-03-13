<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>LifeOn</title>

<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/forms.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/photo.css" type="text/css">

<style type="text/css">
.body-container {
    width: 80%; /* 필요에 따라 조절 */
    max-width: 1200px; /* 원하는 최대 크기 설정 */
    margin: 0 auto; /* 좌우 여백을 동일하게 설정 */
    display: flex;
    justify-content: center; 
}

main section {width: 100% !important;}

#content img {
    max-width: 100%; /* 부모 요소 크기를 넘지 않도록 */
    height: auto; /* 비율 유지 */
    display: block;
    margin: center; /* 가운데 정렬 */
}

.freeForm {
     min-height: 800px; /* 게시글 기본 높이 설정 */
     margin: 0 auto; /* 좌우 여백 동일하게 설정 */
    
}

.freeForm p {
	display: flex;
    flex-direction: column;
    align-items: center;
}

.freeForm img {
    width: 50%;
}

#content {
    flex-grow: 1; /* 내용이 차지하는 공간을 균등하게 유지 */
    overflow-y: auto;
}

</style>

</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
	<jsp:include page="/WEB-INF/views/lounge2/layout/menu.jsp"/>
</header>
	
<main class="min-vh-100">
	<!-- 배너 -->
    
	<div class="body-container">
			
			<div class="main_content" style="margin-top: 60px;">
				<div class="freeForm">
					<table class="table board-article">
						<thead>
							<tr>
								<td colspan="2" style="width: 50%; text-align: center;">
								<div style="display: inline-block;">
									${dto.subject}
								</div>	
								</td>
							</tr>
						</thead>
						
						<tbody>
							<tr>
								<td width="40%;">
									<div style="display: flex; align-items: center;">
										<div class="profile" style="margin: 5px; width: 35px; height: 35px; border-radius: 50%; border: 1px solid #e0e0e0; position: relative; overflow: hidden;">
											<img src="${pageContext.request.contextPath}${dto.profile_image}" class="profileImage" style="width: 100%; height: 100%;" name="profileImage" id="profileImage" alt="프로필">
										</div>	
										<div style="font-size: 12px;">${dto.nickname}</div>
									</div>
								</td>
								<td align="right">
									${dto.reg_date} |조회 ${dto.hitCount}
								</td>
							</tr>
							
							<tr>
    							<td colspan="2" valign="top" height="200" style="border-bottom: none;">
							         ${dto.content}
							    </td>
							    
							<tr>
								<td colspan="2" align="right" style="font-size: 12px; border-bottom: none;">
									<div style="display: flex; justify-content: flex-end; align-items: flex-end; flex-wrap: wrap;">
								
										<div>
										<button type="button" class="ssbtn btnSendBoardLike" title="즐겨찾기">
										<i class="bi ${isMemberLiked ? 'bi-bookmark-fill likeColor' : 'bi-bookmark'}"></i>
										&nbsp;<span id="boardLikeCount">${dto.boardLikeCount}</span>
										</button>
											<button type="button" class="ssbtn" onclick="javascript:dialogReport();">신고하기</button>
										</div>
									</div>
								</td>
							</tr>
					
							<tr>
								<td colspan="2">
									<c:if test="${not empty dto.ssfname}">
										<p class="border text-secondary my-1 p-2">
											<i class="bi bi-folder2-open"></i> 첨부파일 다운로드 : 
											<a href="${pageContext.request.contextPath}/lounge1/download?num=${dto.psnum}">${dto.cpfname}</a>
										</p>
									</c:if>
								</td>
							</tr>
							<!--  -
							<tr>
								<td colspan="2">
									이전글 :
									<c:if test="${empty prevDto}">
										이전글이 없습니다.
									</c:if>
									<c:if test="${not empty prevDto}">
										<a href="${pageContext.request.contextPath}/lounge1/${bdtype}/article/${prevDto.psnum}?${query}">${prevDto.subject}</a>
									</c:if>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									다음글 :
									<c:if test="${empty nextDto}">
										다음글이 없습니다.
									</c:if>
									<c:if test="${not empty nextDto}">
										<a href="${pageContext.request.contextPath}/lounge1/${bdtype}/article/${nextDto.psnum}?${query}">${nextDto.subject}</a>
									</c:if>
								</td>
							</tr>
							-->
						</tbody>
					</table>
					
					<table class="table table-borderless">
						<tr>
							<td class="text-start">
								<c:choose>
									<c:when test="${sessionScope.member.nickName == dto.nickname}">
										<button type="button" class="btn btn-light" onclick="location.href='${pageContext.request.contextPath}/lounge1/${bdtype}/update?psnum=${dto.psnum}&page=${page}';">수정</button>
									</c:when>
								</c:choose>
								
								<c:choose>
									<c:when test="${sessionScope.member.nickName == dto.nickname || sessionScope.member.grade > 1}">
							    		<button type="button" class="btn btn-light" onclick="deleteOk();">삭제</button>
									</c:when>
								</c:choose>
							
							</td>
							<td class="text-end">
								<button type="button" class="btn btn-light" onclick="location.href='${pageContext.request.contextPath}/lounge1/${bdtype}?${query}';">리스트</button>
							</td>
						</tr>
					</table>
					
					<div class="reply">
						<form name="replyForm" method="post">

							
							<table class="table table-borderless reply-form">
								<tr>
									<td>
										<textarea class="free-control" name="rpcontent" placeholder="칭찬과 격려의 댓글은 작성자에게 큰 힘이 됩니다! 😊" style="background: #fdfeff; height: 100px;"></textarea>
									</td>
								</tr>
								<tr>
								   <td align="right">
										<button type="button" class="ssbtn btnSendReply">댓글등록</button>
									</td>
								 </tr>
							</table>
						</form>
						
						<div id="listReply"></div>
					</div>
				</div>
			</div>
		</div>
			


</main>

<c:if test="${sessionScope.member.nickName == dto.nickname || sessionScope.member.grade > 1}">
	<script type="text/javascript">
		function deleteOk() {
			if (confirm('게시글을 삭제 하시겠습니까?')) {
				let qs = 'psnum=${dto.psnum}&${query}';
				let url = '${pageContext.request.contextPath}/lounge1/${bdtype}/delete?' + qs;
				location.href = url;
			}
		}
	</script>
</c:if>

<script type="text/javascript">
$(function() {
    $('.reply').on('click', '.reply-dropdown', function() {
        const $menu = $(this).next('.reply-menu');

        if ($menu.is(':visible')) {
            $menu.fadeOut(100);
        } else {
            $('.reply-menu').fadeOut(100);
            $menu.fadeIn(100);
        }
    });

    $('.reply').on('click', function(evt) {
        if ($(evt.target).closest('.reply-dropdown').length) {
            return false;
        }
        
        $('.reply-menu').fadeOut(100);
    });
});
</script>


<script type="text/javascript">
$(function() {
	$('.btnSendBoardLike').click(function() {
		const $i = $(this).find('i');
		let memberLiked = $i.hasClass('bi-bookmark-fill');
		let msg = memberLiked ? '게시글 즐겨찾기를 취소하시겠습니까?' : '게시글 즐겨찾기를 하시겠습니까?';
		
		if (! confirm(msg)) {
			return false;
		}
		
		let url = '${pageContext.request.contextPath}/lounge1/{bdtype}/boardLike';
		let psnum = '${dto.psnum}';
		let params = {psnum: psnum, memberLiked: memberLiked};
		
		const fn = function(data) {
			let state = data.state;
			
			if (state === "true") {
				if (memberLiked) {
					$i.removeClass('bi-bookmark-fill').addClass('bi-bookmark');
				} else {
					$i.removeClass('bi-bookmark').addClass('bi-bookmark-fill');
				}
				
				let count = data.boardLikeCount;
				$('#boardLikeCount').text(count);
				
			} else if (state == "liked") {
				alert('게시글 공감은 한번만 가능합니다.');
			} else {
				alert('게시글 공감 여부 처리가 실패 했습니다.');
			}
		};
		
		ajaxRequest(url, 'post', params, 'json', fn);
	});
});

$(function() {
	listPage(1);
});

function listPage(page) {
	let url = '${pageContext.request.contextPath}/lounge1/{bdtype}/listReply';
	let rpnum = '${dto.rpnum}';
	let psnum = '${dto.psnum}';
	let params = {rpnum: rpnum, pageNo: page, psnum: psnum};
	
	const fn = function(data) {
		$('#listReply').html(data);
	};
	
	ajaxRequest(url, 'get', params, 'text', fn);
}

$(function(){
	$('.btnSendReply').click(function(){
		let rpnum = '${dto.rpnum}';
		let psnum = '${dto.psnum}';
		let num = '${dto.num}';
		const $tb = $(this).closest('table');
		
		let rpcontent = $tb.find('textarea').val().trim();
		if(! rpcontent) {
			alert('댓글 내용을 입력하세요.');
			$tb.find('textarea').focus();
			return false;
		}
		
		if(rpcontent.length > 300) {
			alert('300자 이하 댓글만 등록 가능합니다.');
			$tb.find('textarea').focus();
			return false;
		}
		
		let url = '${pageContext.request.contextPath}/lounge1/{bdtype}/reply';
		let params = {rpnum: rpnum, rpcontent: rpcontent, psnum: psnum, num: num};
		
		const fn = function(data) {
			$tb.find('textarea').val('');
			
			let state = data.state;
			if(state === 'true') {
				listPage(1);
			} else {
				alert('댓글을 추가하지 못했습니다.');
			}
		};
		
		ajaxRequest(url, 'post', params, 'json', fn);
		
	});
});

$(function() {
	$('.reply').on('click', '.deleteReply', function() {	
		if (! confirm('댓글을 삭제하시겠습니까?')) {
			return false;
		}
		
		let rpnum = $(this).attr('data-replyNum');
		let page = $(this).attr('data-pageNo');
		
		let url = '${pageContext.request.contextPath}/lounge1/{bdtype}/deleteReply';
		let params = {rpnum: rpnum, mode: 'reply'};
		
		const fn = function(data) {
			listPage(page);
		};
		
		ajaxRequest(url, 'post', params, 'json', fn);		
	});
});

$(function() {
	$('.reply').on('click', '.btnSendReplyLike', function() {	
		const $btn = $(this);
		let rpnum = $btn.attr('data-replyNum');
		let rplike = $btn.attr('data-replyLike');
		let memberLiked = $btn.parent('span').attr('data-memberLiked');
		
		if (memberLiked !== '-1') {
			alert('댓글 공감 여부는 한번만 가능합니다.');
			return false;
		}
		
		let msg = '이 댓글이 싫으신가요?';
		if (rplike === '1') {
			msg = '이 댓글에 공감하시나요?';
		}
		
		if (! confirm(msg)) {
			return false;
		}
		
		let url = '${pageContext.request.contextPath}/lounge1/{bdtype}/replyLike';
		let params = {rpnum: rpnum, rplike: rplike};
		
		const fn = function(data) {
			let state = data.state;
			if (state === 'true') {
				let likeCount = data.likeCount;
				let disLikeCount = data.disLikeCount;
				
				$btn.parent('span').children().eq(0).find('span').html(likeCount);
				$btn.parent('span').children().eq(1).find('span').html(disLikeCount);
				
				$btn.parent('span').attr('data-memberLiked', rplike);
				if (rplike === '1') {
					$btn.parent('span').children().eq(0).find('i').removeClass('bi-heart').addClass('bi-heart-fill disLikeColor');
				} else {
					$btn.parent('span').children().eq(1).find('i').removeClass('bi-heartbreak').addClass('bi-heartbreak-fill likeColor');
				}
				
			} else if (state === 'liked') {
				alert('공감 여부는 한번만 가능합니다.');
			} else {
				alert('댓글 공감 여부 처리가 실패했습니다.');
			}
		};
		
		ajaxRequest(url, 'post', params, 'json', fn);
	});
});


</script>

<footer class="mt-auto py-2 text-center w-100" style="left: 0px; bottom: 0px; background: #F7F9FA;">
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>