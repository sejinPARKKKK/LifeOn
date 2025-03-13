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

</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>
	
<main class="d-flex flex-column min-vh-100 align-items-center" style="padding-top: 66px;">
	<div class="container">

        <div class="row justify-content-center mt-5">
            <div class="col-md-8">
                <div class="border border mt-5 p-4">
	                <h4 class="text-center fw-bold">${title}</h4>
	                <hr class="mt-4">
                       
	                <div class="d-grid p-3">
						<p class="text-center">${message}</p>
	                </div>
                       
					<c:choose>
					    <c:when test="${title eq '주문실패'}">
					        <div class="d-grid">
					            <button type="button" class="btn btn-lg btn-danger" onclick="location.href='${pageContext.request.contextPath}/point/mypage';">
					                충전하기 <i class="bi bi-wallet2"></i>
					            </button>
					        </div>
					    </c:when>
					    <c:otherwise>
					        <div class="d-grid">
					            <button type="button" class="btn btn-lg btn-primary" onclick="location.href='${pageContext.request.contextPath}/';">
					                메인화면 <i class="bi bi-check2"></i>
					            </button>
					        </div>
					    </c:otherwise>
					</c:choose>
						                          
                </div>
            </div>
        </div>
    
	</div>
</main>

<footer class="mt-auto py-2 text-center w-100" style="left: 0px; bottom: 0px; background: #F7F9FA;">
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>