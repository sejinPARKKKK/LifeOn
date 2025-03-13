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
	            <div class="border shadow-sm rounded p-4 bg-light">
	                <h4 class="text-center fw-bold text-danger mb-4">
	                    <i class="bi bi-exclamation-triangle"></i> 파일 다운로드 불가
	                </h4>
	
	                <div class="d-grid pt-3">
	                    <p class="alert alert-warning text-center mb-4">
	                        <strong>파일을 다운로드할 수 없습니다.</strong><br>
	                        파일이 존재하지 않거나 권한이 부족합니다.
	                    </p>
	                </div>
	
	                <div class="d-grid">
	                    <button type="button" class="btn btn-lg btn-primary" onclick="javascript:history.back();">
	                        이전화면으로 이동 <i class="bi bi-arrow-counterclockwise"></i>
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