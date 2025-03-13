<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>LifeOn - 상품 및 재고 등록</title>

<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp"/>
<style>
    .wrapper {
        display: flex;
    }
    .container {
        flex-grow: 1;
        padding: 20px;
    }
    .form-group {
        margin-bottom: 15px;
    }
    .form-group label {
        display: block;
        font-weight: bold;
        margin-bottom: 5px;
    }
    .form-group input, .form-group select, .form-group textarea {
        width: 100%;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 5px;
    }
    .btn {
        padding: 10px 15px;
        border: none;
        background-color: #007bff;
        color: white;
        cursor: pointer;
        border-radius: 5px;
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
        <h2>상품 및 재고 등록</h2>
		
		<hr>
        <form name="productForm" method="post" enctype="multipart/form-data">
            <h4>📌 상품 정보 입력</h4>

            <div class="form-group">
                <label for="productName">상품명</label>
                <input type="text" id="pname" name="pname" required>
            </div>


            <div class="form-group">
                <label for="bigCategory">카테고리 (대)</label>
                <select id="bigCategory" name="cbn" required onchange="categoryCheck();">
                    <option value="">카테고리를 선택하세요</option>
                    <c:forEach var="prize" items="${bigCategory}">
                        <option value="${prize.cbn}">${prize.cbc}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="smallCategory">카테고리 (소)</label>
                <select id="smallCategory" name="csn" required disabled>
                    <option value="">먼저 대분류를 선택하세요</option>
                </select>
            </div>

            <div class="form-group">
                <label for="productDesc">상품 설명</label>
                <textarea id="productDesc" name="pct" required></textarea>
            </div>

            <div class="form-group">
                <label for="thumbnailImage">대표 이미지</label>
                <input type="file" id="thumbnailImage" name="pphFile" required>
            </div>
            
            <div class="form-group">
                <label for="thumbnailImage">상품 이미지</label>
                <input type="file" id="Image" name="pppFile" multiple>
            </div>
            

            <h4>📌 재고 정보 입력</h4>

            <div class="form-group">
                <label for="supplier">업체명</label>
                <input type="text" id="supplier" name="ptsc" required>
            </div>

            <div class="form-group">
                <label for="stockQuantity">재고 수량</label>
                <input type="number" id="stockQuantity" name="ptsq" required min="1">
            </div>

            <input type="hidden" name="ptype" value="공동구매">
            <input type="hidden" name="ptst" value="상품등록">

            <button type="button" class="btn" onclick="productOk();">상품 및 재고 등록</button>
        </form>
    </div>
</main>

<footer>
    <jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp"/>

<script>
function productOk(){
	const f = document.productForm;
	
	let str;
	
	str = f.pname.value;
	if(!str){
		alert('상품명을 입력하세요');
		f.pname.focus();
		return;
	}
	
	str = f.bigCategory.value;
	if(!str){
		alert('카테고리(대)를 선택하세요');
		f.bigCategory.focus();
		return;
	}
	
	str = f.smallCategory.value;
	if(!str){
		alert('카테고리(소)를 선택하세요');
		f.smallCategory.focus();
		return;
	}
	
	str = f.productDesc.value;
	if(!str){
		alert('상품설명을 입력하세요');
		f.productDesc.focus();
		return;
	}
	
	str = f.thumbnailImage.value;
	if(!str){
		alert('대표사진을 선택하세요');
		f.thumbnailImage.focus();
		return;
	}
	
	str = f.Image.value;
	if(!str){
		alert('상품 이미지를 선택하세요');
		f.Image.focus();
		return;
	}
	
	str = f.supplier.value;
	if(!str){
		alert('업체명을 입력하세요');
		f.supplier.focus();
		return;
	}
	str = f.stockQuantity.value;
	if(!str){
		alert('재고수량을 입력하세요');
		f.stockQuantity.focus();
		return;
	}
	
	
	
	
	
    f.action = '${pageContext.request.contextPath}/admin/productManage/stockRegister';
    f.submit();
}


function categoryCheck() {
    // 선택된 대분류 카테고리 값 가져오기
    let cbn = $('#bigCategory').val();

    if (!cbn) {
        $('#smallCategory').html("<option value=''>:: 카테고리 선택 ::</option>");
        $('#smallCategory').prop("disabled", true);
        return;
    }

    let url = '${pageContext.request.contextPath}/admin/productManage/smallCategories';

    // AJAX: POST 방식으로 JSON 요청
    $.post(url, { cbn: cbn }, function(data) {
        if (data.length > 0) {
            let options = "<option value=''>:: 카테고리 선택 ::</option>";
            
            $.each(data, function(index, category) {
                options += "<option value='" + category.csn + "'>" + category.csc + "</option>";
            });

            $('#smallCategory').html(options);
            $('#smallCategory').prop("disabled", false);
        } else {
            $('#smallCategory').html("<option value=''>소분류 없음</option>");
            $('#smallCategory').prop("disabled", true);
        }
    }, 'json');
    
}
</script>

</body>
</html>
