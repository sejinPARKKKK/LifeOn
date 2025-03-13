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
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/market.css" type="text/css">

</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
	<jsp:include page="/WEB-INF/views/market/layout/menu.jsp"/>
</header>
	
<main class="min-vh-100">
	
	<div class="body-container">
		<div class="rent_container" style="flex-direction: column;">
			<div style="display: flex; justify-content: flex-end;">
				<button type="button" class="search_btn" style="margin: 0;" onclick="location.href='${pageContext.request.contextPath}/city/area/main?${query}';">목록</button>
			</div>
		    <div class="product-detail" style="margin: 20px 0 0;">
		    	<!-- 지역 이미지 -->
		        <div class="product-image">
		            <img class="thumbnail-img" src="${pageContext.request.contextPath}/uploadPath/area/${dto.thp}" alt="지역사진">
		        </div>
				
        		<!--  정보 -->
        		<div class="product-info">
        			<div style="text-align: left; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #e0e0e0;">
	            		<div style="font-size: 24px; font-weight: 600;">${dto.ssname}<h2 style="margin: 0; font-size: 20px;">${dto.rvsubject}</h2></div>
	            		<div>
		            		<div style="display: flex; justify-content: flex-end; align-items: center;">
					
							</div>
	            			<p style="margin-bottom: 5px; color: #777; font-size: 12px;">등록일 : ${dto.rvreg_date}</p>
	            			<p style="margin-bottom: 5px; color: #777; font-size: 12px; text-align: right;">조회수 : ${dto.hitCount}</p>
	            		</div>
        			</div>
        			<div style="text-align: left; padding-top: 30px; display: flex; justify-content: space-between; align-items: flex-start;">
	        			<div class="detail" style="text-align: center;">
	           				<p style="margin: 0; font-size: 25px;">${dto.rssubject}</p>
	           			</div>
	           			<div>
	           				 <button type="button" class="ssbtn btnSendBoardLike" style="text-align: right;"  title="즐겨찾기">
						       <i class="bi ${isMemberLiked ? 'bi-bookmark-fill likeColor' : 'bi-bookmark'}"></i>
						      &nbsp;<span id="boardLikeCount">${dto.boardLikeCount}</span></button>
	           			</div>
           			</div>
        			<div>
        				
           			</div>
        		</div>
    		</div>
    		
				    <div class="product-detail">
			           		<div id="map" style="margin-top:10px; width: 400px; height: 300px;"></div>
				    	<div class="product-de" style="width: 60%; margin-top:100px; display: flex; flex-direction: column; align-items: flex-start; padding: 20px 0;">
					    	<p style= "margin: 0 0 20px; color: #333; font-size: 24px; font-weight: 500;">${dto.rvcontent}</p>
				    	</div>
				    </div>
		  			  <div style="display: grid; margin-top:20px; grid-template-columns: repeat(4, 200px); text-align:right; width: 890px;">
							<c:forEach var="vo" items="${listFile}">
								<img style="width: 100%; height: 200px; object-fit: cover; margin-bottom: 20px;" src="${pageContext.request.contextPath}/uploadPath/area/${vo.ssfname}" alt="물품추가사진">
							</c:forEach>
						</div>
		    
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
</main>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=450aa7a7e3d437713d1b2f8ff91c8e44"></script>
<script type="text/javascript">
	
	var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
	var options = { //지도를 생성할 때 필요한 기본 옵션
		center: new kakao.maps.LatLng(37.498095, 127.027610), //지도의 중심좌표.
		level: 3 //지도의 레벨(확대, 축소 정도)
	};

	var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴
	
</script>
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
		
		let url = '${pageContext.request.contextPath}/city/area/boardLike';
		let rvnum = '${dto.rvnum}';
		let params = {rvnum: rvnum, memberLiked: memberLiked};
		
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
	let url = '${pageContext.request.contextPath}/city/area/listReply';
	let rpnum = '${dto.rpnum}';
	let rvnum = '${dto.rvnum}';
	let params = {rpnum: rpnum, pageNo: page, rvnum: rvnum};
	
	const fn = function(data) {
		$('#listReply').html(data);
	};
	
	ajaxRequest(url, 'get', params, 'text', fn);
}

$(function(){
	$('.btnSendReply').click(function(){
		let rpnum = '${dto.rpnum}';
		let rvnum = '${dto.rvnum}';
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
		
		let url = '${pageContext.request.contextPath}/city/area/reply';
		let params = {rpnum: rpnum, rpcontent: rpcontent, rvnum: rvnum, num: num};
		
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
		
		let url = '${pageContext.request.contextPath}/city/area/deleteReply';
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
			alert('댓글 공감은 한번만 가능합니다.');
			return false;
		}
		
		let msg = '이 댓글이 싫으신가요?';
		if (rplike === '1') {
			msg = '이 댓글에 공감하시나요?';
		}
		
		if (! confirm(msg)) {
			return false;
		}
		
		let url = '${pageContext.request.contextPath}/city/area/replyLike';
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
</script>
<footer class="mt-auto py-2 text-center w-100" style="left: 0px; bottom: 0px; background: #F7F9FA;">
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>