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

    .sejin {
        display: flex;
        justify-content: center;
        align-items: flex-start; /* 너무 중앙이 아니라 조금 위쪽에 위치 */
        min-height: 90vh;
        padding-top: 30px; /* 위쪽 여백 추가 */
    }

    .card {
        width: 100%;
        max-width: 500px; /* 기존 550px -> 500px로 조정 */
        padding: 2.5rem; /* 내부 패딩 조정 */
        border-radius: 12px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        background: #ffffff;
    }

    .card h5 {
        font-size: 1.5rem;
        font-weight: bold;
        text-align: center;
    }

    .alert {
        font-size: 14px;
        border-radius: 6px;
        background: #f1f3f5;
        padding: 12px;
    }

    .form-control {
        height: 45px;
        font-size: 1rem;
        padding: 10px;
    }

    .btn-primary {
        font-size: 1.1rem;
        padding: 12px;
        border-radius: 6px;
        background-color: #007bff;
        border: none;
        transition: 0.3s;
    }

    .btn-primary:hover {
        background-color: #0056b3;
    }
</style>

<script type="text/javascript">
function pwdOk(){
	const f = document.pwdForm;
	
	let str = f.pwd.value;
	if( !/^(?=.*[a-z])(?=.*[!@#$%^*+=-]|.*[0-9]).{8,15}$/i.test(str) ) { 
		alert('패스워드를 다시 입력 하세요. ');
		f.pwd.focus();
		return;
	}
	
	if( str !== f.pwd2.value){
		alert('패스워드가 일치하지 않습니다.');
		f.pwd.focus();
		return;
	}
	
	f.action = '${pageContext.request.contextPath}/member/pwdSet';
	f.submit();
	
}
</script>


</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>
	
<main class="d-flex flex-column min-vh-100 align-items-center" style="padding-top: 120px;">
    <div class="sejin">
        <div class="card p-4 text-center shadow-sm">
            <h5 class="text-center mb-3">비밀번호 재설정</h5>
            
            <div class="alert alert-light text-start">
                <strong>유의사항</strong>
                <ul class="m-0 ps-3">
                    <li>8자 ~ 15자 길이로 만들어주세요.</li>
                    <li>하나 이상의 숫자나 특수문자가 포함되어야 합니다.</li>
                </ul>
            </div>

            <form name="pwdForm" method="post">
            	<input type="hidden" name="num" value="${num}">
      
                <div class="mb-3">
                    <label for="pwd" class="form-label">새 비밀번호</label>
                    <input type="password" class="form-control" name="pwd" id="pwd" placeholder="비밀번호 입력">
                </div>
                <div class="mb-3">
                    <label for="pwd2" class="form-label">새 비밀번호 확인</label>
                    <input type="password" class="form-control" name="pwd2" id="pwd2" placeholder="비밀번호 확인">
                </div>
                <button type="button" class="btn btn-primary w-100" onclick="pwdOk();">변경하기</button>
            </form>
        </div>
    </div>
</main>

<footer class="mt-auto py-2 text-center w-100" style="background: #F7F9FA;">
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>
