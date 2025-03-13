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
	<!-- 배너 -->
    <div class="body-title">
    	<em style="font-size: 30px; font-weight: 800; text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.3);">필요한 만큼만 빌려쓰는 가성비 소비를 경험하세요!</em>
	</div>
	
	<div class="body-container">
		<div class="rent_container" style="flex-direction: column;">
			<div style="display: flex; justify-content: flex-end;">
				<button type="button" class="search_btn" style="margin: 0;" onclick="location.href='${pageContext.request.contextPath}/market/rent/main?${query}';">목록</button>
			</div>
		    <div class="product-detail" style="margin: 20px 0 0;">
		    	<!-- 상품 이미지 -->
		        <div class="product-image">
		            <img class="thumbnail-img" src="${pageContext.request.contextPath}/uploadPath/rent/${dto.pph}" alt="물품사진">
		        </div>
				
        		<!-- 상품 정보 -->
        		<div class="product-info">
        			<div style="text-align: left; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #e0e0e0;">
	            		<div style="font-size: 24px; font-weight: 600;">${dto.pname}</div>
	            		<div>
		            		<div style="display: flex; justify-content: flex-end; align-items: center;">
								<div class="profile" style="margin: 5px; width: 25px; height: 25px; border-radius: 50%; border: 1px solid #e0e0e0; position: relative; overflow: hidden;">
									<img src="${pageContext.request.contextPath}${dto.profile_image}" class="profileImage" style="width: 100%; height: 100%;" name="profileImage" id="profileImage" alt="프로필">
								</div>	
		            			<p style="margin: 0; font-size: 16px;">${dto.nickname}</p>
							</div>
	            			<p style="margin-bottom: 5px; color: #777; font-size: 12px;">등록일 : ${dto.prd}</p>
	            		</div>
        			</div>
        			<div style="text-align: left; padding-top: 30px; display: flex; justify-content: space-between; align-items: flex-start;">
	        			<div>
		           			<p style="margin: 0; font-size: 20px;">1일 대여비</p>
		           			<p style="margin: 0; font-size: 24px;"><fmt:formatNumber value="${dto.prp}"/> 원</p>
	           			</div>
	           			<div>
	           				<p style="margin: 0; color: ${dto.prs == '대여가능' ? '#006AFF' : '#FFBB00'}; font-size: 24px; font-weight: 600">${dto.prs}</p>
	           			</div>
           			</div>
        			<div>
        				<c:if test="${empty dto.prad}">
		           			<div style="padding-top: 10px; margin-bottom: 5px; text-align: left; font-size: 18px;">보증금 : <fmt:formatNumber value="${dto.prlp}"/> 원</div>
	        				<p style="margin: 0; text-align: left; font-size: 16px;">거래장소 : ${dto.pra}</p>
		           			<div style="display: flex; justify-content: space-between; align-items: center; padding-top: 38px;">
			           			<div style="display: flex;">
			      					<c:choose>
										<c:when test="${sessionScope.member.nickName == dto.nickname}">
											<button type="button" class="search_btn" onclick="handleButtonClick();">수정</button>
								    		<button type="button" class="search_btn" onclick="deleteOk();">삭제</button>
										</c:when>
									</c:choose>
			           			</div>
			           			<div>
			        				<button type="button" class="search_btn btnSendProductLike" style="padding: 8px 10px; margin-right: 3px;" title="찜하기">
										<i class="bi ${isMemberLiked ? 'bi-suit-heart-fill redColor' : 'bi-suit-heart'}"></i>
										&nbsp;<span id="productLikeCount">${dto.productLikeCount}</span>
									</button>
				            		<button class="search_btn" style="margin: 0" onclick="javascript:dialogRentRequest();">대여신청</button>
				            	</div>
		           			</div>
        				</c:if>
        				<c:if test="${not empty dto.prad}">
		           			<div style="padding-top: 10px; margin-bottom: 5px; text-align: left; font-size: 18px;">보증금 : <fmt:formatNumber value="${dto.prlp}"/> 원</div>
	        				<p style="margin: 0; text-align: left; font-size: 16px;">거래장소 : ${dto.pra}</p>
	        				<p style="margin: 0; text-align: left; font-size: 16px;">상세정보 : ${dto.prad}</p>
		           			<div style="display: flex; justify-content: space-between; align-items: center; padding-top: 14px;">
			           			<div style="display: flex;">
			      					<c:choose>
										<c:when test="${sessionScope.member.nickName == dto.nickname}">
											<button type="button" class="search_btn" onclick="handleButtonClick();">수정</button>
								    		<button type="button" class="search_btn" onclick="deleteOk();">삭제</button>
										</c:when>
									</c:choose>
			           			</div>
			           			<div style="display: flex;">
			        				<button type="button" class="search_btn btnSendProductLike" style="padding: 8px 10px;" title="찜하기">
										<i class="bi ${isMemberLiked ? 'bi-suit-heart-fill redColor' : 'bi-suit-heart'}"></i>
										&nbsp;<span id="productLikeCount">${dto.productLikeCount}</span>
									</button>
				            		<button class="search_btn" style="margin: 0" onclick="javascript:dialogRentRequest();">대여신청</button>
				            	</div>
		           			</div>
        				</c:if>
        				
           			</div>
        		</div>
    		</div>
    		
		    <div class="product-detail">
		    	<div style="width: 100%; display: flex; flex-direction: column; align-items: flex-start; padding: 20px 0;">
			    	<p style="margin: 0 0 20px; color: #333; font-size: 24px; font-weight: 500;">상품소개</p>
	           		<p>${dto.pct}</p>
		    	</div>
		    </div>
		    
		    <div class="product-detail">
		    	<div style="width: 100%; display: flex; flex-direction: column; align-items: flex-start; padding: 20px 0 0;">
			    	<p style="color: #333; font-size: 24px; font-weight: 500; margin-bottom: 30px;">물품추가이미지</p>
			    	<c:if test="${empty listFile}">
						<p style="margin: 0 0 10px; color: #999; font-size: 16px;">추가된 물품 이미지가 없습니다.</p>
					</c:if>
					<c:if test="${not empty listFile}">
						<div style="display: grid; grid-template-columns: repeat(4, 200px); justify-content: space-between; width: 890px;">
							<c:forEach var="vo" items="${listFile}">
								<img style="width: 100%; height: 200px; object-fit: cover; margin-bottom: 20px;" src="${pageContext.request.contextPath}/uploadPath/rent/${vo.ppp}" alt="물품추가사진">
							</c:forEach>
						</div>
					</c:if>
		    	</div>
		    </div>
		    
		    <div class="product-detail" style="margin: 20px 0 0;">
		    	<div style="width: 100%; display: flex; flex-direction: column; align-items: flex-start; padding: 20px 0 60px;">
			    	<p style="color: #333; font-size: 24px; font-weight: 500; margin-bottom: 30px;">현재 판매자의 다른 대여물품</p>
					<c:if test="${empty memberProduct}">
						<p style="margin: 0 0 60px; color: #999; font-size: 16px;">판매자가 추가로 판매하는 대여물품이 없습니다.</p>
					</c:if>
					<c:if test="${not empty memberProduct}">
						<div class="tab_item">
							<div class="tab_content">
				               <div class="prod_detail_ct">
									<div class="cont_wrap">
										<ul class="product_list" id="product_list">
											<c:forEach var="vo" items="${memberProduct}" varStatus="status">
												<div style="display: flex; flex-direction: column; cursor: pointer;" onclick="location.href='<c:url value='/market/rent/article/${vo.pnum}?${query}'/>'">
													<img class="productImg" src="${pageContext.request.contextPath}/uploadPath/rent/${vo.pph}" alt="물품사진">
													<div class="productInfo">
														<p style="margin-bottom: 5px;"><b>${vo.pname}</b></p>
														<p style="margin-bottom: 5px;">대여비 : <fmt:formatNumber value="${vo.prp}"/> 원</p>
														<p style="margin: 0px;">보증금 : <fmt:formatNumber value="${vo.prlp}"/> 원</p>
													</div>
												</div>
											</c:forEach>
										</ul>
										<c:if test="${memberProductSize > 4}">
											<p class="controls">
												<span class="prev" onclick="prev();"><i class="bi bi-chevron-left"></i></span>
												<span class="next" onclick="next();"><i class="bi bi-chevron-right"></i></span>
											</p>
										</c:if>
									</div>
								</div>
							</div>
				    	</div>
					</c:if>
		    	</div>
		    </div>

		</div>
	</div>
</main>

<c:if test="${sessionScope.member.nickName == dto.nickname}">
	<script type="text/javascript">
		const prs = '${dto.prs}';
		
		function handleButtonClick() {
		    if (prs !== '대여가능') {
		        alert('대여중인 경우 수정이 불가능합니다. 관리자에게 문의해주세요.');
		    } else {
		        location.href = '${pageContext.request.contextPath}/market/rent/update?pnum=${dto.pnum}&page=${page}';
		    }
		}
		
		function deleteOk() {
			if (prs !== '대여가능') {
		        alert('대여중인 경우 삭제가 불가능합니다. 관리자에게 문의해주세요.');
		        return false;
			}
			
			if (confirm('등록한 대여물품을 삭제 하시겠습니까?')) {
				let qs = 'pnum=${dto.pnum}&${query}';
				let url = '${pageContext.request.contextPath}/market/rent/delete?' + qs;
				location.href = url;
			}
		}
	</script>
</c:if>

<script type="text/javascript">
var differenceInDays = 0;
var totalValue = 0;
var totalResult = '';

function dialogRentRequest() {
	let memberNum = '${sessionScope.member.num}';
	let sellerNum = '${dto.num}';
	let productState = '${dto.prs}';
	
	if (memberNum !== sellerNum && productState === '대여중') {
		alert('대여 중인 물품은 대여신청을 할 수 없습니다.');
		$('#dialogRentRequest').modal('hide');
		return false;
	}
	
	if(memberNum === sellerNum) {
		alert('자기 자신의 물품은 대여신청을 할 수 없습니다.');
		$('#dialogRentRequest').modal('hide');  
		return false;
	} else {
		$('#dialogRentRequest').modal('show');  
	}
}

$(function() {
	$('#dialogRentRequest').on('hide.bs.modal', function() {
		$('button, input, select, textarea').each(function(){
			$(this).blur();
		});
	});
	
 	$('#submitRentProduct').on('click', function() {
 		let opsd = $('input[name="opsd"]').val();
        let oped = $('input[name="oped"]').val();
        
        if (! opsd) {
            alert("대여시작일을 선택해주세요.");
            return false;
        }
        
        if (! oped) {
            alert("대여종료일을 선택해주세요.");
            return false;
        }
        
        if (! confirm('총 결제금액은 ' + totalResult + '원 입니다. 결제하시겠습니까?')) {
        	return false;
        }

		let url = '${pageContext.request.contextPath}/market/rent/insertOrder';
		let pnum = '${dto.pnum}';
		let odp = '${dto.prp}';
		let opld = '${dto.prlp}';
		let params = {pnum: pnum, opsd: opsd, oped: oped, odp: odp, opld: opld, odq: differenceInDays, op: totalValue, ofp: totalValue};
		
		const fn = function(data) {
			let state = data.state;
			
		   if (state === 'true') {
		      $('#dialogRentRequest').modal('hide');
              alert("결제가 완료되었습니다.");
              
		      setTimeout(function() {
	              window.location.reload();
		      }, 1000);

		    } else if (state === 'noPoint') {
		    	alert("잔여 포인트가 부족합니다. 충전 후에 다시 이용해주세요.");
		    	$('#dialogRentRequest').modal('hide');  
		    	return false;
		    } else {
		        alert("오류가 발생했습니다. 다시 시도해주세요.");
		        $('#dialogRentRequest').modal('hide');  
		        return false;
		    }
		};
		
		ajaxRequest(url, 'post', params, 'json', fn);
	});
});
</script>

<div class="modal fade" id="dialogRentRequest" tabindex="-1" role="dialog" aria-labelledby="rentRequestModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" role="document">
		<div class="modal-content">
		
      		<div class="modal-header" style="display: flex; justify-content: space-between; padding: 10px 20px;">
        		<h5 class="modal-title">대여 신청하기</h5>
        		<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      		</div>
      		
      		<div class="modal-body" style="padding: 0px;">
       			<form id="rentRequestForm">
          			<div class="form-group">
			        	<table class="table table-hover reportable m-0">
		              		<tr>
		                		<td>
		                			<div style="padding: 10px 5px;">대여시작일자</div>
			                		<input type="date" class="free-control" style="margin-bottom: 10px;" name="opsd" id="dateInput">
		                		</td>
		              		</tr>
		              		<tr>
		                		<td>
		                			<div style="padding: 10px 5px;">대여종료일자</div>
		                			<input type="date" class="free-control" style="margin-bottom: 10px;" name="oped" id="dateEndInput" disabled>
		                		</td>
		              		</tr>
		              		<tr>
		              			<td>
		                			<div id="dateResult" style="padding: 8px 10px;"></div>
		              			</td>
		              		</tr>
			            </table>
			            <p style="text-align: left; margin: 0; padding: 20px; color: #555; font-size: 13px;">
				            1. 물건을 소중히 다뤄주세요!<br>
							대여한 물건은 사용자에게 소유된 자산입니다. 사용 중 파손이나 훼손이 발생하지 않도록 주의해 주세요. 훼손 시에는 사용자에게 보상 책임이 있을 수 있습니다.<br><br>
	
							2. 연체 시 보증금 차감<br>
							대여 기간을 초과하여 사용하면, 연체료가 부과되며 보증금에서 연체료가 차감될 수 있습니다. 연체가 반복될 경우, 추가적인 불이익이 있을 수 있으므로 기한을 꼭 지켜주세요.<br><br>
	
							3. 반납 전 상태 점검<br>
							물건을 반납하기 전에 상태를 점검하여 파손, 오염 등이 없는지 확인해 주세요. 반납 시 이상이 있을 경우, 수리비나 청소비가 발생할 수 있습니다.
			            </p>
			            <p style="text-align: center; margin: 0; padding: 15px; color: #000; border-top: 1px solid #e0e0e0;">위반 시 계약이 취소되거나 추가적인 비용이 부과될 수 있습니다.<br> 주의사항을 확인하셨나요?</p>
          				<div style="padding-bottom: 15px; text-align: center;">
	          				<input type="checkbox" id="agreement" onclick="toggleSubmitButton()"> 
	            			<label for="agreement">주의사항을 확인하고 동의합니다.</label>
            			</div>
          			</div>
        		</form>
      		</div>
      		
      		<div class="modal-footer" style="display: flex; justify-content: center;">
        		<button type="button" class="ssbtn" id="submitRentProduct" disabled>결제</button>
        		<button type="button" class="ssbtn" data-bs-dismiss="modal" aria-label="Close">닫기</button>
      		</div>
    	</div>
  	</div>
</div>

<script>
function toggleSubmitButton() {
    const checkbox = document.getElementById("agreement");
    const submitButton = document.getElementById("submitRentProduct");

    submitButton.disabled = !checkbox.checked;
}

const today = new Date();
today.setDate(today.getDate() + 1);
const tomorrow = today.toISOString().split('T')[0];

document.getElementById('dateInput').setAttribute('min', tomorrow);

document.getElementById('dateInput').addEventListener('input', function() {
    const dateInputValue = this.value;

    if (dateInputValue) {
    	document.getElementById('dateEndInput').value = '';
        dateEndInput.disabled = false;
        
        const dateEnd = new Date(dateInputValue);
        dateEnd.setDate(dateEnd.getDate() + 1);
        const dateEndStr = dateEnd.toISOString().split('T')[0];
        dateEndInput.setAttribute('min', dateEndStr);
    } else {
        dateEndInput.disabled = true;
    }
});

function calculateDateDifference() {
    const dateInputValue = document.getElementById('dateInput').value;
    const dateEndInputValue = document.getElementById('dateEndInput').value;

    if (dateInputValue && dateEndInputValue) {
        const dateInput = new Date(dateInputValue);
        const dateEnd = new Date(dateEndInputValue);

        const differenceInTime = dateEnd - dateInput;
        differenceInDays = differenceInTime / (1000 * 3600 * 24);
		
        const prp = parseInt('${dto.prp}', 10);
        const prlp =  parseInt('${dto.prlp}', 10);
        
        const prpValue = (differenceInDays * prp);
        const prpResult = prpValue.toLocaleString();
        
        totalValue = prpValue + prlp;
        totalResult = totalValue.toLocaleString();
        
        document.getElementById('dateResult').innerHTML = '<p style="margin-bottom: 10px;">총 대여비</p><fmt:formatNumber value="${dto.prp}"/>원 x ' + differenceInDays + '일 = ' + prpResult + '원 <p style="margin: 20px 0 10px;">총 결제금액</p>' + prpResult + '원 + <fmt:formatNumber value="${dto.prlp}"/>원  = ' + totalResult + '원';
    } else {
        document.getElementById('dateResult').textContent = "";
    }
}
document.getElementById('dateResult').textContent = "☑️ 대여일자를 선택해주세요.";
document.getElementById('dateEndInput').addEventListener('input', calculateDateDifference);
</script>

<script type="text/javascript">
const product_list = document.querySelector('#product_list');

const prevBtn = document.querySelector('.prev');
const nextBtn = document.querySelector('.next');

/* 사진 개수 */
const slideCount = parseInt('${memberProductSize}');
/* 현재 인덱스 */
let currentIdx = 0;

if (product_list) {
	if (slideCount < 5) {
		product_list.style.marginLeft = '0px';
	}

	/* 이미지 너비 */
	let slideWidth = 200;
	/* 이미지 간 간격 */
	let slideMargin = 30;
	/* 전체 너비 설정 */
	product_list.style.width = (slideWidth + slideMargin) * slideCount - slideMargin + 'px';
	/* 초기화 */
	product_list.style.left = '0px';
}

function moveSlideByButton (num) {
	product_list.style.left = -num * 230 + 'px';
    currentIdx = num;
}

function prev() {
	if (currentIdx > 0) {
    	moveSlideByButton(currentIdx - 1);
	}
}

function next() {
	if (currentIdx < slideCount - 4) {
    	moveSlideByButton(currentIdx + 1);
	}
}

</script>
<script type="text/javascript">
$(function() {
	$('.btnSendProductLike').click(function() {
		const $i = $(this).find('i');
		let memberLiked = $i.hasClass('bi-suit-heart-fill');
		let msg = memberLiked ? '찜을 취소하시겠습니까?' : '찜을 하시겠습니까?';
		
		if (! confirm(msg)) {
			return false;
		}
		
		let url = '${pageContext.request.contextPath}/market/rent/insertProductLike';
		let pnum = '${dto.pnum}';
		let params = {pnum: pnum, memberLiked: memberLiked};
		
		const fn = function(data) {
			let state = data.state;
			// alert(state);
			
			if (state === "true") {
				if (memberLiked) {
					$i.removeClass('bi-suit-heart-fill redColor').addClass('bi-suit-heart');
				} else {
					$i.removeClass('bi-suit-heart').addClass('bi-suit-heart-fill redColor');
				}
				
				let count = data.productLikeCount;
				$('#productLikeCount').text(count);
				
			} else if (state == "liked") {
				alert('찜은 한번만 가능합니다.');
			} else {
				alert('처리가 실패 했습니다.');
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