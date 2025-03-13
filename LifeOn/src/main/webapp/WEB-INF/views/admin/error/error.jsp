<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>LifeOn</title>

<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp"/>

</head>
<body>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
	
<main>
	<jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>
	<div class="wrapper">
		<div class="body-container">
		    <div class="body-main">

				<div class="row justify-content-md-center mt-5">
				    <div class="col-md-8">
				        <div class="border shadow-sm rounded mt-5 p-5 bg-light">
				            <h4 class="text-center fw-bold text-danger mb-4">
				                <i class="bi bi-exclamation-triangle"></i> ${title}
				            </h4>
				
				            <div class="d-grid pt-3">
				                <p class="alert alert-danger text-center bg-light">
				                    ${message}
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
		</div>		
	</div>
</main>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>

<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp"/>
</body>
</html>