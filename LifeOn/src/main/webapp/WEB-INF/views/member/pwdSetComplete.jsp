<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>비밀번호 변경 완료</title>

<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>

<style>
    /* Reset Password 스타일 - 부트스트랩과 겹치지 않도록 네임스페이스 적용 */
    .reset-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        text-align: center;
        background: #ffffff;
        padding: 40px;
        border-radius: 10px;
        box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        width: 100%;
        max-width: 350px;
        
        position: relative;
        top: -160px;
    }

    .reset-icon {
        font-size: 50px;
        color: #0d6efd;
        margin-bottom: 10px;
    }

    .reset-title {
        font-size: 22px;
        font-weight: bold;
        margin-bottom: 10px;
    }

    .reset-text {
        font-size: 14px;
        color: #6c757d;
        margin-bottom: 20px;
    }

    .reset-button {
        width: 100%;
        padding: 10px;
        font-size: 16px;
    }
</style>

</head>
<body>

<header>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>
    
<main class="d-flex flex-column min-vh-100 align-items-center justify-content-center">
    <div class="reset-container">
        <div class="reset-icon">
            <i class="bi bi-check-circle-fill"></i>
        </div>
        <h3 class="reset-title">비밀번호 변경 완료</h3>
        <p class="reset-text">비밀번호 변경이 완료되었습니다.<br>새로운 비밀번호로 로그인해주세요.</p>
        <button class="btn btn-primary reset-button" onclick="location.href='${pageContext.request.contextPath}/'">
            메인 화면으로
        </button>
    </div>
</main>

<footer class="mt-auto py-2 text-center w-100">
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>
