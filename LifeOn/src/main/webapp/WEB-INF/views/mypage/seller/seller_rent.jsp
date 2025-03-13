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
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/free.css" type="text/css">

<style>
.form-title {
	color: #99c3ff;
	margin-left: 20px;
	padding-bottom: 20px;
}

.table th {
	background: #99c3ff;
	font-size: 16px;
	color: #fff;
	text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
	text-align: center;
}

.table td {
	text-align: center;
}

.sebtn {
    border: 1px solid #e0e0e0;
    padding: 8px 10px;
    margin: auto;
    height: 40px;
    display: flex;
    align-items: center;
    background: #fff;
}
</style>

</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>
	
<main class="d-flex" style="padding-top: 84px; padding-left: 300px;">

	<!-- 메뉴바 -->
    <jsp:include page="/WEB-INF/views/mypage/left.jsp"/>
	
	<form name="listForm" method="post"
		style="border: 1px solid #e0e0e0; padding: 40px 0px; min-height: 700px;
		display: flex; flex-direction: column; justify-content: space-between;">
		<div>
		<div class="form-title">
			<h3 class="fw-bold">판매중인 대여물품 목록</h3>
		</div>
        <div class="row board-list-header">
            <div class="col-auto me-auto">
				<p class="form-control-plaintext" style="margin-left: 25px; padding-bottom: 15px; font-size: 16px;">
					총 ${dataCount}개 (${page} / ${total_page}페이지)
				</p>
            </div>
        </div>				
			
		<table class="table table-hover board-list" style="width: 1300px; line-height: 60px; vertical-align: middle;">
			<thead class="table-light">
				<tr>
					<th>번호</th>
					<th>물품명</th>
					<th>물품사진</th>
					<th>대여비</th>
					<th>보증금</th>
					<th>대여상태</th>
					<th>대여자</th>
					<th>결제금액</th>
					<th>대여시작일</th>
					<th>대여종료일</th>
					<th>반납확인</th>
					<th>연체기간</th>
				</tr>
			</thead>
				
			<tbody>				
				<c:forEach var="dto" items="${list}" varStatus="status">
					<tr onclick="location.href='<c:url value='/market/rent/article/${dto.pnum}?page=${page}'/>'" style="cursor: pointer;">
						<td>${dataCount - (page-1) * size - status.index}</td>
						<td>${dto.pname}</td>
						<td style="display: flex; justify-content: center;">		       
							<div style="width: 100px; height: 100px;">
		            			<img style="width: 100%; height: 100%" src="${pageContext.request.contextPath}/uploadPath/rent/${dto.pph}" alt="물품사진">
		        			</div>
		        		</td>
						<td><fmt:formatNumber value="${dto.prp}"/>원</td>
						<td><fmt:formatNumber value="${dto.prlp}"/>원</td>
						<td>${dto.prs}</td>
						<c:if test="${not empty dto.renter}">
							<td>${dto.renter}</td>
							<td><fmt:formatNumber value="${dto.prp}"/>원 x ${dto.odq}일 = <fmt:formatNumber value="${dto.prp * dto.odq}"/>원</td>
							<td>${dto.opsd}</td>
							<td>${dto.oped}</td>
							<td><button class="sebtn" onclick="checkReturnStatus();">반납완료</button></td>
							<td>${dto.opld}</td>
						</c:if>
						<c:if test="${empty dto.renter}">
							<td colspan="6">현재 대여자가 없습니다.</td>
						</c:if>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		</div>
			
		<div class="page-navigation text-center" style="margin: 0 auto;">
			${dataCount == 0 ? "<p style='padding-bottom: 200px;'>판매중인 대여물품이 없습니다.</p>" : paging}
		</div>
	</form>

</main>

<script>
    function checkReturnStatus() {
        let returnStatus = confirm("반납일자에 반납이 되었는지 확인하세요. 반납이 완료되었습니까?");
        
        if (returnStatus) {
            alert("반납이 완료되었습니다.");
            // 반납 완료 처리
        } else {
            alert("반납이 아직 완료되지 않았습니다.");
            // 반납 미완료 상태 처리, 반납날짜 확인 후 연체기간 업데이트
        }
    }
</script>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>