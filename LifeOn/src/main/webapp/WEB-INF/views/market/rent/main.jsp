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

<script type="text/javascript">
function elapsedText(date) {
	const seconds = 1;
	const minute = seconds * 60;
	const hour = minute * 60;
	const day = hour * 24;
	const year = 365 * day;
	
	var today = new Date();
	var elapsedTime = Math.trunc((today.getTime() - date.getTime()) / 1000);
	
	var elapsedText = "";
	if (elapsedTime < seconds) {
		elapsedText = "방금 전";
	} else if (elapsedTime < minute) {
		elapsedText = elapsedTime + "초 전";
	} else if (elapsedTime < hour) {
		elapsedText = Math.trunc(elapsedTime / minute) + "분 전";
	} else if (elapsedTime < day) {
		elapsedText = Math.trunc(elapsedTime / hour) + "시간 전";
 	} else {
		elapsedText = Math.trunc(elapsedTime / day) + "일 전";
/* 	3일 이후, 1년 후 날짜를 다르게 하고 싶을 경우
	} else if (elapsedTime < (day * 3)) {
		elapsedText = Math.trunc(elapsedTime / day) + "일 전";
	} else if (elapsedTime >= year) {
		elapsedText = (date.getFullYear() + '').slice(-2) + "-" + (date.getMonth() + 1).toString().padStart(2, '0') + "-" + date.getDate().toString().padStart(2, '0');
	} else {
		elapsedText = (date.getMonth() + 1).toString().padStart(2, '0') + "월 " + date.getDate().toString().padStart(2, '0') + "일";
*/
	}
	
	return elapsedText;
}
</script>

</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
	<jsp:include page="/WEB-INF/views/market/layout/menu.jsp"/>
</header>
	
<main class="min-vh-100">
	<!-- 배너 -->
    <div class="body-title">
    	<em style="font-size: 30px; font-weight: 800; text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.3);">자주쓰지 않는 물건, 대여해서 사용해보세요!</em>
	</div>
	
	<!-- 카테고리 메뉴 -->
	<div class="category_tab" id="category_tab">
		<nav class="category_nav">
			<ul>
				<li class="topMenuLi">
	                <a class="menuLink" style="width: calc(1278px / ${listCategory.size() + 1});" onclick="location.href='<c:url value='/market/rent/main'/>'">전체</a>
	            </li>
	            
	            <c:forEach var="main" items="${listCategory}">
		            <li class="topMenuLi">
		                <a class="menuLink" style="width: calc(1278px / ${listCategory.size() + 1});" onclick="location.href='<c:url value='/market/rent/main?cbn=${main.cbn}'/>'" data-cbc="${main.cbc}">${main.cbc}</a>
		                <ul class="submenu">
		                	<c:forEach var="sub" items="${main.listSub}">
		                    	<li class="submenuLink" style="width: calc(1280px / ${main.listSub.size()});" onclick="location.href='<c:url value='/market/rent/main?csn=${sub.csn}'/>'"><a class="subLink" ></a>${sub.csc}</li>
		                	</c:forEach>
		                </ul>
		            </li>
	            </c:forEach>

			</ul>
		</nav>
	</div>
	
	<!-- 카테고리 타이틀-->
    <div class="category_title" id="category_title">
    	<div>
        	<h4 id="cbn-value" style="margin: 0; font-weight: 500;">전체</h4>
		</div>
        <div>
            <span>
            	<em>${dataCount}</em> 개의 대여물품이 있습니다.
            </span>
		</div>
    </div>
	
	<div class="body-container">
		<div class="product_group">
			<aside class="product_best" id=product_best>
	       		<h5 style="margin: 0; padding: 10px 20px; text-align: center; font-weight: 600;">✨ BEST ✨</h5>
	       		
		       	<table class="table productTable" style="table-layout: fixed; margin: 0;">
					<c:if test="${empty bestList}">
		             		<tr>
							<td style="padding: 15px 25px; word-wrap: break-word; border-top: 1px solid #e0e0e0; border-bottom: none;">
								<div style="padding-bottom:3px; text-align: left;">
									인기있는 <br>대여물품이 없습니다.😢
								</div>
							</td>
		             		</tr>
					</c:if>
					<c:forEach var="dto" items="${bestList}" varStatus="status">
		             		<c:if test="${status.index < 5}">
		              		<tr>
								<td style="padding: 20px; word-wrap: break-word; border-top: 1px solid #e0e0e0;">
									<div class="bestProduct" onclick="location.href='<c:url value='${articleUrl}/${dto.pnum}?${query}'/>'" style="cursor: pointer;">
										<div class="rankText">${status.index + 1}</div>
										<div class="bestProduct_imgBox">
											<img class="bestProduct_img" src="${pageContext.request.contextPath}/uploadPath/rent/${dto.pph}" alt="물품사진">
										</div>
										<div style="text-align: left; padding: 8px; display: flow;">
											<div style="margin-bottom: 3px; font-size: 15px; font-weight: bold; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${dto.pname}</div>
											<span>대여비 <fmt:formatNumber value="${dto.prp}"/>원/일</span><br>
											<span>보증금 <fmt:formatNumber value="${dto.prlp}"/>원</span>
										</div>
									</div>
								</td>
		              		</tr>
		             		</c:if>
					</c:forEach>
		    	</table>
        	</aside>
        	
        	
			<div class="product_content">
				<div style="display: flex; justify-content: space-between; align-items: flex-end; padding-bottom: 20px;">
					<div style="text-align: left; width: 40%;">
						<h4 style="margin: 0; font-weight: 500;">물품대여</h4>
						<span style="color: #999;">필요한 물건을 필요한 기간 동안 필려서 사용해보세요.</span>
					</div>
					
					<div style="display: flex; justify-content: flex-end; align-items: flex-end; width: 60%">
						<form name="searchForm" style="display: flex;">
							<!-- 검색 기능 -->
							<input type="hidden" class="form-control-plaintext" name="schType" value="productName">
			                <input type="search" class="search_input" id="search_input" name="kwd" value="${kwd}" placeholder="빌리고 싶은 물건을 찾아보세요.">
			                <button class="search_btn" id="search_btn" onclick="searchList();">검색</button>
			                <button type="button" class="search_btn" onclick="location.href='${pageContext.request.contextPath}/market/rent/main';" title="검색초기화"><i class="bi bi-arrow-repeat"></i></button>
		                </form>
		                
						<button id="showMapBtn" class="search_btn" style="height: 40px; border-radius: 0px;" onclick="modalMap();"><i class="bi bi-map"></i></button>
						<div class="modal fade" id="mapModal" tabindex="-1" role="dialog" aria-labelledby="mapModalLabel" aria-hidden="true">
							<div class="modal-dialog modal-dialog-centered" role="document">
								<div class="modal-content">
								
						      		<div class="modal-header" style="display: flex; justify-content: space-between; padding: 10px 20px;">
						        		<h5 class="modal-title">지도보기</h5>
						        		<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						      		</div>
						      		
						      		<div class="modal-body" style="padding: 10px;">
						      			<div id="map" style="width: 100%; height: 400px;"></div>
						      		</div>
						      	</div>
					      	</div>
					   	</div>
					    
					    <script type="text/javascript">
					    
							function modalMap() {
								$('#mapModal').modal('show');	
							}
							
						 	var container = document.getElementById('map');
							var options = {
								center: new kakao.maps.LatLng(37.556583, 126.919532),
								level: 3
							};
							
							var map = new kakao.maps.Map(container, options);
							
							var geocoder = new kakao.maps.services.Geocoder();
						
							for (let i = 0; i < '${list.size()}'; i++) {
								geocoder.addressSearch('${list.get(i).pra}', function(result, status) {
								     if (status === kakao.maps.services.Status.OK) {
							
								        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
							
								        var marker = new kakao.maps.Marker({
								            map: map,
								            position: coords
								        });
							
								        var infowindow = new kakao.maps.InfoWindow({
								            content: '<div style="width:150px;text-align:center;padding:6px 0;">${list.get(i).pname}</div>'
								        });
								        infowindow.open(map, marker);
								    } 
								});
							}
						    var centerVal = new kakao.maps.LatLng(37.556583, 126.919532);
						    map.setCenter(centerVal);
					    </script>
					    
						<div>
							<button class="ssbtn" style="height: 40px; border-radius: 0px;" onclick="location.href='<c:url value='write'/>'">물품등록</button>
						</div>
						
					</div>
				</div>
				
		        <!-- 상품 리스트 -->
	            <div class="product-grid">
	            	<c:forEach var="dto" items="${list}" varStatus="status">
		                <div class="product-item" id="${dto.pnum}" onclick="location.href='<c:url value='${articleUrl}/${dto.pnum}?${query}'/>'" style="cursor: pointer;">
		                    <div style="width: 100%; height: 200px; border-bottom: 1px solid #e0e0e0;">
			                    <c:if test="${empty dto.pph}">
			                    	<img class="product_img" src="${pageContext.request.contextPath}/dist/images/noimage.png">
			                    </c:if>
			                    <c:if test="${not empty dto.pph}">
			                    	<img class="product_img" src="${pageContext.request.contextPath}/uploadPath/rent/${dto.pph}" alt="물품사진">
			                    </c:if>
		                    </div>
		                    <div class="product_info">
		                    	<div style="margin-bottom: 10px; width: 179.38px; display: flex; justify-content: space-between; align-items: center;">
					                <h5 class="product_name" style="margin: 0; text-align: left; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; width: 90%;">${dto.pname}</h5>
					                <button type="button" value="${dto.pnum}" class="btnSendProductLike" style="border: none; background: #fff; font-size: 20px;" title="찜하기" onclick="event.stopPropagation();">
										<i class="bi ${dto.memberLiked == 1 ? 'bi-suit-heart-fill redColor' : 'bi-suit-heart'}"></i>
									</button>
		                    	</div>
		                    	<div style="text-align: left; font-size: 16px; font-weight: bold; color: ${dto.prs == '대여가능' ? '#006AFF' : '#FFBB00'};">${dto.prs}</div>
			                    	<div style="text-align: left;">
			                    		<span style="font-size: 20px; font-weight: bold;"><fmt:formatNumber value="${dto.prp}"/></span>
			                    		<span style="font-size: 16px; font-weight: 600;">원</span>
			                    		<span> /일</span>
		                    		</div>
			                    <div style="text-align: left; padding-bottom: 5px;">보증금 : <fmt:formatNumber value="${dto.prlp}"/> 원</div>
								<div style="text-align: left; display: flex; flex-wrap: wrap;">
									<span id="output-${dto.pnum}"></span>
	                             	<script type="text/javascript">
		                             	document.addEventListener("DOMContentLoaded", function() {
		                             		const pra = '${dto.pra}';
		                             		const result = pra.split(' ', 2);
		                             		const joinedResult = result.join(' ');
		                             		const id = "output-${dto.pnum}";
		                             		
		                             		document.getElementById(id).innerText = joinedResult;
		                             	});
	                             	</script>
									&nbsp;·&nbsp;
									<span id="result-${dto.pnum}"></span>
	                             	<script type="text/javascript">
										document.addEventListener("DOMContentLoaded", function() {
											const dateStr = "${dto.prd}".trim();
											const date = new Date(dateStr);
											const id = "result-${dto.pnum}";
										
										document.getElementById(id).innerText = elapsedText(date);
										});
	                             	</script>
								</div>
		                	</div>
		                </div>
	                </c:forEach>
	            </div>
	            
				<div class="page-navigation" style="margin-block: auto;">
					${dataCount == 0 ? "등록된 대여물품이 없습니다." : paging}
				</div>
    		</div>
    		
    		<!-- 최근 본 상품 목록 -->
	        <div class="product_Viewe">
			   	<div class="view_item" style="border-bottom: none;">
			    	<p style="margin: 0">최근 본 목록</p>
			    </div>
	  
			  	<div class="view_item img_area">
			  		<p style="margin: 0; font-size: 12px;"> 최근 본 대여물품이 없습니다.
		  			<%-- <img class="view_img" src="${pageContext.request.contextPath}/dist/images/noimage.png"> --%>
				</div>
				<a href="#"><button type="button" class="top_btn"><i class="bi bi-chevron-up"></i></button></a>
	   		</div>
		</div>
		
    </div>
</main>

<script type="text/javascript">
// 검색 키워드 입력란에서 엔터를 누른 경우 서버 전송 막기 
window.addEventListener('load', () => {
	const inputEL = document.querySelector('form input[name=kwd]'); 
	inputEL.addEventListener('keydown', function (evt) {
	    if(evt.key === 'Enter') {
	    	evt.preventDefault();
	    	
	    	searchList();
	    }
	});
});

function searchList() {
	const f = document.searchForm;
	if(! f.kwd.value.trim()) {
		return;
	}
	
	// form 요소는 FormData를 이용하여 URLSearchParams 으로 변환
	const formData = new FormData(f);
	let requestParams = new URLSearchParams(formData).toString();
	
	let url = '${pageContext.request.contextPath}/market/rent/main';
	location.href = url + '?' + requestParams;
}

$(document).ready(function() {
    // 상품 클릭 시 최근 본 상품 저장
    $('.product-item').click(function() {
        var pname = $(this).find('.product_name').text();
        var pnum = $(this).attr("id");
        var imageSrc = $(this).find('img').attr('src');

        // 최근 본 상품 로컬 스토리지에 저장
        var recentlyRentViewed = JSON.parse(localStorage.getItem('recentlyRentViewed')) || [];
        
        // 중복된 상품이 있으면 삭제
        for (var i = 0; i < recentlyRentViewed.length; i++) {
            if (recentlyRentViewed[i].pnum == pnum) {
                recentlyRentViewed.splice(i, 1); // 중복된 상품 삭제
                break;
            }
        }

        recentlyRentViewed.push({ pnum: pnum, pname: pname, image: imageSrc });
        

        if (recentlyRentViewed.length > 3) {
        	recentlyRentViewed.shift(); // 가장 오래된 상품 삭제
        }

        localStorage.setItem('recentlyRentViewed', JSON.stringify(recentlyRentViewed));

        // 최근 본 상품을 aside에 갱신
        updateRecentlyRentViewed();
    });

    // 페이지 로드 시 최근 본 상품 불러오기
    updateRecentlyRentViewed();

    function updateRecentlyRentViewed() {
        var recentlyRentViewed = JSON.parse(localStorage.getItem('recentlyRentViewed')) || [];
        var $recentlyRentViewedSection = $('.img_area');
        
        $recentlyRentViewedSection.empty();  // 이전 내용 삭제

        if (recentlyRentViewed.length === 0) {
            $recentlyRentViewedSection.append('<p style="margin: 0; font-size: 12px;"> 최근 본 대여물품이 없습니다.');
        } else {
            $.each(recentlyRentViewed, function(index, product) {
                var productHtml = '<a href="${pageContext.request.contextPath}/market/rent/article/' + product.pnum + '?${query}">'
								+ '<img class="view_img" src="' + product.image + '" alt="상품 이미지">'
                                + '</a>';
                $recentlyRentViewedSection.prepend(productHtml);
            });
        }
        
        removeDeletedItemsFromLocalStorage();
    }
    
 	// 화면에서 사라진 상품을 로컬 스토리지에서 제거
    function removeDeletedItemsFromLocalStorage() {
        var recentlyRentViewed = JSON.parse(localStorage.getItem('recentlyRentViewed')) || [];
        var $currentProductIds = $('.product-item').map(function() {
            return $(this).attr("id");  // 화면에 남아 있는 상품의 pnum
        }).get();

        // 화면에 없는 상품을 로컬 스토리지에서 삭제
        recentlyRentViewed = recentlyRentViewed.filter(function(product) {
            return $currentProductIds.includes(product.pnum);
        });

        // 로컬 스토리지 업데이트
        localStorage.setItem('recentlyRentViewed', JSON.stringify(recentlyRentViewed));
    }
});

$(function() {
	$('.btnSendProductLike').click(function() {
		const $i = $(this).find('i');
		let memberLiked = $i.hasClass('bi-suit-heart-fill');
		let msg = memberLiked ? '찜을 취소하시겠습니까?' : '찜을 하시겠습니까?';
		
		if (! confirm(msg)) {
			return false;
		}
		
		let url = '${pageContext.request.contextPath}/market/rent/insertProductLike';
		let pnum = $(this)[0].value;
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
				
			setTimeout(function() {
	              window.location.reload();
		    }, 100);
				
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

<script type="text/javascript">
    // URL에서 cbn 파라미터 값 추출
    function getQueryParam(param) {
        const urlParams = new URLSearchParams(window.location.search);
        return urlParams.get(param);
    }

    // cbn 값 추출
    const cbnValue = getQueryParam('cbn');
    
    // csn 값 추출
    const csnValue = getQueryParam('csn');
    
    if (cbnValue !== null) { // cbn 값이 있으면 화면에 표시
        document.getElementById('cbn-value').textContent = '${largeCate}';
    } else if (csnValue != null) { // csn 값이 있으면 화면에 cbn -> csn 형태로 표시
    	const textVal = '${largeCate} <i class="bi bi-chevron-right"></i> ${smallCate}';
    	document.getElementById('cbn-value').innerHTML = textVal;
    } else {
        document.getElementById('cbn-value').textContent = '전체';
    }
</script>

<footer class="mt-auto py-2 text-center w-100" style="left: 0px; bottom: 0px; background: #F7F9FA;">
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>