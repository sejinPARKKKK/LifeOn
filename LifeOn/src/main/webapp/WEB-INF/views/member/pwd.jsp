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

</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>
	
<main class="d-flex flex-column min-vh-100 align-items-center" style="padding-top: 66px;">
	<div class="container">
		<div class="body-container">	

	        <div class="row justify-content-md-center">
	            <div class="col-md-7 pt-5">
	                <div class="border mt-5 p-4">
	                    <form name="pwdForm" method="post" class="row g-3">
	                        <h3 class="text-center fw-bold">패스워드 재확인</h3>
	                        
			                <div class="d-grid">
								<p class="form-control-plaintext text-center">정보보호를 위해 패스워드를 다시 한 번 입력해주세요.</p>
			                </div>
	                        
	                        <div class="d-grid">
	                            <input type="text" name="id" class="form-control form-control-lg" placeholder="아이디"
	                            		value="${sessionScope.member.id}" 
	                            		readonly>
	                        </div>
	                        <div class="d-grid">
	                            <input type="password" name="pwd" class="form-control form-control-lg" autocomplete="off" placeholder="패스워드">
	                        </div>
	                        <div class="d-grid">
	                            <button type="button" class="btn btn-lg btn-primary" onclick="sendOk();">확인 <i class="bi bi-check2"></i> </button>
	                            <input type="hidden" name="mode" value="${mode}">
	                        </div>
	                    </form>
	                </div>
	
	                <div class="d-grid">
						<p class="form-control-plaintext text-center">${message}</p>
	                </div>
	            </div>
	        </div>

		</div>
	</div>
</main>


<script type="text/javascript">
function sendOk() {
	const f = document.pwdForm;

	let str = f.pwd.value.trim();
	if(!str) {
		alert('패스워드를 입력하세요. ');
		f.userPwd.focus();
		return;
	}

	f.action = '${pageContext.request.contextPath}/member/pwd';
	f.submit();
}
</script>

<footer class="mt-auto py-2 text-center w-100" style="left: 0px; bottom: 0px; background: #F7F9FA;">
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>