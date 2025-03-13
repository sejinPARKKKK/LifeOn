<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">


<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/forms.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/board.css" type="text/css">

<style type="text/css">
.body-title{
	width: 80%;
	max-width: 900px;
	margin : auto;
	margin-top: 40px;
	font-size: 24px;
	font-weight: 600;
}

.write-form{
	width: 80%;
	max-width: 900px;
	margin : auto;
}

td[scope="row"] {
	text-align : center;
	vertical-align: middle;
	background-color:#FBFBFB;
}
</style>

<script type="text/javascript">
function check() {
    const f = document.boardForm;
    
    oEditors.getById['ir1'].exec('UPDATE_CONTENTS_FIELD', []);
    
    let str;
	
    str = f.subject.value.trim();
    if( !str ) {
        alert('제목을 입력하세요. ');
        f.subject.focus();
        return false;
    }
    
    if(f.subject.length > 300) {
		alert('제목은 30자 이하만 가능합니다.');
		f.subject.focus();
		return false;
	}

    str = f.content.value.trim();
    if( !str || str === '<p><br></p>') {
        alert('내용을 입력하세요. ');
        f.content.focus();
        return false;
    }
    
    if(f.content.length > 300) {
		alert('내용은 약 1300자 이하만 가능합니다.');
		f.content.focus();
		return false;
	}

    f.action =  '${pageContext.request.contextPath}/lounge1/${bdtype}/${mode}';
    f.submit();
 
}
</script>
<!--  
<c:if test="${empty sessionScope.member}">
    <script type="text/javascript">
        alert('로그인 후 이용해 주세요.');
        location.href = '${pageContext.request.contextPath}/login';  // 로그인 페이지로 리디렉션
    </script>
</c:if>
-->
</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>
	
<main class="d-flex flex-column min-vh-100 align-items-center" style="padding-top: 84px;">
    <div class="container">
		<div class="body-container">
		  <div class="body-title">
			<i class="bi bi-app"></i> 
			<c:choose>
				<c:when test="${bdtype == 'room'}">인테리어</c:when> 
				<c:when test="${bdtype == 'recipe'}">자취 레시피</c:when> 
			</c:choose>
			</div>
			
			<div class="body-main">
				<form name="boardForm" method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/lounge1/write/${bdtype}">
					<table class="table mt-3 write-form" style="border: 1px solid #e0e0e0;">
						<tr>
							<td class="col-sm-2" scope="row">제 목</td>
							<td>
								<input type="text" name="subject" maxlength="100" class="form-control" value="${dto.subject}">
							</td>
						</tr>
						
						<tr>
							<td class="col-sm-2" scope="row"> 작성자명 </td>
							<td>
								<p class="form-control-plaintext">${sessionScope.member.nickName}</p>
							</td>
						</tr>
						
						<tr>
							<td class="col=sm-2" scope="row">내 용</td>
							<td>
								<textarea name="content" id="ir1" class="form-control" style="width: 99%; height: 400px;">${dto.content}</textarea>
							</td>
						</tr>
						
						<tr>
							<td scope="row" style="vertical-align: middle;">썸네일</td>
							<td>
							<div class="filebox">
								<input class="upload-name" value="첨부파일" placeholder="첨부파일" readonly="readonly">
							    <label for="file">파일선택</label> 
							    <input type="file" id="file" name="selectFile" multiple>
							</div>
							</td>
						</tr>
						
						<c:if test="${mode == 'update'}">
								<tr> 
									<td scope="row" style="vertical-align: middle;">첨부된파일</td>
									<td>
										<div class="free-control">
										<c:forEach var="vo" items="${listFile}">
										 <img src="${pageContext.request.contextPath}/uploadPath/lounge1/${vo.ssfname}"
											 class="delete-file" data-fileNum="${vo.fnum}"><i class="bi bi-trash"></i>
											${vo.cpfname}
									</c:forEach>
										</div>
									</td>
								  </tr>
						</c:if>
					</table>
					
					<table class="table table-borderless">
						<tr>
							<td class="text-center">
								<button type="button" class="btn btn-dark" onclick="check();">${mode == "update" ? "수정완료" : "등록완료"}&nbsp;<i class="bi bi-check2"></i></button>
								<button type="reset" class="btn btn-light">다시입력</button>
								<button type="button" class="btn btn-light" onclick="location.href='${pageContext.request.contextPath}/lounge1/${bdtype}';">${mode == "update" ? "수정취소" : "등록취소"}&nbsp;<i class="bi bi-x"></i></button>
							
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
		</div>
    </div>
</main>

<c:if test="${mode == 'update'}">
	<script type="text/javascript">
		$('.delete-file').click(function(){
			if(! confirm('선택한 파일을 삭제 하시겠습니까 ? ')) {
				return false;
			}
			
			let $tr = $(this).closest('tr');
			let fnum = $(this).attr('data-fileNum');
			let url = '${pageContext.request.contextPath}/lounge/${bdtype}/deleteFile';
			
			$.ajaxSetup({ beforeSend: function(e) { e.setRequestHeader('AJAX', true); } });
			$.post(url, {fnum: fnum}, function(data){
				$($tr).remove();
			}, 'json').fail(function(jqXHR){
				console.log(jqXHR.responseText);
			});
		});
		
	</script>
</c:if>

<script type="text/javascript">
window.addEventListener('DOMContentLoaded', evt => {
	var sel_files = [];
	
	const viewerEL = document.querySelector('.write-form .filebox');
	const imgAddEL = document.querySelector('.write-form .img-add');
	const inputEL = document.querySelector('form[name=boardForm] input[name=selectFile]');
	
	imgAddEL.addEventListener('click', ev => {
		inputEL.click();
	});
	
	inputEL.addEventListener('change', ev => {
		if(! ev.target.files) {
			let dt = new DataTransfer();
			for(let f of sel_files) {
				dt.items.add(f);
			}
			document.boardForm.selectFile.files = dt.files;
			
	    	return;
	    }
		
        for(let file of ev.target.files) {
        	sel_files.push(file);
        	
        	let node = document.createElement('img');
        	node.classList.add('item', 'img-item');
        	node.setAttribute('data-filename', file.name);

        	const reader = new FileReader();
            reader.onload = e => {
            	node.setAttribute('src', e.target.result);
            };
			reader.readAsDataURL(file);
        	
			viewerEL.appendChild(node);
        }
		
		let dt = new DataTransfer();
		for(let f of sel_files) {
			dt.items.add(f);
		}
		
		document.boardForm.selectFile.files = dt.files;		
	});
	
	viewerEL.addEventListener('click', (e)=> {
		if(e.target.matches('.img-item')) {
			if(! confirm('선택한 파일을 삭제 하시겠습니까 ?')) {
				return false;
			}
			
			let filename = e.target.getAttribute('data-filename');
			
		    for(let i = 0; i < sel_files.length; i++) {
		    	if(filename === sel_files[i].name){
		    		sel_files.splice(i, 1);
		    		break;
				}
		    }
		
			let dt = new DataTransfer();
			for(let f of sel_files) {
				dt.items.add(f);
			}
			document.boardForm.selectFile.files = dt.files;
			
			e.target.remove();
		}
	});	
});
</script>

<script type="text/javascript" src="${pageContext.request.contextPath}/dist/vendor/se2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">
var oEditors = [];
nhn.husky.EZCreator.createInIFrame({
	oAppRef: oEditors,
	elPlaceHolder: 'ir1',
	sSkinURI: '${pageContext.request.contextPath}/dist/vendor/se2/SmartEditor2Skin.html',
	fCreator: 'createSEditor2',
	fOnAppLoad: function(){
		// 로딩 완료 후
		oEditors.getById['ir1'].setDefaultFont('돋움', 12);
		
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
}
</script>


<footer class="mt-auto py-2 text-center w-100" style="left: 0px; bottom: 0px; background: #F7F9FA;">
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>