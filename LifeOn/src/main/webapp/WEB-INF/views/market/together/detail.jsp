<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>LifeOn</title>

<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/forms.css" type="text/css">

<style type="text/css">
     
    .detail-img-prize {
        width: 1130px;
        height: 600px;
        border-radius: 5px;
        border: 1px solid gray;
    }

    .head-main {
        padding-top: 15px;
    }

    .moneyText1 {
        font-size: 28px;
        font-weight: 600;

    }

    .moneyText2 {
        font-size: 42px;
        font-weight: 600;
        color: #CA3B3B;
    }

    .time-Text1 {
        font-size: 28px;
        font-weight: 600;

    }

    .time-Text2 {
        font-size: 35px;
        font-weight: 600;
        color: blue;
    }
    
    .wow img {
        width: 450px;
        height: 650px;
        object-fit: contain;
        border-radius: 5px;
        border: 1px solid gray;
    }
    .closed-status {
    	color: red;
	}
	
	.buy-button {
        font-size: 25px;
        font-weight: bold;
        color: white;
        background-color: blue;
        border: none;
        padding: 15px 30px;
        border-radius: 5px;
        cursor: pointer;
        transition: background-color 0.3s;
    }
	.admin-button {
    font-size: 16px;
    font-weight: bold;
    color: white;
    background-color: blue;
    border: none;
    padding: 10px 20px;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s;
	}
	
	.admin-button:hover {
	    background-color: darkblue;
	}
	
	
</style>


</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
	<jsp:include page="/WEB-INF/views/market/layout/menu.jsp"/>
</header>

<c:if test="${sessionScope.member.grade == 1}">
	<div style="display: flex; justify-content: flex-end; margin-bottom: 10px;">
		<button class="admin-button" onclick="location.href='${pageContext.request.contextPath}/admin/productManage/list'">공동구매목록 리스트로 돌아가기</button>
	</div>
</c:if>
<main class="d-flex flex-column min-vh-100 align-items-center" style="padding-top: 84px;">
	<div class="wow" style="display: flex; padding-top: 5px; margin: 10px auto; width: 1130px;">
	    <img src="${pageContext.request.contextPath}/uploads/product/${dto.pph}" alt="이미지">
	    <div style="margin-left: 70px;">
	        <div style="display: flex;">
	            <p style="font-size: 35px; font-weight: 600; width: 330px">${dto.pname}</p>
	            <div>
	                <p style="font-size: 15px; padding: 0 0 0 30px; width: 270px">등록일 : ${dto.ptd}</p>
	            </div>
	        </div>
	        <div style="width: 560px">
	            <hr style="border: 1px solid black; margin-top: 10px;">
	        </div>
	        <div>
	            <div class="head-main" style="display: flex;">
	                <div>
	                    <p class="moneyText1"><del><fmt:formatNumber value="${dto.ptp}" type="currency"/></del></p>
	                    <p class="moneyText2"><fmt:formatNumber value="${dto.ptsp}" type="currency"/></p>
	                </div> 
	                <div class="status-box" style="font-size: 40px; font-weight: bold; margin-left: auto;">
       					<p style="color: ${dto.status eq '마감' ? 'red' : 'blue'}">${dto.status}</p>
		                <c:if test="${dto.status eq '구매가능'}">
						    <p style="font-size: 22px">남은 수량 : ${dto.ptq}개</p>
						</c:if>
   					</div>   
	            </div>
	            <div class="head-main">
	                <p class="time-Text1">시작일</p>
	                <p class="time-Text2">${dto.ptsd}</p>	                
	                <p class="time-Text1">종료일</p>
	                <p class="time-Text2">${dto.pted}</p>
	                <p> 예상 발송일 : ${dto.ptdd}</p>
	            </div>
	
				<div style="padding-top: 30px; display: flex; justify-content: flex-end; align-items: center; height: 100px;">
				    <c:if test="${dto.status eq '구매가능'}">
				        <button type="button" class="buy-button" onclick="location.href='${pageContext.request.contextPath}/market/order/payment?pnum=${dto.pnum}'"> 주문하기 </button>
				    </c:if>
				</div>
	        </div>
	    </div>
	</div>

	<div style="padding-top: 5px; margin: 10px auto; width: 1130px;">
	    <hr style="border: 1px solid black;">
	    <div style="padding-top: 30px;">
	        <div>
	            <h2 style="color: #6E6E6E">상품소개</h2>
	            <p style="font-size: 18px;">
	                ${dto.pct}
	            </p>
	        </div>
	
	        <div style="padding-top: 100px;">
	            <h2 style="color: #6E6E6E">상품이미지</h2>
	                <c:forEach var="img" items="${fn:split(dto.ppp, ',')}">
				        <img src="${pageContext.request.contextPath}/uploads/product/${img}" 
				             alt="상품 이미지" class="detail-img-prize" style="margin: 0 auto;">
				    </c:forEach>
	        </div>
	
	    </div>
	</div>

	<div style="padding-top: 55px; padding-bottom: 55px; margin: 10px auto; width: 1130px;">
	    <hr style="border: 1px solid black;">
	    <div style="height: 100px">
	    </div>
	    <hr style="border: 1px solid black;">
	</div>	
	
</main>

<footer class="mt-auto py-2 text-center w-100" style="left: 0px; bottom: 0px; background: #F7F9FA;">
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>