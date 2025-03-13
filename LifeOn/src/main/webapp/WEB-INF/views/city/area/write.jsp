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
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/area.css" type="text/css">

<script type="text/javascript">
function check() {
    const f = document.areaForm;
    let str;
    
    str = f.rvsubject.value.trim();
    if(! str) {
        alert('제목을 입력하세요.');
        f.rvsubject.focus();
        return false;
    }
    
  
    str = f.lnum.value;
    if(! str) {
        alert('카테고리를 선택해주세요.');
        f.csn.focus();
        return false;
    }
 
    oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", [])
    str = f.rvcontent.value.trim();
    if(! str || str === '<p><br></p>') {
        alert('물품상세설명을 입력하세요.');
        oEditors.getById["ir1"].exec("FOCUS")
        return false;
    }
	
    str = f.thpFile.value;
    if(! f.thpFile.value) {
        alert('썸네일 이미지를 등록해주세요.');
        f.thpFile.focus();
        return false;
    }
	
    
    f.action = '${pageContext.request.contextPath}/city/area/${mode}';
    f.submit()
}
</script>
</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
	<jsp:include page="/WEB-INF/views/market/layout/menu.jsp"/>
</header>
	
<main class="min-vh-100">
	
	<div class="body-container">
		<div class="area_container">
			<form name="areaForm" class="areaForm" method="post" enctype="multipart/form-data">
				<table class="table area_table">
					<tr>
						<td scope="row">지하철역</td>
						<td colspan="2">
							<div>
								<input type="text" name="rvsubject" maxlength="100" class="area-control" placeholder="역이름을 입력해주세요." value="${dto.rvsubject}">
								<input type="hidden" class="form-control-plaintext" value="${sessionScope.member.num}">
	                        </div>
						</td>
							
	                   	<td>
							<div style="display: flex; justify-content: flex-start;">
				                <select class="area-select" id="bigCategory" name="lnum" class="dropdown" required onchange="categoryCheck();" >
				                     <option value="0" selected>지하철역 선택</option>
				                     <c:forEach var="category" items="${Category}">
								        <option value="${category.lnum}" ${category.lnum == dto.lnum ? 'selected' : ''}>${category.ssname}</option>
								    </c:forEach>
				                </select>
				            </div> 
						</td>		
					
					
					<tr>
						<td scope="row">간략한 정보</td>
						<td colspan="3">
							<div>
								<input type="text" name=rssubject id="rssubject" maxlength="100" class="area-control" placeholder="간략한 정보를 입력해주세요" value="${dto.rssubject}">
	                        </div>
						</td>
					</tr>
					
					<tr>
						<td scope="row" style="vertical-align: top; padding-top: 20px;">내용</td>
						<td colspan="3">
							<textarea name="rvcontent" id="ir1" placeholder="내용을 작성해주세요." class="form-control" style="width: 100%; height: 400px;">${dto.rvcontent}</textarea>
						</td>
					</tr>
					
					<c:if test="${mode == 'write'}">
						<tr>
							<td scope="row">썸네일이미지</td>
							<td width="10%">
								<div class="thumbnail-wrap">
									<div class="thumbnail">
									 	<img src=""  class="thumbnailImage" name="thumbnailImage" id="thumbnailImage" alt="썸네일">
				                        <input type="file" name="thpFile" id="thpFile" accept="image/*" style="display: none;">
									</div>
								</div>
							</td>
							<td scope="row" width="15%">추가이미지</td>
							<td colspan="3">
								<div class="img-grid"><img class="item img-add rounded" src="${pageContext.request.contextPath}/dist/images/add_photo.png"></div>
								<input type="file" name="selectFile" accept="image/*" multiple style="display: none;" class="area-control">
							</td>
						</tr>
					</c:if>
					
					<c:if test="${mode=='update'}">
						<tr>
							<td scope="row">등록된 썸네일이미지</td>
							<td width="10%">
								<div class="thumbnail-wrap">
									<div class="thumbnail">
									 	<img src=""  class="thumbnailImage" name="thumbnailImage" id="thumbnailImage" alt="썸네일">
				                        <input type="file" name=thpFile id="thpFile" accept="image/*" style="display: none;">
									</div>
										<button type="button" class="return_btn">되돌리기</button>
								</div>
							</td>
							<td scope="row" width="15%">추가이미지</td>
							<td colspan="3">
								<div class="img-grid"><img class="item img-add rounded" src="${pageContext.request.contextPath}/dist/images/add_photo.png"></div>
								<input type="file" name="selectFile" accept="image/*" multiple style="display: none;" class="area-control">
							</td>
						</tr>
						
						<tr style="height: 116.5px;">
							<td scope="row">등록된 추가이미지</td>
							<td colspan="3"> 
								<div class="img-box">
									<c:if test="${empty listFile}">
										추가로 등록된 이미지가 없습니다.
									</c:if>
									<c:if test="${not empty listFile}">
										<c:forEach var="vo" items="${listFile}">
											<img src="${pageContext.request.contextPath}/uploadPath/area/${vo.ssfname}"
												class="delete-img"
												data-fileNum="${vo.fnum}">
										</c:forEach>
									</c:if>
								</div>
							</td>
						</tr>
					</c:if>
					
				</table>
				
				<table class="table table-borderless">
					<tr>
						<td class="text-center" colspan="3">
							<button type="button" class="ssbtn" onclick="check();">${mode=='update'?'수정완료':'등록완료'}&nbsp;<i class="bi bi-check2"></i></button>
							<button type="button" class="ssbtn" onclick="location.href='${pageContext.request.contextPath}/city/area/main';">${mode=='update'?'수정취소':'등록취소'}&nbsp;<i class="bi bi-x"></i></button>
	
							<c:if test="${mode == 'update'}">
								<input type="hidden" name="num" value="${dto.num}">
								<input type="hidden" name="rvnum" value="${dto.rvnum}">
								<input type="hidden" name="thp" value="${dto.thp}">
								<input type="hidden" name="page" value="${page}">
							</c:if>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</div>
</main>


<script type="text/javascript">
	$(function() {
	    let imgName = '${dto.thp}';
	    
	    // 초기 썸네일 설정
	    if (imgName) {
	        let imgSrc = '${pageContext.request.contextPath}/uploadPath/area/' + imgName;
	        $('#thumbnailImage').attr('src', imgSrc);  // img 태그의 src 속성으로 이미지 설정
	    } else {
	        $('#thumbnailImage').attr('src', '${pageContext.request.contextPath}/dist/images/add_photo.png');
	    }
	    
	    // 이미지 클릭 시 파일 선택 창 열기
	    $('#thumbnailImage').click(function(){
	        $('form[name=areaForm] input[name=thpFile]').trigger('click');
	    });
	    
	    // 파일 선택 후 이미지 변경
	    $('form[name=areaForm] input[name=thpFile]').change(function(){
	        let file = this.files[0];
	        
	        // 이미지 파일만 처리
	        if (! file.type.match('image.*')) {
	            this.focus();
	            return false;
	        }
	        
		    // 되돌리기 변경 버튼 클릭 시
		    $('.return_btn[type="button"]').click(function() {
		        $('#thumbnailImage').attr('src', '${pageContext.request.contextPath}/uploadPath/area/${dto.thp}');
		    });
	        
	        // 선택된 파일을 미리보기로 설정
	        let reader = new FileReader();
	        reader.onload = function(e) {
	            $('#thumbnailImage').attr('src', e.target.result);  // 미리보기 이미지로 설정
	        }
	        reader.readAsDataURL(file);
	    });
	});
</script>


<c:if test="${mode=='update'}">
	<script type="text/javascript">
		$(function(){
			$('.delete-img').click(function(){
				if(! confirm('이미지를 삭제 하시겠습니까 ?')) {
					return false;
				}
				
				let $img = $(this);
				let ppnum = $img.attr('data-fileNum');
				let url = '${pageContext.request.contextPath}/city/area/deleteFile';

				$.ajaxSetup({ beforeSend: function(e) { e.setRequestHeader('AJAX', true); } });
				$.post(url, {ppnum:ppnum}, function(data){
					$img.remove();
				}, 'json').fail(function(jqXHR){
					console.log(jqXHR.responseText);
				});

			});
		});
	</script>
</c:if>

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

<script type="text/javascript">
window.addEventListener('DOMContentLoaded', evt => {
	var sel_files = [];
	
	const viewerEL = document.querySelector('.area_table .img-grid');
	const imgAddEL = document.querySelector('.area_table .img-add');
	const inputEL = document.querySelector('form[name=areaForm] input[name=selectFile]');
	
	imgAddEL.addEventListener('click', ev => {
		inputEL.click();
	});
	
	inputEL.addEventListener('change', ev => {
		if(! ev.target.files) {
			let dt = new DataTransfer();
			for(let f of sel_files) {
				dt.items.add(f);
			}
			document.areaForm.selectFile.files = dt.files;
			
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
		
		document.areaForm.selectFile.files = dt.files;		
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
			document.areaForm.selectFile.files = dt.files;
			
			e.target.remove();
		}
	});	
});

</script>

<footer class="mt-auto py-2 text-center w-100" style="left: 0px; bottom: 0px; background: #F7F9FA;">
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>