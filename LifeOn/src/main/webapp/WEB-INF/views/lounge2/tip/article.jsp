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
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/free.css" type="text/css">

</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
	<jsp:include page="/WEB-INF/views/lounge2/layout/menu.jsp"/>
</header>
	
<main class="min-vh-100">
	<!-- 배너 -->
    <div class="body-title">
    	<em style="font-size: 30px; font-weight: 800; text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.3);">나만 알고 싶던 생활 정보, 여기서 만나보세요!</em>
	</div>
	
	<div class="body-container">
		<div class="body-content">
			<aside class="sidenav">
			</aside>
			
			<div class="main_content">
				<div class="freeForm">
					<table class="table board-article" style="table-layout: fixed;">
						<thead>
							<tr>
								<td colspan="2" style="font-size: 24px; font-weight: 800; word-wrap: break-word;">
									${dto.subject}
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
										<div style="font-size: 16px;">${dto.nickname}</div>
									</div>
								</td>
								<td align="right">
									<div>조회수 ${dto.hitCount}회</div>
								</td>
							</tr>
							
							<tr>
								<td colspan="2" valign="top" height="200" style="border-bottom: none; padding: 40px 20px 20px 20px; font-size: 16px;">
									${dto.content}
								</td>
							</tr>
							<tr>
								<td colspan="2" align="left" style="font-size: 12px; border-bottom: none;">
									<div style="display: flex; justify-content: space-between; align-items: flex-end; flex-wrap: wrap;">
										<div>
											<span>등록일 ${dto.reg_date}</span>
											<c:if test="${not empty dto.uddate}">
												<span> · 최근수정일 ${dto.uddate}</span>
											</c:if>
										</div>
										<div>
										<button type="button" class="ssbtn btnSendBoardLike" title="즐겨찾기">
										<i class="bi ${isMemberLiked ? 'bi-bookmark-fill buleColor' : 'bi-bookmark'}"></i>
										&nbsp;<span id="boardLikeCount">${dto.boardLikeCount}</span>
										</button>
											<button type="button" class="ssbtn" onclick="javascript:dialogReport();">신고하기🚨</button>
										</div>
									</div>
								</td>
							</tr>
	
							<tr>
								<td colspan="2">
									<c:forEach var="vo" items="${listFile}" varStatus="status">
										<p class="border text-secondary my-1 p-2">
											<i class="bi bi-folder2-open"></i> 첨부파일 다운로드 : 
											<a href="${pageContext.request.contextPath}/lounge2/tip/download?fnum=${vo.fnum}">${vo.cpfname}</a>
										</p>
									</c:forEach>
								</td>
							</tr>
							
							<tr>
								<td colspan="2" style="word-wrap: break-word;">
									<c:if test="${empty prevDto}">
										이전글 : 이전글이 없습니다.
									</c:if>
									<c:if test="${not empty prevDto}">
										<a href="${pageContext.request.contextPath}/lounge2/tip/article/${prevDto.psnum}?${query}">이전글 : ${prevDto.subject}</a>
									</c:if>
								</td>
							</tr>
							<tr>
								<td colspan="2" style="word-wrap: break-word;">
									<c:if test="${empty nextDto}">
										다음글 : 다음글이 없습니다.
									</c:if>
									<c:if test="${not empty nextDto}">
										<a href="${pageContext.request.contextPath}/lounge2/tip/article/${nextDto.psnum}?${query}">다음글 : ${nextDto.subject}</a>
									</c:if>
								</td>
							</tr>
						</tbody>
					</table>
					
					<table class="table table-borderless">
						<tr>
							<td class="text-start">
								<c:choose>
									<c:when test="${sessionScope.member.nickName == dto.nickname}">
										<button type="button" class="ssbtn" onclick="location.href='${pageContext.request.contextPath}/lounge2/tip/update?psnum=${dto.psnum}&page=${page}';">수정</button>
									</c:when>
								</c:choose>
								
								<c:choose>
									<c:when test="${sessionScope.member.nickName == dto.nickname || sessionScope.member.grade >= 1}">
							    		<button type="button" class="ssbtn" onclick="deleteOk();">삭제</button>
									</c:when>
								</c:choose>
							</td>
							<td class="text-end">
								<button type="button" class="ssbtn" onclick="location.href='${pageContext.request.contextPath}/lounge2/tip?${query}';">리스트</button>
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

			<aside class="sidebar">
			</aside>
		</div>
	</div>

</main>

<c:if test="${sessionScope.member.nickName == dto.nickname || sessionScope.member.grade >= 1}">
	<script type="text/javascript">
		function deleteOk() {
			if (confirm('게시글을 삭제 하시겠습니까?')) {
				let qs = 'psnum=${dto.psnum}&${query}';
				let url = '${pageContext.request.contextPath}/lounge2/tip/delete?' + qs;
				location.href = url;
			}
		}
	</script>
</c:if>

<script type="text/javascript">
function dialogReport() {
	let memberNum = '${sessionScope.member.num}';
	let reprtNum = '${reprtNum}';
	
	if(memberNum === reprtNum) {
		alert('이미 이 게시글은 신고하셨습니다. 신고하신 내용은 관리자 검토 후 조치 됩니다.');
		$('#dialogReport').modal('hide');  
	} else {
		$('#dialogReport').modal('show');  
	}
}

function reset() {
    $('input[name="repr"]').prop('checked', false);
    $('textarea[name="addrepr"]').val('');
    $('textarea[name="addrepr"]').hide();
}

$(function() {
	$('#dialogReport').on('hide.bs.modal', function() {
		$('button, input, select, textarea').each(function(){
			$(this).blur();
		});
	});
	
    $('input[name="repr"]').on('change', function() {
        if ($('#radio8').is(':checked')) {
            $('textarea[name="addrepr"]').show();
        } else {
            $('textarea[name="addrepr"]').hide();
        }
    });
	
 	$('#submitReport').on('click', function() {
 		let repr = $('input[name="repr"]:checked').val();
        let addrepr = $('textarea[name="addrepr"]').val();
      	
        if ($('#radio8').is(':checked')) {
            repr = addrepr;
        }
        
        if (! repr) {
            alert("신고 사유를 선택해주세요.");
            return false;
        }
        
        if (repr === '8' && addrepr.length < 1) {
	        alert("기타 사유를 입력해주세요.");
	        $('textarea[name="addrepr"]').focus();
	        return false;
        }
        
        if (addrepr.length > 300) {
            alert("최대 300자 까지만 입력 가능합니다.");
            $('textarea[name="addrepr"]').val(addrepr.substring(0, 300));
            return false;
        }
        
        if (! confirm('허위 신고 시 운영정책에 따라 조치 될 수 있습니다. 정말로 신고하시겠습니까?')) {
        	return false;
        }

		let url = '${pageContext.request.contextPath}/lounge2/tip/boardBlind';
		let repan = '${dto.psnum}';
		let params = {repan: repan, repr: repr};
		
		const fn = function(data) {
			let state = data.state;
			
		   if (state === 'true') {
		      $('#dialogReport').modal('hide');
		            
              alert("신고가 접수가 완료되었습니다.");
              
		      setTimeout(function() {
	              window.location.reload();
		      }, 1000);
		      
		    } else {
		        alert("오류가 발생했습니다. 다시 시도해주세요.");
		        return false;
		    }
		};
		
		ajaxRequest(url, 'post', params, 'json', fn);
	});
});
</script>

<div class="modal fade" id="dialogReport" tabindex="-1" role="dialog" aria-labelledby="reportModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" role="document">
		<div class="modal-content">
		
      		<div class="modal-header" style="display: flex; justify-content: space-between; padding: 10px 20px;">
        		<h5 class="modal-title" id="reportModalLabel">게시글 신고하기</h5>
        		<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="reset();"></button>
      		</div>
      		
      		<div class="modal-body" style="padding: 5px 0px;">
       			<form id="reportForm">
          			<div class="form-group">
			        	<table class="table table-hover reportable m-0">
			            	<thead>
			              		<tr>
			                		<th>
				                		신고사유를 알려주세요
				                		<p style="text-align: left; margin: 0; color: #999; font-weight: 400;">신고하신 내용은 관리자 검토 후 조치 됩니다.</p>
			                		</th>
			              		</tr>
			            	</thead>
			            	<tbody>
			              		<tr>
			                		<td>
				                		<input type="radio" id="radio1" name="repr" value="스팸홍보/도배글 입니다." class="reportReasonRadio">
				                		<label for="radio1" style="width: 90%">스팸홍보/도배글 입니다.</label>
			                		</td>
			              		</tr>
			              		<tr>
			                		<td>
			                			<input type="radio" id="radio2" name="repr" value="불법정보를 포함하고 있습니다." class="reportReasonRadio">
			                			<label for="radio2" style="width: 90%">불법정보를 포함하고 있습니다.</label>
			                		</td>
			              		</tr>
			              		<tr>
			                		<td>
			                			<input type="radio" id="radio3" name="repr" value="청소년에게 유해한 내용입니다." class="reportReasonRadio">
			                			<label for="radio3" style="width: 90%">청소년에게 유해한 내용입니다.</label>
			                		</td>
			              		</tr>
			              		<tr>
			                		<td>
			                			<input type="radio" id="radio4" name="repr" value="욕설/생명경시/혐오/차별적 표현입니다." class="reportReasonRadio">
			                			<label for="radio4" style="width: 90%">욕설/생명경시/혐오/차별적 표현입니다.</label>
			                		</td>
			              		</tr>
			             		<tr>
			                		<td>
			                			<input type="radio" id="radio5" name="repr" value="음란물 입니다." class="reportReasonRadio">
			                			<label for="radio5" style="width: 90%">음란물 입니다.</label>
			                		</td>
			              		</tr>
			              		<tr>
			                		<td>
			                			<input type="radio" id="radio6" name="repr" value="불쾌한 표현이 있습니다." class="reportReasonRadio">
			                			<label for="radio6" style="width: 90%">불쾌한 표현이 있습니다.</label>
			                		</td>
			              		</tr>
			              		<tr>
				                	<td>
				                		<input type="radio" id="radio7" name="repr" value="개인정보 노출 게시물 입니다." class="reportReasonRadio">
				                		<label for="radio7" style="width: 90%">개인정보 노출 게시물 입니다.</label>
		                			</td>
			              		</tr>
			              		<tr>
			                		<td style="border-bottom: none;">
			                			<input type="radio" id="radio8" name="repr" value="" class="reportReasonRadio">
			                			<label for="radio8" style="width: 90%;">기타</label>
			                			<textarea class="free-control" name="addrepr" style="margin-top: 5px; display:none;" placeholder="신고하시는 기타 이유를 입력해주세요. (최대글자는 300자 입니다.)"></textarea>
			                		</td>
			              		</tr>
			            	</tbody>
			            </table>
			            <p style="text-align: center; margin: 0; padding: 10px; padding-top: 15px; color: #999; border-top: 1px solid #e0e0e0;">신고하게 된 사유를 자세히 작성해주시면 관리자의 결정에 도움이 됩니다.</p>
          			</div>
        		</form>
      		</div>
      		
      		<div class="modal-footer" style="display: flex; justify-content: center;">
        		<button type="button" class="ssbtn" id="submitReport">신고하기</button>
        		<button type="button" class="ssbtn" data-bs-dismiss="modal" aria-label="Close" onclick="reset();">닫기</button>
      		</div>
    	</div>
  	</div>
</div>

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
		
		let url = '${pageContext.request.contextPath}/lounge2/tip/insertBoardLike';
		let psnum = '${dto.psnum}';
		let params = {psnum: psnum, memberLiked: memberLiked};
		
		const fn = function(data) {
			let state = data.state;
			// alert(state);
			
			if (state === "true") {
				if (memberLiked) {
					$i.removeClass('bi-bookmark-fill buleColor').addClass('bi-bookmark');
				} else {
					$i.removeClass('bi-bookmark').addClass('bi-bookmark-fill buleColor');
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
	let url = '${pageContext.request.contextPath}/lounge2/tip/listReply';
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
		
		let url = '${pageContext.request.contextPath}/lounge2/tip/insertReply';
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
		
		let url = '${pageContext.request.contextPath}/lounge2/tip/deleteReply';
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
		
		let url = '${pageContext.request.contextPath}/lounge2/tip/insertReplyLike';
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
					$btn.parent('span').children().eq(0).find('i').removeClass('bi-heart').addClass('bi-heart-fill redColor');
				} else {
					$btn.parent('span').children().eq(1).find('i').removeClass('bi-heartbreak').addClass('bi-heartbreak-fill buleColor');
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

$(function() {
	$('.reply').on('click', '.blindReply', function() {	
		let $menu = $(this);
		
		let rpnum = $(this).attr('data-replyNum');
		let rpblind = $(this).attr('data-replyBlind');
		
		if (! confirm('허위 신고 시 운영정책에 따라 조치 될 수 있습니다. 정말로 이 댓글을 신고하시겠습니까?')) {
			return false;
		}
		alert('댓글 신고처리가 완료되었습니다.');
		
		rpblind = rpblind === '1' ? '0' : '1';
		
		let url = '${pageContext.request.contextPath}/lounge2/tip/replyBlind';
		let params = {rpnum: rpnum, rpblind: rpblind};
		
		const fn = function(data) {
			let tableHtml = ''
			
			tableHtml += '<table class="table table-hover">';
			tableHtml += '<tr class="border">';
			tableHtml += '<td style="width: 10%"></td>';
			tableHtml += '<td style="width: 90%; padding: 35px 0; text-align: left; vertical-align: middle;">';
			tableHtml += '<div style="color: #999;">';
			tableHtml += '<i class="bi bi-exclamation-circle"></i>&nbsp;&nbsp;신고에 의해 숨김 처리 되었습니다.';		
			tableHtml += '</div></td></tr></table>';

			$menu.closest('tr').html(tableHtml);
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