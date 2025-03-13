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
			<h3 class="fw-bold">즐겨찾기한 게시글</h3>
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
					<th class="psnum">번호</th>
					<th class="bdtype">카테고리</th>
					<th class="subject">제목</th>
					<th class="nickname">작성자</th>
					<th class="reg_date">등록일</th>
					<th class="hitCount">조회수</th>
				</tr>
			</thead>
				
			<tbody>				
				<c:forEach var="dto" items="${list}" varStatus="status">
					<tr style="cursor: pointer;">
						<td>${dataCount - (page-1) * size - status.index}</td>
						<td>${dto.bdtype}</td>
						<td class="left">
							<span class="d-inline-block text-truncate align-middle" style="max-width: 390px;">${dto.subject}</span>
						</td>
						<td>${dto.nickname}</td>
						<td>${dto.reg_date}</td>
						<td>${dto.hitCount}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		</div>
			
		<div class="page-navigation" style="margin: 0 auto;">
			${dataCount == 0 ? "<p style='padding-bottom: 200px;'>즐겨찾기한 게시물이 없습니다.</p>" : paging}
		</div>
	</form>

</main>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>