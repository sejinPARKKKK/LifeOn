<%@page import="org.springframework.web.context.annotation.SessionScope"%>
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
			<div class="row">
				<div class="col-md-6 offset-md-3">
					<div class="border mt-5 p-4">
	                    <form name="loginForm" action="" method="post" class="row g-3">
	                        <h3 class="text-center"><img src="${pageContext.request.contextPath}/dist/images/logo.png" alt="logo" style="width: 150px; height: 60px; object-fit: cover;"></h3>
	                        <div class="col-12">
	                            <input type="text" name="id" class="form-control" placeholder="아이디">
	                        </div>
	                        <div class="col-12">
	                            <input type="password" name="pwd" class="form-control" autocomplete="off" placeholder="비밀번호">
	                        </div>
	                        <div class="col-12">
	                            <div class="form-check">
	                                <input class="form-check-input" type="checkbox" id="rememberMe">
	                                <label class="form-check-label" for="rememberMe"> 아이디 저장</label>
	                            </div>
	                        </div>
	                        <div class="col-12">
	                            <button type="button" class="btn w-100" style="background: #006AFF; color: #fff;" onclick="sendLogin();">로그인</button>
	                        </div>
	                    </form>
	                    <hr class="mt-4">
	                    <div class="col-12">
	                        <p class="text-center mb-0">
	                        	<a href="${pageContext.request.contextPath}/member/idFind" class="text-decoration-none" style="font-size: 12px;">아이디찾기</a> |
									<a href="${pageContext.request.contextPath}/member/pwdFind" class="text-decoration-none" style="font-size: 12px;">비밀번호재설정</a> |
									<a href="${pageContext.request.contextPath}/member/join" class="text-decoration-none" style="font-size: 12px;">회원가입</a>
	                        </p>
	                    </div>
					    <div class="d-grid">
		                    <p class="form-control-plaintext text-center text-primary">${message}</p>
						</div>
	        	        <div class="d-grid">
	            	        <a href="${pageContext.request.contextPath}/member/faq" class="text-decoration-none" style="font-size: 12px; color: #7F7F7F;">로그인에 문제가 있으신가요?</a>
						</div>
	                </div>
				</div>
			</div>

		</div>
	</div>
</main>

<script type="text/javascript">
function sendLogin() {
    const f = document.loginForm;
	let str;
	
	str = f.id.value.trim();
    if( !str ) {
        f.id.focus();
        return;
    }

    str = f.pwd.value.trim();
    if( !str ) {
        f.pwd.focus();
        return;
    }

    f.action = '${pageContext.request.contextPath}/member/login';
    f.submit();
}


</script>

<footer class="mt-auto py-2 text-center w-100" style="left: 0px; bottom: 0px; background: #F7F9FA;">
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>