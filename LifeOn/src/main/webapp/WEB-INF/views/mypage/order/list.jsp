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
<!-- <script type="text/javascript" src="${pageContext.request.contextPath}/dist/js/menu2.js"></script> -->
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
        color: #99c3ff;
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

    
    .btn {
        padding: 5px 10px;
        border: none;
        cursor: pointer;
        border-radius: 5px;
    }
    .btn-delete {
        background-color: hotpink;
        color: white;
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
            <div class="sejin-title">주문 내역</div>
            <div class="sejin-table-container">
                <table class="sejin-table">
                    <thead>
                        <tr>
                        	<th>주문번호</th>
                            <th>상품명</th>
                            <th>상품사진</th>
                            <th>구매수량</th>
                            <th>총가격</th>
                            <th>주문상세상태</th>
                            <th>주문일</th>
                        </tr>
                    </thead>
                    <tbody>
                  
                    	<c:forEach var="dto" items="${list}" varStatus="status">
                    		<tr>
                    			<td>${dataCount - (page-1) * size - status.index}</td>
                    			<td>${dto.pname}</td>
                    			<td style="text-align: center;">
                    					<img src="${pageContext.request.contextPath}/uploads/product/${dto.pph}" alt="상품 이미지" width="50">
                    			</td>
                    			<td>${dto.odq}</td>
                    			<td>${dto.op}</td>                    			
                    			<td>${dto.os}</td>
                    			<td>${dto.od}</td>
                    		                   			
                    		</tr>
                    	</c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="page-navigation">
				${dataCount == 0 ? "관심상품이 없습니당" : paging}
			</div>
        </div>
    </div>
</main>

<footer class="mt-auto py-2 text-center w-100" style="left: 0px; bottom: 0px; background: #F7F9FA;">
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>