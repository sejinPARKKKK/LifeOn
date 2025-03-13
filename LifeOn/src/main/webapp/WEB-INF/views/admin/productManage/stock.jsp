<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>LifeOn - 재고관리</title>

<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp"/>
<style>
    .wrapper {
        display: flex;
    }
    .container {
        flex-grow: 1;
        padding: 20px;
    }
    .table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }
    .table th, .table td {
        border: 1px solid #ddd;
        padding: 10px;
        text-align: center;
    }
    .table th {
        background-color: #f4f4f4;
    }
    .btn {
        padding: 5px 10px;
        border: none;
        cursor: pointer;
        border-radius: 5px;
    }
    .btn-delete {
        background-color: #dc3545;
        color: white;
    }
    .low-stock {
        color: red;
        font-weight: bold;
    }
    .thumbnail {
        width: 50px;
        height: 50px;
        object-fit: cover;
        border-radius: 5px;
    }
    h2 {
        font-size: 24px;
        margin-bottom: 15px;
    }
    
.sold-out {
    opacity: 0.5;
    pointer-events: none;
    position: relative;
}

.sold-out-overlay {
    display: flex;  
    flex-direction: column;
    align-items: center;
    justify-content: center;
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    font-size: 40px;
    font-weight: bold;
    color: blue;  /* 파란색 */
    background: rgba(255, 255, 255, 0.6); 
    z-index: 10;
    text-align: center;
    padding: 10px;
    flex-wrap: wrap; 
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
        <h2>공동구매 상품 재고관리</h2>
        <button type="button" onclick="location.href='${pageContext.request.contextPath}/admin/productManage/stockRegister'" class="btn btn-primary mt-3">상품 및 재고 등록</button>
        <table class="table">
            <thead>
                <tr>
                	<th>번호</th>
                    <th>썸네일</th>
                    <th>상품명</th>
                    <th>업체명</th>
                    <th>카테고리 (대 / 소)</th>
                    <th>현재 재고</th>
                    <th>공동구매 등록여부</th>
                </tr>
            </thead>
            <tbody>
            	<c:forEach var="dto" items="${list}" varStatus="status">
            		<tr>
            			<td>${dataCount - (page-1) * size - status.index}</td>
            			<td><img src="${pageContext.request.contextPath}/uploads/product/${dto.pph}" alt="상품 이미지" width="50"></td>
            			<td>${dto.pname}</td>
            			<td>${dto.ptsc}</td>
            			<td>${dto.cbc} / ${dto.csc}</td>
            			<td>${dto.ptsq}</td>
						<td class="${dto.ptsq == 0 ? 'sold-out' : ''}">
						    <c:choose>
						        <c:when test="${dto.asRegister == 'Y'}">
						            <!-- 공동구매 상품 등록이 되어있는 경우 -->
						            <button type="button" class="btn btn-secondary" disabled>등록 완료</button>
						            <button type="button" onclick="location.href='${pageContext.request.contextPath}/market/together/detail?pnum=${dto.pnum}'" class="btn btn-info">상품 보러가기</button>
						        </c:when>
						        <c:otherwise>
						            <!-- 공동구매 상품 등록 미완료인 경우 -->
						            <button type="button" onclick="location.href='${pageContext.request.contextPath}/admin/productManage/deleteStock?pnum=${dto.pnum}'" class="btn btn-delete mt-3">재고 삭제</button>
						            <button type="button" onclick="location.href='${pageContext.request.contextPath}/admin/productManage/register?pnum=${dto.pnum}&ptsq=${dto.ptsq}'" class="btn btn-primary mt-3">공동구매 등록</button>
						        </c:otherwise>
						    </c:choose>
						
						    <!-- 판매완료 오버레이 (dto.ptsq == 0일 때만 표시) -->
						    <div class="sold-out-overlay" style="${dto.ptsq == 0 ? 'display:flex;' : 'display:none;'}">
								판매처리 완료
						    </div>
						</td>

            		</tr>
            	</c:forEach>
            </tbody>
        </table>           
        <div class="page-navigation">
			${dataCount == 0 ? "포인트 내역이 없습니다" : paging}
		</div>
    </div>
</main>

<footer>
    <jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp"/>
</body>
</html>
