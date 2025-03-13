<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>spring</title>

<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />

<style type="text/css">
 
.body-title{
	margin-bottom : 20px;
}

.btn {
	background-color: white;
	color: black;
}



.body-middle{
	display : flex;
	align-items: center;
	justify-content:space-between;
}

.left {
	font-size : 15px;
	display : flex;
	gap : 20px;
}


.btn{
	background-color: white;
	color : black;
}

.btn:active {
	background-color: #006AFF;
	color : white;
}

.table th, .table td{
	text-align: center;
	vertical-align: middle;
}

.table td button {
	display : flex;
	justify-content: center;
	align-items: center;
	margin:0 auto;
}


</style>


</head>



<body>

	<header class="container-fluid header-top fixed-top px-4">
		<jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
	</header>

	<main>
		<jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
		<div class="wrapper" style="display: flex; justify-content: center;">
			<div class="body-container" style="width: 900px;">
				<div class="body-title">
					<h3>
						<i class="bi bi-app"></i> 게시글 관리 
					</h3>
				</div>

				<div class="body-main">
					<div class="tab">
						<button class="btn btnpolicyinfo">정책정보</button>
						<button class="btn event">이벤트</button>
					</div>
					<div class="body-middle">
						<div class="left">
							<p>	게시글 목록 | 전체 1건											
						</div>
						
						<div class="right">
							<select>
								<option value="entire">전체 </option>
								<option value="subject">제목</option>
								<option value="regdate">등록일</option>
							</select>
							<input type="search" placeholder="검색어를 입력하시오">
							
						</div>		
					</div>
					
					<table class="table table-hover board-list">
						<thead class="table-light">
							<tr>
								<th width="70">번호</th>
								<th>제목</th>
								<th width="100">등록일</th>
								<th width="100">종료일</th>								
								<th width="100">관리자ID</th>	
								<th width="100">조회수</th>																
							</tr>
						</thead>
						
						<tbody>
							<tr>
								<td> 1 </td>
								<td><a href="#">1인가구 혜택</a>  </td>
								<td>2025-02-02</td>
								<td>2025-05-06</td>
								<td> admin</td>
								<td> 10</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</main>
	
	<script type="text/javascript">
    document.addEventListener("DOMContentLoaded", function () {
        const buttons = document.querySelectorAll(".tab .btn");
		const defaultBtn = document.querySelector(".btnpolicyinfo");
       
		// ✅ 페이지 로드 시 "정책정보" 버튼을 기본적으로 활성화
        if (defaultBtn) {
            defaultBtn.classList.add("active");
        	defaultBtn.style.backgroundColor = "#006AFF";
        	defaultBtn.style.color = "white";
        }
		
        // ✅ 버튼 클릭 이벤트 추가 (활성화 상태 전환)
       	buttons.forEach((button) => {
       		button.addEventListener("click", function() {
       			//모든 버튼에서 active 클래스 제거 및 기본 스타일 적용
       			buttons.forEach(btn => {
       				btn.classList.remove("active");
       				btn.style.backgroundColor = "white";
       				btn.style.color = "black"; 
       			});
       			
       			this.classList.add("active");
       			this.style.backgroundColor = "#006AFF";
       			this.style.color = "white";
       			
       		});
       	});
        
      
    });


	</script>

	<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />

	<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
</body>
</html>