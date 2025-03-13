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
		
		<div class="row justify-content-md-center mt-5">
		    <div class="col-md-8">
		        <div class="border shadow-sm rounded mt-5 p-5 bg-light">
		            <h4 class="text-center fw-bold text-danger mb-4">
		                <i class="bi bi-exclamation-triangle"></i> 시스템 오류
		            </h4>
		
		            <div class="d-grid pt-3">
		                <p class="alert alert-danger text-center bg-light">
							죄송합니다.<br>
							<strong>잠시후 다시 시도 해보시기 바랍니다.</strong>					
		                </p>
		            </div>
		
		            <div class="d-grid">
		                <button type="button" class="btn btn-lg btn-primary" onclick="location.href='${pageContext.request.contextPath}/';">
		                    메인화면으로 이동 <i class="bi bi-arrow-counterclockwise"></i>
		                </button>
		            </div>
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