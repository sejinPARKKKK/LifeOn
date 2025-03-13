<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>LifeOn</title>

<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/forms.css"
	type="text/css">

<style type="text/css">
.body-title {
	width: 80%;
	max-width: 900px;
	margin: auto;
	margin-top: 40px;
}

.board-article {
	width: 80%;
	max-width: 900px;
	margin: auto;
}

.table-borderless {
	width: 80%;
	max-width: 900px;
	margin: auto;
}

.form-header {
	width: 80%;
	max-width: 900px;
	margin: auto;
}

.bold {
	color: #006AFF;
}
</style>
</head>
<body>

	<header>
		<jsp:include page="/WEB-INF/views/layout/header.jsp" />
	</header>

	<main class="d-flex flex-column min-vh-100 align-items-center"
		style="padding-top: 66px;">
		<div class="container">
			<div class="body-container">
				<div class="body-title">
					<h3>
						<i class="bi bi-app"></i> 정책정보
					</h3>
				</div>

				<div class="body-main">
					<table class="table board-article">
						<thead>
							<tr>
								<td colspan="2" align="center">${dto.subject}</td>
							</tr>
						</thead>

						<tbody>
							<tr>
								<td width="50%">이름 : ${dto.nickname}</td>
								<td align="right">${dto.reg_date} | 조회수 ${dto.hitcount}</td>
							</tr>

							<tr>
								<td colspan="2" valign="top" height="200">${dto.content}</td>
							</tr>

							<tr>
								<td colspan="2" class="text-center p-3">
									<button type="button" class="btn btn-outline-primary btnSendBoardLike" title="좋아요">
										<i class="bi ${isUserLiked ? 'bi-suit-heart-fill' : 'bi-suit-heart'}"></i>&nbsp;&nbsp; <span id="boardLikeCount">${dto.boardLikeCount}</span>
									</button>
								</td>
							</tr>

							<tr>
								<td colspan="2">이전글 :
									<c:if test="${not empty prevDto}">
										<a href="${pageContext.request.contextPath}/policy/article/${prevDto.psnum}?${query}">${prevDto.subject}</a>
									</c:if>
								</td>
							</tr>

							<tr>
								<td colspan="2">다음글 :
									<c:if test="${not empty nextDto}">
										<a href="${pageContext.request.contextPath}/policy/article/${nextDto.psnum}?${query}">${nextDto.subject}</a>
									</c:if>
								</td>
							</tr>
						</tbody>
					</table>

					<table class="table table-borderless mb-2">
						<tr>
							<td width="50%">
									<c:if test="${sessionScope.member.grade == 1}">
										<button type="button" class="btn btn-light"
											onclick="location.href='${pageContext.request.contextPath}/policy/update?psnum=${dto.psnum}&page=${page}';">수정</button>
										<button type="button" class="btn btn-light"
											onclick="deleteOk();">삭제</button>
									</c:if>								
							</td>
							<td class="text-end">
								<button type="button" class="btn"
									onclick="location.href='${pageContext.request.contextPath}/policy/list';">리스트</button>
							</td>
						</tr>
					</table>

					<div class="reply">
						<form name="replyForm" method="post">
							<div class="form-header">
								<span class="bold">댓글</span> <span> - 타인을 비방하거나 개인정보를
									유출하는 글의 게시를 삼가해 주세요.</span>
							</div>

							<table class="table table-borderless reply-form">
								<tr>
									<td><textarea class="form-control" name="content"></textarea>
									</td>
								</tr>
								<tr>
									<td align="right">
										<button type="button" class="btn btn-light btnSendReply">댓글등록</button>
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

	
		<script type="text/javascript">
			function deleteOk() {
				if (confirm('게시글을 삭제하시겠습니까? ')) {
					let qs = 'psnum=${dto.psnum}&${query}';
					let url = '${pageContext.request.contextPath}/policy/delete?'
							+ qs;
					location.href = url;
				}
			}
		</script>


	<script type="text/javascript">
		$(function() {
			$('.btnSendBoardLike').click(function(){
				
				const $i = $(this).find('i');
				let userLiked = $i.hasClass('bi-suit-heart-fill');
				let msg = userLiked ? '게시글 공감을 취소하시겠습니까 ?' : '게시글에 공감하시겠습니까?';
				
				if(! confirm(msg)) {
					return false;
				}
				
				let url = '${pageContext.request.contextPath}/policy/insertBoardLike';
				let psnum = '${dto.psnum}';
				let params = {psnum:psnum, userLiked:userLiked};
				
				const fn = function(data) {
					let state = data.state;
					
					if(state === "true") {
						if( userLiked ) {
							$i.removeClass('bi-suit-heart-fill')
								.addClass('bi-suit-heart');
						} else {
							$i.removeClass('bi-suit-heart')
								.addClass('bi-suit-heart-fill');
						}
						
						let count = data.boardLikeCount;
						$('#boardLikeCount').text(count);
					} else if(state === "liked") {
						alert('게시글 공감은 한번만 가능합니다.')
					} else {
						alert('게시글 공감 여부 처리가 실패했습니다.')
					}
				};
				
				ajaxRequest(url, 'post', params, 'json', fn);
			});
		});	
	
		$(function() {
			listPage(1);
		});
		
		function listPage(page) {
			let url = '${pageContext.request.contextPath}/policy/listReply';
			let psnum = '${dto.psnum}';
			let params = {psnum:psnum, pageNo:page};
			
			const fn = function(data) {
				$('#listReply').html(data);
			};
			
			ajaxRequest(url, 'get', params, 'text', fn);
		}
		
$(function() {
	$('.btnSendReply').click(function(){
		let psnum = '${dto.psnum}';
		const $tb = $(this).closest('table');
		
		let content = $tb.find('textarea').val().trim();
		if(! content) {
			$tb.find('textarea').focus();
			return false;
		}
		
		let url = '${pageContext.request.contextPath}/policy/insertReply';
		let params = {psnum:psnum, content:content, parentNum:0};
		
		const fn = function(data) {
			$tb.find('textarea').val('');
			
			let state = data.state;
			if(state == 'true') {
				listPage(1);
			} else {
				alert('댓글을 추가하지 못했습니다.');
			}
		};
		ajaxRequest(url, 'post', params, 'json', fn);
	});
})

//댓글 삭제
$(function() {
	$('.reply').on('click', '.deleteReply', function () {
		if(! confirm('게시글을 삭제하시겠습니까?')) {
			return false;
		}
		
		let replyNum = $(this).attr('data-replyNum');
		let page = $(this).attr('data-pageNo');
		
		let url = '${pageContext.request.contextPath}/policy/deleteReply';
		let params = {replyNum:replyNum, mode:'reply'};
		
		const fn = function(data) {
			listPage(page);
		};
		
		ajaxRequest(url, 'post', params, 'json', fn);
		
	});
});

//삭제, 신고 메뉴입니다
$(function() {
	$('.reply').on('click', '.reply-dropdown', function () {
		const $menu = $(this).next('.reply-menu');
		
		if($menu.is(':visible')) {
			$menu.fadeOut(100);
		} else {
			$('.reply-menu').hide();
			$menu.fadeIn(100);
			
			let pos = $(this).offset();
			$mene.offset({left:pos.left-70, top:pos.top+20});
		}
	});
	
	$('.reply').on('click', function(evt) {
		if($(evt.target.parentNode).hasClass('reply-dropdown')) {
			return false;
		}
		$('.reply-menu').hide();
	});
});


//댓글 좋아요/싫어요
$(function() {
	$('.reply').on('click', '.btnSendReplyLike', function() {
		const $btn = $(this);
		let replyNum = $btn.attr('data-replyNum');
		let replyLike = $btn.attr('data-replyLike');
		let userLiked = $btn.parent('td').attr('data-userLiked');
		
		if(userLiked !== '-1') {
			return false;
		}
		
		let msg = '게시글이 마음에 들지 않습니까?';
		
		if(replyLike == '1') {
			
			msg = '게시글에 공감하십니까?';
		}
		if(! confirm(msg)) {
			return false;
		}
		
		let url = '${pageContext.request.contextPath}/policy/insertReplyLike';
		let params = {replyNum:replyNum, replyLike:replyLike};
		
		
		const fn = function(data) {
			let state = data.state;
			if(state == 'true') {
				let likeCount = data.likeCount;
				let disLikeCount = data.disLikeCount;
				
				$btn.parent('td').children().eq(0).find('span').html(likeCount);
				$btn.parent('td').children().eq(1).find('span').html(disLikeCount);
				
				$btn.parent('td').attr('data-userLiked' , replyLike);
				if(replyLike == '1') {
					$btn.css('color', '#00F');
				} else {
					$btn.css('color', '#F00');
				}
			} else if(state == 'liked') {
				alert('공감 여부는 한번만 가능합니다.');
			} else {
				alert('게시글 공감 여부 처리가 실패했습니다.');
			}
		};
		
		ajaxRequest(url, 'post', params, 'json', fn);
	});
});



//댓글별 답글 리스트 
function listReplyAnswer(parentNum) {
	let url = '${pageContext.request.contextPath}/policy/listReplyAnswer';
	let params = {parentNum:parentNum};
	
	const fn = function(data) {
		$('#listReplyAnswer' + parentNum).html(data);
	};
	ajaxRequest(url, 'get', params, 'text', fn);
}

//댓글별 답글 개수
function countReplyAnswer(parentNum) {
	let url = '${pageContext.request.contextPath}/policy/countReplyAnswer';
	let params = {parentNum:parentNum};
	
	const fn = function(data) {
		let count = data.count;
		$('#answerCount' + parentNum).html(count);
	};
	ajaxRequest(url, 'post', params, 'json', fn);
}



//댓글별 답글 등록 
$(function(){
	$('.reply').on('click', '.btnSendReplyAnswer', function(){
		let psnum = '${dto.psnum}';
		let replyNum = $(this).attr('data-replyNum');
		const $td = $(this).closest('td');
		
		let content = $td.find('textarea').val().trim();
		if(! content) {
			$td.find('textarea').focus();
			return false;
		}
		
		let url = '${pageContext.request.contextPath}/policy/insertReply';
		let params = {psnum:psnum, content:content, parentNum:replyNum};
		
		const fn = function(data) {
			$td.find('textarea').val('');
			
			let state = data.state;
			if(state === 'true') {
				listReplyAnswer(replyNum);	
				countReplyAnswer(replyNum);
			}
		};
		
		ajaxRequest(url, 'post', params, 'json', fn);
	});
});


//답글 버튼
$(function() {
	$('.reply').on('click', '.btnReplyAnswerLayout', function (){
		const $trAnswer = $(this).closest('tr').next();
		
		let isVisible = $trAnswer.is(':visible');
		let replyNum = $(this).attr('data-replyNum');
		
		if(isVisible) {
			$trAnswer.hide();
		} else {
			$trAnswer.show();
			
			listReplyAnswer(replyNum); //답글 리스트
			
			countReplyAnswer(replyNum); // 답글 개수
		}
	});
});
	</script>


	<footer class="mt-auto py-2 text-center w-100"
		style="left: 0px; bottom: 0px; background: #F7F9FA;">
		<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
	</footer>

	<jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />
</body>
</html>