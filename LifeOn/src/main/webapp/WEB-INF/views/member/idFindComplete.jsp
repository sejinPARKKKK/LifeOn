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
<style>
    main {
        padding-top: 120px; /* 헤더와 겹치지 않도록 충분한 간격 확보 */
    }

    .card {
        width: 100%;
        max-width: 500px; /* 기존 550px -> 500px로 조정 */
        padding: 2.5rem; /* 내부 패딩 조정 */
        border-radius: 12px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        background: #ffffff;
        margin-top: 20px; /* 카드를 아래로 이동 */
        min-height: 270px; /* 카드 높이를 늘림 */
        display: flex;
        flex-direction: column;
        justify-content: center;
        
    }

    .card p {
        font-size: 1.3rem;
        margin-top: 30px;
    }

    .btn-container {
        display: flex;
        justify-content: center;
        gap: 12px;
        margin-top: auto; /* 버튼을 아래쪽으로 밀어 배치 */
    }

    .btn-primary {
        flex: 1;
        font-size: 1.2rem;
        padding: 14px;
        border-radius: 8px;
        background-color: #007bff;
        color: white;
        border: none;
        transition: 0.3s;
    }

    .btn-primary:hover {
        background-color: #0056b3;
    }
</style>
</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>
	
<main class="d-flex flex-column min-vh-100 align-items-center" style="padding-top: 120px;">
    <div class="card p-4 text-center shadow-sm">
        <p class="mb-3">회원님의 아이디는 <strong>${id}</strong>입니다.</p>
        <div class="btn-container">
            <button class="btn btn-primary" onclick="location.href='${pageContext.request.contextPath}/'">홈으로</button>
            <button class="btn btn-primary" onclick="location.href='${pageContext.request.contextPath}/member/pwdFind'">비밀번호 재설정</button>
        </div>
    </div>
</main>

<footer class="mt-auto py-2 text-center w-100" style="background: #F7F9FA;">
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>
