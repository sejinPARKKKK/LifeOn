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
<style>
    header {
        position: relative;
        z-index: 1000;
        width: 100%;
        background: white;
        box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
    }
    main {
        position: relative;
        z-index: 1;
        width: 100%;
        max-width: 500px;
        margin: 0 auto;
        padding-top: 150px;
    }
    .find-wrapper {
        width: 100%;
        max-width: 360px;
        margin: 50px auto;
        padding: 20px;
        background: #fff;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        text-align: center;
    }
    .tabs {
        display: flex;
        justify-content: center;
        margin-bottom: 15px;
        border-bottom: 1px solid #ddd;
        padding-bottom: 10px;
    }
    .tabs button {
        padding: 8px 15px;
        border: none;
        background: none;
        font-size: 14px;
        cursor: pointer;
        color: #888;
        transition: color 0.3s, background 0.3s;
    }
    .tabs button.active {
        font-weight: bold;
        color: #007bff;
        border-bottom: 2px solid #007bff;
    }
    .tabs button:hover {
        color: #0056b3;
        background: #e9f5ff;
        border-radius: 4px;
    }
    p {
        font-size: 14px;
        color: #333;
        margin-bottom: 15px;
    }
    .input-wow {
        display: flex;
        justify-content: space-between;
        margin-bottom: 15px;
        border: 1px solid #ccc;
        border-radius: 4px;
        padding: 5px;
        background: #f9f9f9;
    }
    input[type="text"] {
        flex: 1;
        border: none;
        padding: 10px;
        background: transparent;
        outline: none;
    }
    .btn-code {
        width: 100%;
        padding: 12px;
        border: none;
        background: #007bff;
        color: white;
        border-radius: 4px;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
    }
    .help-text {
        margin-top: 15px;
        font-size: 12px;
        color: #666;
    }
    .help-text a {
        color: #007bff;
        text-decoration: none;
        font-weight: bold;
    } 
   
   
    .btn-code:disabled {
    background: #cccccc;
    cursor: not-allowed;
	}

.auth-wrapper {
    width: 100%;
    max-width: 360px;
    margin-top: 20px;
    padding: 15px;
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    text-align: center;
    display: none;
}

.auth-wrapper h3 {
    font-size: 18px;
    font-weight: bold;
    margin-bottom: 15px;
}

.input-groupid {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 10px;
    border-radius: 5px;
    border: 1px solid #ddd;
}

.input-groupid input {
    flex: 1;
    border: none;
    outline: none;
    padding: 8px;
    font-size: 16px;
    background: transparent;
}

.input-groupid span {
    font-size: 14px;
    font-weight: bold;
    color: red;
}



    
</style>


<script type="text/javascript">
function telOk(){
	//번호 검사
	
	let tel = $('#tel').val();
	
	let url = '${pageContext.request.contextPath}/member/idFind';
	
	//AJAX:POST-JSON
	$.post(url, {tel:tel}, function(data){
		let telchecked = data.telchecked;
		
		if(telchecked === 'true'){
			let str = '<span style="color:blue; font-weight: bold;">' + tel + '</span> 번호 확인 완료 되었습니다.';
			$('.wrap-tel').find('.help-block').html(str);
			$('#telValid').val('true');
            $('#getAuthCodeBtn').removeAttr('disabled');
		} else{
			let str = '<span style="color:red; font-weight: bold;">' + tel + '</span> 는 존재하지 않는 번호입니다.';
			$('.wrap-tel').find('.help-block').html(str);
			$('#telValid').val('false');
            $('#getAuthCodeBtn').prop('disabled', true)
		}
	}, 'json');
	
}


function requestAuthCode() {
	
    let tel = $('#tel').val();
    let url = '${pageContext.request.contextPath}/member/sendAuthCode';

    $.post(url, { tel: tel }, function (data) {
        if (data.success) {
            alert("인증번호가 발송되었습니다.");
            $('#authWrapper').slideDown(); // 인증 UI 표시
            
            startCountdown(data.expireTime);
        } else {
            alert(data.message);
        }
    }, 'json');
}

function startCountdown(expireTime) {
    let expireDate = Date.parse(expireTime); 
    let countdownElement = document.getElementById("countdown");


    let interval = setInterval(function () {
        let now = Number(new Date().getTime());
        let timeRemaining = expireDate - now;

        if (timeRemaining <= 0) {
            clearInterval(interval);
            countdownElement.innerText = "인증시간이 만료되었습니다.";
        } else {
            let minutes = Math.floor(timeRemaining / 60000);
            let seconds = Math.floor((timeRemaining % 60000) / 1000);

            countdownElement.innerText = "남은 시간: " + minutes + "분 " + seconds + "초";
        }
    }, 1000);
}







function codeCheck() {
	const f = document.telForm;
	
	let str = f.authCode.value;
	if(!str){
		alert("인증번호를 입력하세요!");
        f.authCode.focus();
        return;
	
	}
	
    f.action = '${pageContext.request.contextPath}/member/authCodeCheckId';
    f.submit();
}


window.addEventListener('DOMContentLoaded', () => {
	const dateELS = document.querySelectorAll('form input[type=date]');
	dateELS.forEach( inputEL => inputEL.addEventListener('keydown', e => e.preventDefault()) );
});

</script>

</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>
	
<main class="d-flex flex-column min-vh-100 align-items-center" style="padding-top: 66px;">
    <div class="find-wrapper wrap-tel" >
        <div class="tabs">
            <button class="active" onclick="location.href='${pageContext.request.contextPath}/member/idFind'">아이디찾기</button>
            <button onclick="location.href='${pageContext.request.contextPath}/member/pwdFind'">비밀번호재설정</button>
        </div>
        
	    <p>회원정보에 등록한 휴대전화를 입력해주세요.</p>
	    <p>예) 01043214321와 같은 형식으로 입력하세요</p>
	    
	    <c:if test="${not empty message}">
	    	<p style="color: red; font-weight: bold;">${message}</p>
	    </c:if> 
	
	    <form name="telForm" method="post">
	        <div class="input-wow">
	        	<input type="text" name="tel" id="tel" placeholder="휴대전화번호" />
	     	    <button type="button" class="btn-code" onclick="telOk();">확인</button>
	        </div>
	        <div>
	        	<small class="form-control-plaintext help-block"></small>
	        </div>
	        <button type="button" id="getAuthCodeBtn" class="btn-code" onclick="requestAuthCode();" disabled> 인증코드 받기 </button>
	        
	            <div class="auth-wrapper" id="authWrapper" style="display: none;">
	                <h3>휴대폰 인증하기</h3>
	                <div class="input-groupid">
	                    <input type="text" name="authCode" id="authCode" class="form-control" placeholder="인증번호 입력">
	                </div>
	                <button type="button" class="btn-code" onclick="codeCheck();">확인</button>
	            </div>
	            <p id="countdown" style="color: red; font-weight: bold;"></p>
			<input type="hidden" name="telValid" id="telValid" value="false">
    	</form>
            
        <p class="help-text">회원가입 시 입력한 정보가 기억나지 않는다면?</p>
		<p class="help-text"><a href="#">고객센터 문의하기</a></p>
    </div>
 
       
</main>

<footer class="mt-auto py-2 text-center w-100" style="left: 0px; bottom: 0px; background: #F7F9FA;">
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>