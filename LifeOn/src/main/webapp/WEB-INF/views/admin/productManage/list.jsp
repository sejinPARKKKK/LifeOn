<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>LifeOn - 상품관리</title>

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
    .btn-edit {
        background-color: #007bff;
        color: white;
    }
    .btn-delete {
        background-color: #dc3545;
        color: white;
    }
    .btn-order {
        background-color: #28a745;
        color: white;
    }
    .disabled-btn {
	    background-color: #ccc !important;
	    color: #666 !important;
	    cursor: not-allowed;
	    border: 1px solid #aaa;
	}
    
    .sidebar {
        width: 250px;
        background: #007bff;
        color: white;
        padding: 20px;
    }
    .status-tabs {
        display: flex;
        gap: 15px;
        margin-bottom: 20px;
        font-size: 18px;
        font-weight: bold;
    }
    .status-tabs a {
        text-decoration: none;
        color: black;
        padding: 5px 10px;
        border-radius: 5px;
    }
    .status-tabs a.active {
        background-color: #007bff;
        color: white;
    }
    h2 {
        font-size: 24px;
        margin-bottom: 15px;
    }
    
/* td 내부 요소들을 흐리게 만들고 클릭 방지 */
.sold-out {
    opacity: 0.5;
    pointer-events: none;
    position: relative;
}

/* ❌ + 판매처리 완료 텍스트를 td 전체에 꽉 채우기 */
.sold-out-overlay {
    display: none;  /* 초기에는 숨김 */
    flex-direction: column;
    align-items: center;
    justify-content: center;
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    font-size: 60px;  /* X 아이콘 크기 */
    font-weight: bold;
    color: blue;  /* 파란색 */
    background: rgba(255, 255, 255, 0.6); /* 반투명 흰 배경 */
    z-index: 10;
    text-align: center;
}

/* "판매처리 완료" 글씨 스타일 */
.sold-out-overlay span {
    font-size: 16px;  /* 글자 크기 줄임 */
    color: blue;  /* 파란색 */
    font-weight: bold;
    margin-top: 5px;
    white-space: nowrap; /* 줄 바꿈 방지 */
}




    
    
    
</style>

<script type="text/javascript">
function markAsSoldOut(pnum) {
    // 판매완료 버튼 클릭 시 서버에 판매 완료 요청 보내기 (예시: GET 방식)
    location.href = '${pageContext.request.contextPath}/admin/productManage/saleComplete?pnum=' + pnum;

    // 서버가 처리된 후, 해당 td에 판매완료 효과 적용
    var td = document.getElementById("product-container-" + pnum);
    var overlay = document.getElementById("sold-out-overlay-" + pnum);

    // 판매완료 효과 추가
    td.classList.add("sold-out");  // td에 sold-out 클래스 추가
    overlay.style.display = "flex";  // ❌ 아이콘과 "판매처리 완료" 보이기
}
</script>


</head>
<body>

<header class="container-fluid header-top fixed-top px-4">
    <jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
</header>
    
<main class="wrapper">
    <jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>
    <div class="container">
        <h2>공동구매 상품목록</h2>
		<div class="status-tabs">
		    <a href="<c:url value='/admin/productManage/list?schType=all'/>" class="${schType=='all'?'active':''}">전체</a>
		    <a href="${pageContext.request.contextPath}/admin/productManage/list?schType=astatus" class="${schType == 'astatus'?'active':''}">진행전</a>
		    <a href="${pageContext.request.contextPath}/admin/productManage/list?schType=bstatus" class="${schType == 'bstatus'?'active':''}">진행중</a>
		    <a href="${pageContext.request.contextPath}/admin/productManage/list?schType=cstatus" class="${schType == 'cstatus'?'active':''}">구매성공</a>
		    <a href="${pageContext.request.contextPath}/admin/productManage/list?schType=dstatus" class="${schType == 'dstatus'?'active':''}">구매실패</a>
		    <a href="${pageContext.request.contextPath}/admin/productManage/list?schType=estatus" class="${schType == 'estatus'?'active':''}">판매완료</a>
		</div>
		


        <table class="table">
            <thead>
                <tr>
                    <th>번호</th>
                    <th>상태</th>
                    <th>공구기간</th>
                    <th>상품</th>
                    <th>목표수량</th>
                    <th>판매수량</th>
                    <th>비고</th>
                </tr>
            </thead>
            <tbody>
            	<c:forEach var="dto" items="${list}" varStatus="status">
            		<tr>
            			<td>${dataCount - (page-1) * size - status.index}</td>
            			<td>[${dto.status}]</td>
            			<td>
            				시작일 : ${dto.ptsd}<br>
            				종료일 : ${dto.pted}<br>
            				예상발송일 : ${dto.ptdd}
            			</td>
            			<td>
            				<img src="${pageContext.request.contextPath}/uploads/product/${dto.pph}" alt="상품 이미지" width="50">
            				<br>${dto.pname}
            				<br>원가 : <fmt:formatNumber value="${dto.ptp}" type="currency"/>
            				<br>할인가 : <fmt:formatNumber value="${dto.ptsp}" type="currency"/>
            			</td>
            			<td>${dto.pttq}개</td>
            			<td>${dto.totalOdq}개</td>
<td class="${dto.status eq '판매완료' ? 'sold-out' : ''}">
    <button class="btn btn-order" onclick="location.href='${pageContext.request.contextPath}/admin/productManage/update?pnum=${dto.pnum}&ptsq=${dto.ptsq}'">수정하기</button>

    <c:if test="${dto.status eq '구매성공'}">
        <!-- 판매완료 버튼 클릭 시 서버에서 판매처리 후 td 효과 적용 -->
        <button class="btn btn-edit" onclick="markAsSoldOut(${dto.pnum})">판매완료</button>
    </c:if>

    <c:if test="${dto.status ne '구매성공'}">
        <c:choose>
            <c:when test="${dto.status eq '진행중'}">
                <button class="btn btn-delete disabled-btn" disabled title="진행 중인 상품은 마감처리할 수 없습니다.">마감처리</button>
            </c:when>
            <c:otherwise>
                <button class="btn btn-delete"
                        onclick="if(confirm('진짜 마감처리 하시겠습니까?'))
                                    location.href='${pageContext.request.contextPath}/admin/productManage/delete?pnum=${dto.pnum}'">
                    마감처리
                </button>
            </c:otherwise>
        </c:choose>
    </c:if>

    <div class="sold-out-overlay" style="${dto.status eq '판매완료' ? 'display:flex;' : 'display:none;'}">
        ❌
        <span>판매처리 완료</span>
    </div> 
</td>



            			
            		</tr>
            	</c:forEach>
            </tbody>
        </table>
        <div class="page-navigation">
			${dataCount == 0 ? "상품목록이 없습니다." : paging}
		</div>
    </div>
</main>

<footer>
    <jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp"/>
</body>
</html>
