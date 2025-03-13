<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>LifeOn - 공동구매 상품 등록</title>

<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp"/>
<style>
    .wrapper {
        display: flex;
    }
    .container {
        flex-grow: 1;
        padding: 20px;
    }
    .form-group {
        margin-bottom: 15px;
    }
    .form-group label {
        display: block;
        font-weight: bold;
        margin-bottom: 5px;
    }
    .form-group input, .form-group select, .form-group textarea {
        width: 100%;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 5px;
    }
    .btn {
        padding: 10px 15px;
        border: none;
        background-color: #007bff;
        color: white;
        cursor: pointer;
        border-radius: 5px;
    }
</style>
</head>
<body>

<header class="container-fluid header-top fixed-top px-4">
    <jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
</header>
    
<main class="wrapper">
    <jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>
    <div class="container">
        <h2>${mode == "register" ? "공동구매 상품 등록" : "공동구매 상품 수정" }</h2>
        
        <form name="productForm" method="post">
           
            <div class="form-group">
                <label for="ptp">상품 원가</label>
                <input type="number" name="ptp" required value="${dto.ptp}">
            </div>
            
            <div class="form-group">
                <label for="ptsp">상품 판매가</label>
                <input type="number" name="ptsp" required value="${dto.ptsp}">
            </div>
           			
			<div class="form-group">
			    <label for="pttq">상품 목표 수량</label>
			    <input type="number"  name="pttq" required readonly value="${ptsq}" >
			    <small class="text-muted">※ 목표 수량은 재고 수량과 동일합니다.</small>
			</div>	
			
            <div class="form-group">
                <label for="ptsd">판매 시작일</label>
                <input type="date"  name="ptsd" required value="${dto.ptsd}">
            </div>

            <div class="form-group">
                <label for="pted">판매 종료일</label>
                <input type="date"  name="pted" required value="${dto.pted}">
            </div>

            <div class="form-group">
                <label for="ptdd">예상 발송일</label>
                <input type="date" name="ptdd" required value="${dto.ptdd}">
            </div>
			
			<input type="hidden" name="pnum" value="${pnum}">
			
            <button type="button" class="btn" onclick="productRegister();">${mode == "register" ? "상품 등록" : "상품 수정" }</button>
        </form>
    </div>
</main>

<footer>
    <jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp"/>

<script type="text/javascript">
function productRegister(){
	const f = document.productForm;
	
	let str;
	
	str = f.ptp.value;
	if( !str){
		alert("원가를 입력하세요");
		f.ptp.focus();
		return;
	}
	
	str = f.ptsp.value;
	if( !str){
		alert("판매가를 입력하세요");
		f.ptsp.focus();
		return;
	}
	
	str = f.pttq.value;
	if( !str){
		alert("상품수량을 입력하세요");
		f.pttq.focus();
		return;
	}
	
	str = f.ptsd.value;
	if( !str){
		alert("시작일을 입력하세요");
		f.ptsd.focus();
		return;
	}
	
	str = f.pted.value;
	if( !str){
		alert("종료일을 입력하세요");
		f.pted.focus();
		return;
	}
	
	str = f.ptdd.value;
	if( !str){
		alert("예상일을 입력하세요");
		f.ptdd.focus();
		return;
	}	

	
    let start = f.ptsd.value;
    let end = f.pted.value;
    let expect = f.ptdd.value;
    let today = new Date().toISOString().split("T")[0];
    
    if (start && start < today) {
        alert("시작일은 오늘 이전 날짜로 설정할 수 없습니다.");
       	f.ptsd.focus();
       	return;
    }
    
    if (start && end && start > end) {
        alert("종료일은 시작일보다 빠를 수 없습니다.");
        f.pted.focus();
        return;
    }
    
    if (end && expect && end > expect){
    	alert("예상발송일은 종료일보다 빠를 수 없습니다.");
    	f.ptdd.focus();
    	return;
    }
    
   f.action = '${pageContext.request.contextPath}/admin/productManage/${mode}';
   f.submit();	

}

</script>


</body>
</html>
