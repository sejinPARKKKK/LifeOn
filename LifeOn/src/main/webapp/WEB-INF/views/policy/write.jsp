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
	max-width: 900px;
	margin: auto;
	margin-top: 40px;
}

.write-form {
	width: 80%;
	max-width: 900px;
	margin: auto;
}

td[scope="row"] {
	text-align: center;
	vertical-align: middle;
	background-color: #FBFBFB;
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
					<form name="boardForm" method="post" enctype="multipart/form-data">
						<table class="table mt-3 write-form">
							<tr>
								<td class="col-sm-2" scope="row">제 목</td>
								<td><input type="text" name="subject" maxlength="100"
									class="form-control" value="${dto.subject}"></td>
							</tr>

							<tr>
								<td class="col-sm-2" scope="row">작성자명</td>
								<td>
									<p class="form-control-plaintext">${sessionScope.member.nickName}</p>
								</td>
							</tr>

							<tr>
								<td class="col-sm-2" scope="row">내 용</td>
								<td><textarea name="content" id="ir1" class="form-control"
										style="width: 99%; height: 300px;">${dto.content}</textarea></td>
							</tr>
							<tr>
								<td class="col-sm-2" scope="row">첨부</td>
								<td><input type="file" name="selectFile"
									class="form-control"></td>
							</tr>

							<c:if test="${mode=='update'}">
								<tr>
									<td class="col-sm-2" scope="row">첨부된파일</td>
									<td>
										<p class="form-control-plaintext">
											<c:if test="${not empty dto.savefilename}">
												<a href="javascript:deleteFile('${dto.psnum}')"><i
													class="bi bi-trash"></i></a>
												${dto.originalfilename}
											</c:if>
									</td>
								</tr>
							</c:if>
						</table>


						<table class="table table-borderless">
							<tr>
								<td class="text-center">
									<button type="reset" class="btn">다시 입력</button>
									<button type="button" class="btn" onclick="location.href='${pageContext.request.contextPath}/policy/list';"> 등록취소&nbsp;<i class="bi bi-x"></i>
									</button>
									<button type="button" class="btn" id="submitBtn" onclick="submitForm();">${mode=="update" ? "수정완료" : "등록완료"}&nbsp;<i	 class="bi bi-check2"></i>
									</button> <c:if test="${mode == 'update'}">
										<input type="hidden" name="psnum" value="${dto.psnum}">
										<input type="hidden" name="savefilename"
											value="${dto.savefilename}">
										<input type="hidden" name="originalfilename"
											value="${dto.originalfilename}">
										<input type="hidden" name="page" value="${page}">
									</c:if>

								</td>
							</tr>
						</table>
					</form>
				</div>
			</div>
		</div>
	</main>
	<c:if test="${mode == 'update'}">
		<script type="text/javascript">
			function deleteFile(psnum) {
				if (!confirm('파일을 삭제하시겠습니까?')) {
					return;
				}

				let url = '${pageContext.request.contextPath}/policy/deleteFile?psnum='
						+ psnum + '&page=${page}';
				location.href = url;
			}
		</script>
	</c:if>



	<script type="text/javascript"
		src="${pageContext.request.contextPath}/dist/vendor/se2/js/service/HuskyEZCreator.js"
		charset="utf-8"></script>
	<script type="text/javascript">
		function submitForm() {
			const f = document.boardForm;

			oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
			
			f.action = '${pageContext.request.contextPath}/policy/${mode}';

			f.submit();
		}
	</script>

	<script type="text/javascript"
		src="${pageContext.request.contextPath}/dist/vendor/se2/js/service/HuskyEZCreator.js"
		charset="utf-8"></script>
	<script type="text/javascript">
		var oEditors = [];
		nhn.husky.EZCreator
				.createInIFrame({
					oAppRef : oEditors,
					elPlaceHolder : 'ir1',
					sSkinURI : '${pageContext.request.contextPath}/dist/vendor/se2/SmartEditor2Skin.html',
					fCreator : 'createSEditor2',
					fOnAppLoad : function() {
						// 로딩 완료 후
						oEditors.getById['ir1'].setDefaultFont('돋움', 12);
					},
				});

		function submitContents(elClickedObj) {
			oEditors.getById['ir1'].exec('UPDATE_CONTENTS_FIELD', []);
			try {
				if (!check()) {
					return;
				}

				elClickedObj.submit();

			} catch (e) {
			}
		}
	</script>


	<footer class="mt-auto py-2 text-center w-100"
		style="left: 0px; bottom: 0px; background: #F7F9FA;">
		<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
	</footer>

	<jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />
</body>
</html>