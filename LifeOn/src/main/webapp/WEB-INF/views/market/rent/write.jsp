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
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/market.css" type="text/css">

<script type="text/javascript">
function inputNumberFormat(obj) {
    obj.value = comma(uncomma(obj.value));
}

function comma(str) {
    str = String(str);
    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}

function uncomma(str) {
    str = String(str);
    return str.replace(/[^\d]+/g, '');
}
</script>

<script type="text/javascript">
function check() {
    const f = document.rentForm;
    let str;
    
    str = f.pname.value.trim();
    if(! str) {
        alert('물품명을 입력하세요.');
        f.pname.focus();
        return false;
    }
    
    if (str.length > 10) {
        alert('물품명은 10자 이하로 입력해주세요.');
        f.pname.focus();
        return false;
    }
    
    str = f.csn.value;
    if(! str) {
        alert('카테고리를 선택해주세요.');
        f.csn.focus();
        return false;
    }
    
    str = uncomma(f.prp.value);
    if(! str) {
        alert('대여비를 입력해주세요.');
        f.prp.focus();
        return false;
    }
    
    if (parseInt(str) < 0) {
        alert('0원 이상의 금액만 가능합니다.');
        f.prp.focus();
        return false;
    }
    
    if (parseInt(str) > 1000000000) {
        alert('최대 10억 원까지만 입력 가능합니다.');
        f.prp.focus();
        return false;
    }
    
    if (parseInt(str) % 10 !== 0) {
        alert('1원 단위는 입력이 불가능 합니다.');
        f.prp.focus();
        return false;
    }
    
    if (str.includes('.')) {
        alert('소수점은 입력이 불가능 합니다.');
        f.prp.focus();
        return false;
    }
    
    str = uncomma(f.prlp.value);
    if(! str) {
        alert('보증금를 입력해주세요.');
        f.prlp.focus();
        return false;
    }
    
    if (parseInt(str) < 0) {
        alert('0원 이상의 금액만 가능합니다.');
        f.prlp.focus();
        return false;
    }
    
    if (parseInt(str) > 1000000000) {
        alert('최대 10억 원까지만 입력 가능합니다.');
        f.prlp.focus();
        return false;
    }
    
    if (parseInt(str) % 10 !== 0) {
        alert('1원 단위는 입력이 불가능 합니다.');
        f.prlp.focus();
        return false;
    }
    
    if (str.includes('.')) {
        alert('소수점은 입력이 불가능 합니다.');
        f.prlp.focus();
        return false;
    }
    
    str = f.pra.value;
    if(! str) {
        alert('거래장소를 검색해주세요.');
        document.getElementById("addr_btn").focus();
        return false;
    }
    
    oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", [])
    str = f.pct.value.trim();
    if(! str || str === '<p><br></p>') {
        alert('물품상세설명을 입력하세요.');
        oEditors.getById["ir1"].exec("FOCUS")
        return false;
    }
	
    str = f.pphFile.value;
    if(! f.pphFile.value && ${mode == 'write'}) {
        alert('썸네일 이미지를 등록해주세요.');
        f.pphFile.focus();
        return false;
    }
	
    f.prp.value = uncomma(f.prp.value);
    f.prlp.value = uncomma(f.prlp.value);
    
    f.action = '${pageContext.request.contextPath}/market/rent/${mode}';
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
	<!-- 배너 -->
    <div class="body-title">
    	<em style="font-size: 30px; font-weight: 800; text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.3);">방치되고 있는 물건을 빌려주세요!</em>
	</div>
	
	<div class="body-container">
		<div class="rent_container">
			<form name="rentForm" class="rentForm" method="post" enctype="multipart/form-data">
				<table class="table rent_table">
					<tr>
						<td scope="row">물품명</td>
						<td colspan="2">
							<div>
								<input type="text" name="pname" maxlength="100" class="rent-control" placeholder="물품명을 입력해주세요." value="${dto.pname}">
								<input type="hidden" class="form-control-plaintext" value="${sessionScope.member.num}">
	                        </div>
						</td>
						
	                   	<td>
	                        <div style="display: flex; justify-content: flex-start;">
	                        	<c:if test="${mode=='write'}">
			                        <select class="rent-select" id="categoryNum" name="cbn" onchange="categoryCheck();">
				                    	<option value="0" selected>대분류 선택</option>
			                        	<c:forEach var="main" items="${listCategory}">
				                            <option value="${main.cbn}">${main.cbc}</option>
				                    	</c:forEach>
		                        	</select>
			                        <select class="rent-select" name="csn" id="subCategory">
			                            <option value="" disabled selected>소분류 선택</option>
			                        </select>
	                        	</c:if>
	                        	<c:if test="${mode=='update'}">
	                        		<select class="rent-select" id="categoryNum" name="cbn" onchange="categoryCheck();">
				                    	<option value="0" selected>대분류 선택</option>
			                        	<c:forEach var="main" items="${listCategory}">
				                            <option value="${main.cbn}" ${cbn==main.cbn?"selected":""}>${main.cbc}</option>
				                    	</c:forEach>
		                        	</select>
			                        <select class="rent-select" name="csn" id="subCategory">
			                            <option value="" disabled>소분류 선택</option>
			                            <c:forEach var="sub" items="${listSubCategory}">
			                            	<option value="${sub.csn}" ${csn==sub.csn?"selected":""}>${sub.csc}</option>
			                    		</c:forEach>
			                        </select>
	                        	</c:if>
	                        </div>
						</td>
					</tr>
					
					<tr>
						<td scope="row">대여비</td>
						<td colspan="3" align="left">
							<input type="text" name="prp" class="rent-control price_input" style="width: 237px;" placeholder="1일 기준 대여비를 입력해주세요." value="${dto.prp}" onkeyup="inputNumberFormat(this)">
						</td>
					</tr>

					<tr>
						<td scope="row">보증금</td>
						<td colspan="3" align="left">
							<div>
								<input type="text" name="prlp" class="rent-control price_input" style="width: 237px;" placeholder="보증금을 입력해주세요." value="${dto.prlp}" onkeyup="inputNumberFormat(this)">
	                        </div>
						</td>
					</tr>
					
					<tr>
						<td scope="row">거래장소</td>
						<td colspan="3">
							<div style="display: flex;">
								<input type="text" name="pra" id="pra" maxlength="100" class="rent-control" style="width: 90%;" placeholder="거래하시는 장소를 검색해주세요." value="${dto.pra}" readonly>
								<button class="ssbtn" id="addr_btn" type="button" style="margin-left: 3px; width: 10%; border-radius: 0px;" onclick="daumPostcode();">검색</button>
	                        </div>
						</td>
					</tr>
					
					<tr>
						<td scope="row">상세주소</td>
						<td colspan="3">
							<div>
								<input type="text" name="prad" id="prad" maxlength="100" class="rent-control" placeholder="상세주소 또는 특이사항을 입력해주세요. (선택사항)" value="${dto.prad}">
	                        </div>
						</td>
					</tr>
					
					<tr>
						<td scope="row" style="vertical-align: top; padding-top: 20px;">상세설명</td>
						<td colspan="3">
							<textarea name="pct" id="ir1" placeholder="물품상세설명을 작성해주세요." class="form-control" style="width: 100%; height: 400px;">${dto.pct}</textarea>
						</td>
					</tr>
					
					<c:if test="${mode == 'write'}">
						<tr>
							<td scope="row">썸네일이미지</td>
							<td width="10%">
								<div class="thumbnail-wrap">
									<div class="thumbnail">
									 	<img src=""  class="thumbnailImage" name="thumbnailImage" id="thumbnailImage" alt="썸네일">
				                        <input type="file" name="pphFile" id="pphFile" accept="image/*" style="display: none;">
									</div>
								</div>
							</td>
							<td scope="row" width="15%">추가이미지</td>
							<td colspan="3">
								<div class="img-grid"><img class="item img-add rounded" src="${pageContext.request.contextPath}/dist/images/add_photo.png"></div>
								<input type="file" name="selectFile" accept="image/*" multiple style="display: none;" class="rent-control">
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
				                        <input type="file" name="pphFile" id="pphFile" accept="image/*" style="display: none;">
									</div>
								</div>
							</td>
							<td scope="row" width="15%">추가이미지</td>
							<td colspan="3">
								<div class="img-grid"><img class="item img-add rounded" src="${pageContext.request.contextPath}/dist/images/add_photo.png"></div>
								<input type="file" name="selectFile" accept="image/*" multiple style="display: none;" class="rent-control">
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
											<img src="${pageContext.request.contextPath}/uploadPath/rent/${vo.ppp}"
												class="delete-img"
												data-fileNum="${vo.ppnum}">
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
							<button type="button" class="ssbtn" onclick="location.href='${pageContext.request.contextPath}/market/rent/main';">${mode=='update'?'수정취소':'등록취소'}&nbsp;<i class="bi bi-x"></i></button>
	
							<c:if test="${mode == 'update'}">
								<input type="hidden" name="num" value="${dto.num}">
								<input type="hidden" name="pnum" value="${dto.pnum}">
								<input type="hidden" name="pph" value="${dto.pph}">
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
	    let imgName = '${dto.pph}';
	    
	    // 초기 썸네일 설정
	    if (imgName) {
	        let imgSrc = '${pageContext.request.contextPath}/uploadPath/rent/' + imgName;
	        $('#thumbnailImage').attr('src', imgSrc);  // img 태그의 src 속성으로 이미지 설정
	    } else {
	        $('#thumbnailImage').attr('src', '${pageContext.request.contextPath}/dist/images/add_photo.png');
	    }
	    
	    // 이미지 클릭 시 파일 선택 창 열기
	    $('#thumbnailImage').click(function(){
	        $('form[name=rentForm] input[name=pphFile]').trigger('click');
	    });
	    
	    // 파일 선택 후 이미지 변경
	    $('form[name=rentForm] input[name=pphFile]').change(function(){
	        let file = this.files[0];
	        
	        // 이미지 파일만 처리
	        if (! file.type.match('image.*')) {
	            this.focus();
	            return false;
	        }

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
				let url = '${pageContext.request.contextPath}/market/rent/deleteFile';

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

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript">
function daumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
			console.log('### DATA ::: ', data);
            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var fullAddr = ''; // 최종 주소 변수
            var extraAddr = ''; // 조합형 주소 변수

            // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                fullAddr = data.roadAddress;

            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                fullAddr = data.jibunAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
            if(data.userSelectedType === 'R'){
                //법정동명이 있을 경우 추가한다.
                if(data.bname !== ''){
                    extraAddr += data.bname;
                }
                // 건물명이 있을 경우 추가한다.
                if(data.buildingName !== ''){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('pra').value = fullAddr;

            // 커서를 상세주소 필드로 이동한다.
            document.getElementById('prad').focus();
        }
    }).open();
}
</script>

<script type="text/javascript">
window.addEventListener('DOMContentLoaded', evt => {
	var sel_files = [];
	
	const viewerEL = document.querySelector('.rent_table .img-grid');
	const imgAddEL = document.querySelector('.rent_table .img-add');
	const inputEL = document.querySelector('form[name=rentForm] input[name=selectFile]');
	
	imgAddEL.addEventListener('click', ev => {
		inputEL.click();
	});
	
	inputEL.addEventListener('change', ev => {
		if(! ev.target.files) {
			let dt = new DataTransfer();
			for(let f of sel_files) {
				dt.items.add(f);
			}
			document.rentForm.selectFile.files = dt.files;
			
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
		
		document.rentForm.selectFile.files = dt.files;		
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
			document.rentForm.selectFile.files = dt.files;
			
			e.target.remove();
		}
	});	
});

function categoryCheck() {
    let cbn = $('#categoryNum').val();

    if (! cbn || cbn == 0) {
        $('#subCategory').html("<option value=''>소분류 선택</option>");
        $('#subCategory').prop("disabled", true);
        return;
    }
    
    let url = '${pageContext.request.contextPath}/market/rent/listSubCategory';

    $.post(url, { cbn: cbn }, function(data) {
        if (data.length > 0) {
            let options = "<option value=''>소분류 선택</option>";
            
            $.each(data, function(index, category) {
                options += "<option value='" + category.csn + "'>" + category.csc + "</option>";
            });

            $('#subCategory').html(options);
            $('#subCategory').prop("disabled", false);
        } else {
            $('#subCategory').html("<option value=''>소분류 없음</option>");
            $('#subCategory').prop("disabled", true);
        }
    }, 'json');
    
}
</script>

<footer class="mt-auto py-2 text-center w-100" style="left: 0px; bottom: 0px; background: #F7F9FA;">
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>