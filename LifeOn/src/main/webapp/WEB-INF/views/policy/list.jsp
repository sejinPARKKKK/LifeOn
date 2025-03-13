<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>LifeOn</title>

<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/forms.css"
	type="text/css">

<style type="text/css">
.body-title {
	width: 80%;
	max-width: 900px; /* 최대 크기 설정 (예: 900px) */
	margin: auto;
	margin-top: 40px; /* 가운데 정렬 */
}
.board-list-header {
	width: 80%; /* 테이블 크기를 80%로 조정 */
	max-width: 900px; /* 최대 크기 설정 (예: 900px) */
	margin: auto; /* 가운데 정렬 */
}

.board-list {
	width: 80%; /* 테이블 크기를 80%로 조정 */
	max-width: 900px; /* 최대 크기 설정 (예: 900px) */
	margin: auto; /* 가운데 정렬 */
}

.board-list-footer {
	width: 80%;
	max-width: 900px; /* 최대 크기 설정 (예: 900px) */
	margin: auto;
	margin-top: 40px; /* 가운데 정렬 */
}

.text-wrap {
	display: inline-flex;
	max-width: 380px;
	/* 플렉스아이템이 자신의 컨테이너가 차지하는 공간을 맞추기 위해 크기를 키우거나 줄이는 방법 지정 */
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

}
.board-list-footer {
	width: 80%;
	max-width: 900px; /* 최대 크기 설정 (예: 900px) */
	margin: auto; /* 가운데 정렬 */
}
</style>

</head>
<body>

	<header>
		<jsp:include page="/WEB-INF/views/layout/header.jsp" />
	</header>

	<main class="d-flex flex-column min-vh-100 align-items-center"
		style="padding-top: 66px;">
		<div class="container">
			<div class="body-container">
				<div class="body-title">
					<h3>
						<i class="bi bi-app"></i> 정책정보
					</h3>
				</div>

				<div class="body-main">
					<div class="row board-list-header">
						<div class="col-auto me-auto dataCount"></div>
							${dataCount}건
						<div class="col-auto">&nbsp;</div>
					</div>

					<table class="table table-hover board-list">
						<thead class="table-light">
							<tr>
								<th width="100">번호</th>
								<th>제목</th>
								<th width="100">작성자</th>
								<th width="100">작성일</th>
								<th width="70">조회수</th>
								<th width="50">파일</th>
							</tr>
						</thead>

						<tbody>
							<c:forEach var="prize" items="${list}" varStatus="status">
								<tr>
									<td>${dataCount - (page-1) * size - status.index}</td>
									<td class="left">
										<div class="text-wrap">
											<a href="${pageContext.request.contextPath}/policy/article/${prize.psnum}?${query}" class="text-reset">${prize.subject}</a>
										</div>
									</td>
									<td>${prize.nickname}</td>
									<td>${prize.reg_date}</td>
									<td>${prize.hitcount}</td>
									<td>
										<c:if test="${not empty prize.savefilename}">
											<a href="${pageContext.request.contextPath}/policy/download?psnum=${prize.psnum}" class="text-reset"><i class="bi bi-file-arrow-down"></i></a>
										</c:if>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>

					<div class="page-navigation">
						${dataCount == 0 ? "등록된 게시물이 없습니다." : paging}
					</div>

					<div class="row board-list-footer">
						<div class="col">
							<button type="button" class="btn btn-light" onclick="location.href='${pageContext.request.contextPath}/policy/list';" title="새로고침">
								<i class="bi bi-arrow-counterclockwise"></i>
							</button>
						</div>
						<div class="col-6 text-center">
							<form class="row" name="searchForm">
								<div class="col-auto p-1">
									<select name="schType" class="form-select">
										<option value="all" ${schType=="all"?"selected":""}>제목+내용</option>
										<option value="userName" ${schType=="nickname"?"selected":""}>작성자</option>
										<option value="reg_date" ${schType=="reg_date"?"selected":""}>등록일</option>
										<option value="subject" ${schType=="subject"?"selected":""}>제목</option>
										<option value="content" ${schType=="content"?"selected":""}>내용</option>
									</select>
								</div>
								<div class="col-auto p-1">
									<input type="text" name="kwd" value="${kwd}" class="form-control">
								</div>
								<div class="col-auto p-1">
									<button type="button" class="btn btn-light" onclick="searchList()">
										<i class="bi bi-search"></i>
									</button>
								</div>
							</form>
						</div>
						<div class="col text-end">
							<c:if test="${sessionScope.member.grade == 1}">
							<button type="button" class="btn btn-light"
								onclick="location.href='${pageContext.request.contextPath}/policy/write';">글올리기</button>
							</c:if>
						</div>
					</div>
				</div>
			</div>
		</div>
	</main>
	
	<script type="text/javascript">
	window.addEventListener('load', () => {
		const inputEL = document.querySelector('form input[name=kwd]');
		inputEL.addEventListener('keydown', function (evt) {
			if(evt.key === 'Enter') {
				evt.preventDefault();
				
				searchList();
			}
		});
	});
	
	function searchList() {
		const f = document.searchForm;
		if(! f.kwd.value.trim()) {
			return;
		}
		
		const formData = new FormData(f);
		let requestParams = new URLSearchParams(formData).toString();
		
		let url = '${pageContext.request.contextPath}/policy/list';
		location.href = url + '?' + requestParams;
	}
	
	
	</script>

	<footer class="mt-auto py-2 text-center w-100"
		style="left: 0px; bottom: 0px; background: #F7F9FA;">
		<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
	</footer>

	<jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />
</body>
</html>