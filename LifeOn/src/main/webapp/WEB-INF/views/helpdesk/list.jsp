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
	margin-top: 70px;
}

.tab {
	margin-top: 20px;
	font-size: 18px;
}

.tab a{
	display: inline-block;
	padding-left: 5px;
}

.tab a.active {
        font-weight: bold;
        color: #007bff;  
}

.table-border {
	display: inline-block; /* 내부 테이블 크기에 맞춤 */
	border: 1px solid black; /* border 표시 */
	border-radius: 12px; /* radius 적용 */
	overflow: hidden; /* 넘치는 건 감춤 */
}

.table {
	border-collapse: collapse;
	border-radius: 10px;
	border-style: hidden;
}

th, td {
	border: 1px black solid;
}

th {
	font-size: 20px;
}

tr:nth-of-type(odd) th {
	border-bottom: none; /* 질문 행의 아래 테두리 제거 */
}

tr:nth-of-type(even) td {
	border-top: none; /* 답변 행의 위쪽 테두리 제거 */
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
						<i class="bi bi-app"></i> 고객센터
					</h3>
				</div>

				<div class="body-main">
					<div class="tab">
						<a class="active" href="${pageContext.request.contextPath}/help">자주묻는질문</a> 
						<a href="${pageContext.request.contextPath}/chat/main">1:1채팅상담</a>
					</div>

					<div class="table-border">
						<table class="table">
							<thead>
								<tr>
									<th>Q: 배송은 얼마나 걸리나요?</th>
								</tr>
								<tr>
									<td class="answer">A: 주문 후 2~3일 이내에 발송되며, 평균 배송 기간은
										3~5일입니다.</td>
								</tr>

								<tr>
									<th>Q: 교환 및 반품은 어떻게 하나요?</th>
								</tr>
								<tr>
									<td class="answer">A: 신용카드, 계좌이체, 간편결제(카카오페이, 네이버페이) 등을
										지원합니다.</td>
								</tr>

								<tr>
									<th>Q: 제품의 품질 보증 기간은 얼마나 되나요?</th>
								</tr>
								<tr>
									<td class="answer">A: 모든 제품은 구매일로부터 1년간 품질 보증이 제공됩니다.</td>
								</tr>

								<tr>
									<th>Q: 회원 가입 없이도 구매가 가능한가요?</th>
								</tr>
								<tr>
									<td class="answer">A: 네, 비회원으로도 구매가 가능합니다. 하지만 회원 가입 시 다양한
										혜택을 누릴 수 있습니다.</td>
								</tr>

								<tr>
									<th>Q: 할인 쿠폰은 어떻게 사용하나요?</th>
								</tr>
								<tr>
									<td class="answer">A: 결제 단계에서 쿠폰 코드를 입력하시면 즉시 할인 적용됩니다.</td>
								</tr>

								<tr>
									<th>Q: 해외 배송이 가능한가요?</th>
								</tr>
								<tr>
									<td class="answer">A: 네, 일부 국가로 해외 배송이 가능하며 배송비는 국가별로
										상이합니다.</td>
								</tr>

								<tr>
									<th>Q: 제품에 문제가 있을 경우 어떻게 하나요?</th>
								</tr>
								<tr>
									<td class="answer">A: 제품에 문제가 있는 경우, 수령 후 7일 이내에 사진과 함께
										고객센터로 문의해 주시면 빠르게 처리해드리겠습니다.</td>
								</tr>

								<tr>
									<th>Q: 회원 등급에 따른 혜택은 무엇인가요?</th>
								</tr>
								<tr>
									<td class="answer">A: 회원 등급에 따라 추가 할인, 무료 배송, 특별 쿠폰 제공 등의
										혜택을 받을 수 있습니다.</td>
								</tr>
							</thead>
						</table>
					</div>
				</div>
			</div>
		</div>
	</main>


	<footer class="mt-auto py-2 text-center w-100"
		style="left: 0px; bottom: 0px; background: #F7F9FA;">
		<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
	</footer>

	<jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />
</body>
</html>