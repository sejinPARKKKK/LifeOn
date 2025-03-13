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
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/forms.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/free.css" type="text/css">

</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
	<jsp:include page="/WEB-INF/views/lounge2/layout/menu.jsp"/>
</header>
	
<script type="text/javascript">
function check() {
    const f = document.freeForm;
    let str;
    
    str = f.subject.value.trim();
    if(! str) {
        alert('제목을 입력하세요.');
        f.subject.focus();
        return false;
    }
    
	if(f.subject.length > 300) {
		alert('제목은 30자 이하만 가능합니다.');
		f.subject.focus();
		return false;
	}

    str = f.content.value.trim();
    if(! str || str === '<p><br></p>') {
        alert('내용을 입력하세요.');
        f.content.focus();
        return false;
    }
    
	if(f.content.length > 300) {
		alert('내용은 약 1300자 이하만 가능합니다.');
		f.content.focus();
		return false;
	}

    f.action = '${pageContext.request.contextPath}/lounge2/tip/${mode}';
    f.submit();
    // return true;
}
</script>
	
<main class="min-vh-100">
	<!-- 배너 -->
    <div class="body-title">
    	<em style="font-size: 30px; font-weight: 800; text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.3);">알짜배기 팁! 생활 속 아이디어를 공유해요!</em>
	</div>
	
	<div class="body-container">
		<div class="body-content" style="justify-content: center;">
			<aside class="sidenav">
			</aside>
			
			<div class="main_content"">
				<form name="freeForm" class="freeForm" method="post" enctype="multipart/form-data">
					<table class="table write-form">
						<tr>
							<td scope="row" style="vertical-align: middle;">제&emsp;목</td>
							<td>
								<input type="text" name="subject" maxlength="100" class="free-control" placeholder="제목을 작성해주세요." value="${dto.subject}">
								<input type="hidden" class="form-control-plaintext" value="${sessionScope.member.nickName}">
							</td>
						</tr>
	
						<tr>
							<td scope="row" style="padding-top: 20px;">내&emsp;용</td>
							<td>
								<textarea name="content" id="ir1" placeholder="내용을 작성해주세요." class="free-control" style="width: 100%; height: 400px;">${dto.content}</textarea>
							</td>
						</tr>
						
						<tr>
							<td scope="row" style="vertical-align: middle;">첨부파일</td>
							<td>
							<div class="filebox">
								<input class="upload-name" value="첨부파일" placeholder="첨부파일" readonly="readonly">
							    <label for="file">파일선택</label> 
							    <input type="file" id="file" name="selectFile" multiple>
							</div>
							</td>
						</tr>
						
						<c:if test="${mode == 'update'}">
							<c:forEach var="vo" items="${listFile}">
								<tr> 
									<td scope="row" style="vertical-align: middle;">첨부된파일</td>
									<td>
										<p class="free-control">
											<span class="delete-file" data-fileNum="${vo.fnum}"><i class="bi bi-trash"></i></span> 
											${vo.cpfname}
										</p>
									</td>
								  </tr>
							</c:forEach>
						</c:if>
					</table>
					
					<table class="table table-borderless">
	 					<tr>
							<td class="text-center">
								<button type="button" class="ssbtn" onclick="check();">${mode=='update'?'수정완료':'등록완료'}&nbsp;<i class="bi bi-check2"></i></button>
								<button type="button" class="ssbtn" onclick="location.href='${pageContext.request.contextPath}/lounge2/tip';">${mode=='update'?'수정취소':'등록취소'}&nbsp;<i class="bi bi-x"></i></button>

								<c:if test="${mode == 'update'}">
									<input type="hidden" name="num" value="${dto.num}">
									<input type="hidden" name="psnum" value="${dto.psnum}">
									<input type="hidden" name="page" value="${page}">
								</c:if>
							</td>
						</tr>
					</table>
				</form>
			</div>
			
			<aside class="sidebar">
			</aside>
		</div>
	</div>
	
	<c:if test="${mode=='update'}">
		<script type="text/javascript">
			$('.delete-file').click(function(){
				if(! confirm('선택한 파일을 삭제 하시겠습니까 ? ')) {
					return false;
				}
				
				let $tr = $(this).closest('tr');
				let fnum = $(this).attr('data-fileNum');
				let url = '${pageContext.request.contextPath}/lounge2/tip/deleteFile';
				
				$.ajaxSetup({ beforeSend: function(e) { e.setRequestHeader('AJAX', true); } });
				$.post(url, {fnum: fnum}, function(data){
					$($tr).remove();
				}, 'json').fail(function(jqXHR){
					console.log(jqXHR.responseText);
				});
			});
		</script>
	</c:if>

<script type="text/javascript" src="${pageContext.request.contextPath}/dist/vendor/se2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">

/* var oEditors = [];
nhn.husky.EZCreator.createInIFrame({
	oAppRef: oEditors,
	elPlaceHolder: 'ir1',
	sSkinURI: '${pageContext.request.contextPath}/dist/vendor/se2/SmartEditor2Skin.html',
	fCreator: 'createSEditor2',
	fOnAppLoad: function(){
		// 로딩 완료 후
		oEditors.getById['ir1'].setDefaultFont('돋음', 12);
	},
});

function submitContents(elClickedObj) {
	 oEditors.getById['ir1'].exec('UPDATE_CONTENTS_FIELD', []);
	 try {
		if(! check()) {
			return;
		}
		
		elClickedObj.submit();
		
	} catch(e) {
	}
} */

$("#file").on('change', function() {
    var fileCount = $("#file")[0].files.length;
    $(".upload-name").val(fileCount + "개 파일 선택됨");
});
</script>
</main>

<footer class="mt-auto py-2 text-center w-100" style="left: 0px; bottom: 0px; background: #F7F9FA;">
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>