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
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/menu3.css" type="text/css">
<style>
    .sejin-container {
        max-width: 1300px;
        margin: 20px auto;
        padding: 20px;
        background: white;
        border-radius: 12px;
        box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    }
    .sejin-title {
        font-size: 1.8rem;
        font-weight: bold;
        margin-bottom: 20px;
        text-align: left;
    }
    .sejin-point-box {
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: #F7F9FA;
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 20px;
        font-size: 1.2rem;
    }
    .sejin-filter {
        display: flex;
        justify-content: flex-end;
        align-items: center;
        margin-bottom: 15px;
    }
    .sejin-table-container {
        width: 100%;
        overflow-x: auto;
        background: white;
        padding: 20px;
        border-radius: 10px;
    }
    .sejin-table {
        width: 1000px;
        border-collapse: collapse;
        background: white;
        font-size: 1.1rem;
    }
    .sejin-table th, .sejin-table td {
        padding: 15px;
        border-bottom: 1px solid #ddd;
        text-align: left;
    }
    .sejin-table th {
        background: #99c3ff;
        font-size: 1.2rem;
    }
    .sejin-dropdown {
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 5px;
        background: white;
        cursor: pointer;
        font-size: 1rem;
    }
</style>

</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>
	
<main class="d-flex flex-column min-vh-100" style="padding-top: 84px; padding-left: 210px;">
    <jsp:include page="/WEB-INF/views/mypage/left.jsp"/>
    <div class="container d-flex flex-column align-items-center">
        <div class="sejin-container">
            <div class="sejin-title" style="color: #99c3ff">포인트 내역</div>
            <div class="sejin-point-box">
                <div>나의 포인트 <strong>${totalPoint == 0 ? 0 : totalPoint}</strong></div>
                <a class="btn btn-primary btn-sm" href="javascript:dialogCharge();" title="충전하기">충전하기</a>
            </div>
            <form class="row" name="searchForm">
	            <div class="sejin-filter">
	                <label for="sejin-filter-select">포인트 유형&emsp;:&emsp;</label>
	                <select id="sejin-filter-select" class="sejin-dropdown">
	                    <option value="all"  ${schType=="all"?"selected":""}>전체</option>
	                    <option value="earn"  ${schType=="earn"?"selected":""}>적립</option>
	                    <option value="use"  ${schType=="use"?"selected":""}>사용</option>
	                    <option value="expire"  ${schType=="expire"?"selected":""}>소멸</option>
	                    <option value="charge"  ${schType=="charge"?"selected":""}>충전</option>
	                </select>
					<button type="button" class="btn btn-light" onclick="searchList()"> <i class="bi bi-search"></i> </button>
	            </div>
			</form>
            <div class="sejin-table-container">
                <table class="sejin-table">
                    <thead>
                        <tr>
                        	<th>번호</th>
                            <th>포인트유형</th>
                            <th>발생일자</th>
                            <th>발생내용</th>
                            <th>소멸유효기간</th>
                            <th>발생포인트</th>
                            <th>잔여포인트</th>
                        </tr>
                    </thead>
                    <tbody>
                    	<c:forEach var="dto" items="${list}" varStatus="status">
                    		<tr>
                    			<td>${dataCount - (page-1) * size - status.index}</td>
                    			<td>${dto.pret}</td>
                    			<td>${dto.prepd}</td>
                    			<td>${dto.prec}</td>
                    			<td>${dto.prevd}</td>
                    			<td>${dto.prep}</td>
                    			<td>${dto.pretp}</td>                   			
                    		</tr>
                    	</c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="page-navigation">
					${dataCount == 0 ? "포인트 내역이 없습니다" : paging}
			</div>
        </div>
    </div>
</main>

<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
<script type="text/javascript">



function searchList(){
	const f = document.searchForm;
	
	const schType = f.querySelector("#sejin-filter-select").value;
	
	let requestParams = new URLSearchParams();
	requestParams.append("schType", schType);
	
	let url = '${pageContext.request.contextPath}/point/mypage';
	location.href = url + '?' + requestParams.toString();
	
}


function dialogCharge(){
	
	$('#chargeModal').modal('show');	
	
}

var IMP = window.IMP;
IMP.init("imp63557241");
function sendCharge(){
	const f = document.accountForm;
	
	let payMethod = ''; // 결제유형
	let cardName = '';  // 카드 이름
	let authNumber = ''; // 승인번호
	let authDate = ''; // 승인 날짜
	
	
	let account = f.account.value;
	let account_id = 'order_no_000'+  new Date().getTime() + Math.floor(1000 + Math.random() * 9000);
	let email = '${dto2.email1}@${dto2.email2}';
	let name = '${dto2.name}';
	let tel = '${dto2.tel1}-${dto2.tel2}-${dto2.tel3}';
	let addr = '${dto2.addr1}${dto2.addr1}';
	let post = '${dto2.post}';
	
    IMP.request_pay({
    	channelKey: "channel-key-9a4ac5fa-ac86-4a08-b419-398c08ec6ed3",
    	pg : 'html5_inicis.INIpayTest', // 테스트 시 html5_inicis.INIpayTest 기재 
        pay_method : 'card',
        merchant_uid: account_id, // 상점에서 생성한 고유 주문번호
        name : '포인트결제',
        amount : account,                        
        buyer_email : email,
        buyer_name : name,
        buyer_tel : tel,   // 필수 파라미터
        buyer_addr : addr,
        buyer_postcode : post,
    }, function(resp) { // callback
            if(resp.success) {
      
                 console.log(resp);
                 
                 payMethod = resp.pay_method; //point, card  문자열
                 cardName = resp.card_name || '간편결제'; //문자열
                 authNumber = resp.paid_at; //승인번호 숫자 
                 authDate = new Date().toISOString().replace('T', ' ').slice(0, -5); // YYYY-MM-DD HH:mm:ss
                 
                 f.payMethod.value = payMethod;
                 f.cardName.value = cardName;
                 f.authNumber.value = authNumber;
                 f.authDate.value = authDate;
                 
                 f.action = '${pageContext.request.contextPath}/point/charge';
                 f.submit();
                 
            } else {
                 alert('fail...');
                 console.log(resp);
            }
    });
    
	
	
}

</script>

	<div class="modal fade" id="chargeModal" tabindex="-1"
			data-bs-backdrop="static" data-bs-keyboard="false" 
			aria-labelledby="loginModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-sm">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="loginViewerModalLabel">포인트 충전하기</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
	                <div class="p-3">
	                    <form name="accountForm" action="" method="post" class="row g-3">
	                    	<div class="mt-0">
	                    		 <p class="form-control-plaintext">충전할 금액을 입력하세요!</p>
	                    	</div>
	                        <div class="mt-0">
	                            <input type="text" name="account" class="form-control" placeholder="금액">
	                        </div>

	                        <div>
	                        <input type="hidden" name="payMethod">
                			<input type="hidden" name="cardName">
                			<input type="hidden" name="authNumber">
                			<input type="hidden" name="authDate">

	                            <button type="button" class="btn btn-primary w-100" onclick="sendCharge();">충전하기</button>
	                        </div>
	                    </form>
	                    <hr class="mt-3">
	                </div>
	        
				</div>
			</div>
		</div>
	</div>


<footer class="mt-auto py-2 text-center w-100" style="left: 0px; bottom: 0px; background: #F7F9FA;">
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>