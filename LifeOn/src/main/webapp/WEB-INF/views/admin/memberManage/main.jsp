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
.body-title {
	margin-bottom: 20px;
}

.body-middle {
	display: flex;
	align-items: center;
	justify-content: space-between;
}

.left {
	font-size: 15px;
	display: flex;
	gap: 20px;
	margin-bottom: 20px;
}

.right {
	display: flex;
	gap: 10px;
}

.nav-link:hover {
	color: #006AFF;
}

.nav-link {
	border-color: white;
	color: black;
}

.nav-link.active {
	border-color: white;
	color: #006AFF;
}

.btn {
	background-color: #006AFF;
	color: white;
}

.table th, .table td {
	text-align: center;
	vertical-align: middle;
}

.table td button {
	display: flex;
	justify-content: center;
	align-items: center;
	margin: 0 auto;
}
</style>

</head>
<body>


	<header class="container-fluid header-top fixed-top px-4">
		<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />
	</header>

	<main>
		<jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
		<div class="wrapper" style="display: flex; justify-content: center;">
			<div class="body-container" style="width: 900px;">
				<div class="body-title">
					<h3>
						<i class="bi bi-app"></i> 회원관리
					</h3>
				</div>

				<div class="body-main">
					<div class="body-middle">
						<div class="left">
							<button class="nav-link navA">전체</button>
							<button class="nav-link navB">회원</button>
							<button class="nav-link navC">관리자</button>
						</div>

						<div class="right">
							<form name="searchForm">
								<select name="schType">
									<option value="all" ${schType=="all"?"selected" : ""}>전체</option>
									<option value="id" ${schType=="id"?"selected" : ""}>아이디</option>
									<option value="nickName" ${schType=="nickName"?"selected" : ""}>닉네임</option>
								</select>
								<input type="search" name="kwd" placeholder="검색어를 입력하세요">
								<button type="submit" class="btn" style="background-color: #666;" onclick="searchList()">검색</button>
							</form>
						</div>
					</div>

					<table class="table table-hover board-list">
						<thead class="table-light">
							<tr>
								<th width="100">아이디</th>
								<th width="100">이름</th>
								<th width="100">그룹(역할)</th>
								<th width="100">활성화 상태</th>
								<th width="100">수정일자</th>
								<th width="100"></th>
							</tr>
						</thead>

						<tbody>
							<c:forEach var="member" items="${memberList}">
								<tr>
									<td>${member.id}</td>
									<td>${member.nickName}</td>
									<td><c:choose>
											<c:when test="${member.grade==1}">관리자</c:when>
											<c:otherwise>회원</c:otherwise>
										</c:choose></td>
									<td><c:choose>
											<c:when test="${member.block == 0}">
												<i class="bi bi-circle"></i>
											</c:when>
											<c:when test="${member.block == 1}">
												<i class="bi bi-x text-danger"></i>
											</c:when>
										</c:choose></td>
									<td>${member.mod_date}</td>
									<td>
										<button type="button" class="btn authorityBtn"
											data-bs-toggle="modal" data-bs-target="#authorityModal"
											data-member-num="${member.num}" data-member-id="${member.id}"
											data-member-block="${member.block}">권한변경</button>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</main>
	<div class="pagenavigation" style="display: 80px;">${paging}</div>
	<!-- 모달창 코드 추가 -->
	<div class="modal fade" id="authorityModal" tabindex="-1"
		aria-labelledby="authorityModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="authorityModalLabel">권한 변경</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="닫기"></button>
				</div>
				<div class="modal-body">
					<form id="authorityForm" action="updateMemberAuthority"
						method="post">
						<input type="hidden" name="memberNum" id="memberNum">
						<div class="mb-3">
							<label for="memberId" class="form-label">회원 아이디</label> <input
								type="text" class="form-control" id="memberId" name="memberId"
								readonly>
						</div>
						<div class="mb-3">
							<label for="memberBlock" class="form-label">활성화 상태</label> <select
								class="form-select" id="memberBlock" name="memberBlock">
								<option value="0">활성화</option>
								<option value="1">비활성화</option>
							</select>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">취소</button>
					<button type="button" class="btn btn-primary" id="saveBtn">저장</button>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript">
	
	// 검색 키워드 입력란에서 엔터를 누른 경우 서버 전송 막기 
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
		
		// form 요소는 FormData를 이용하여 URLSearchParams 으로 변환
		const formData = new FormData(f);
		let requestParams = new URLSearchParams(formData).toString();
		
		let url = '${pageContext.request.contextPath}/admin/memberManage/main';
		location.href = url + '?' + requestParams;
	}
	
	document.addEventListener("DOMContentLoaded", function() {
		const buttons = document.querySelectorAll(".left .nav-link");
		const defaultBtn = document.querySelector(".navA");
		
		//URL에서 현재 role 파라미터 가져오기
		const urlParams = new URLSearchParams(window.location.search);
		const currentRole = urlParams.get('role') || 'all';
		
		
		//현재 역할에 맞는 탭 활성화
		buttons.forEach((button) => {
			if (
				(currentRole === 'all' && button.classList.contains("navA")) ||
				(currentRole === 'member' && button.classList.contains("navB")) ||
				(currentRole === 'admin' && button.classList.contains("navC"))
			) {
				button.classList.add("active");
			} else {
				button.classList.remove("active");
			}
		});
		
		//초기 로드시 탭이 선택되지 않았다면 기본 탭 활성화
		if(!document.querySelector(".left .nav-link.active") && defaultBtn) {
			defaultBtn.classList.add("active");
		}
		
		buttons.forEach((button) => {
			button.addEventListener("click", (event) => {
				const targetBtn = event.target.closest(".nav-link");
				if(!targetBtn) return;
				
				buttons.forEach((btn) => btn.classList.remove("active"));
				targetBtn.classList.add("active");
				
				//현재 URL 가져오기
				const currentUrl = new URL(window.location.href);
				
				// 선택한 탭에 따라 role 파라미터 설정
				if(targetBtn.classList.contains("navA")) {
					currentUrl.searchParams.set("role", "all");
				} else if (targetBtn.classList.contains("navB")) {
					currentUrl.searchParams.set("role", "member");
				} else if (targetBtn.classList.contains("navC")) {
					currentUrl.searchParams.set("role", "admin");
				}
				
				// 페이지 번호 초기화
				currentUrl.searchParams.set("page", "1");
				
				// 리다이렉트
				window.location.href = currentUrl.toString();
			});
		});
	});
	
	//모달의 show 이벤트에서 버튼의 data값을 채워넣음 
	document.getElementById('authorityModal').addEventListener('show.bs.modal', event => {
		const btn = event.relatedTarget;
		document.getElementById('memberId').value = btn.dataset.memberId;
		document.getElementById('memberNum').value = btn.dataset.memberNum;
		document.getElementById('memberBlock').value = btn.dataset.memberBlock;
		
	});
	// 저장 버튼 클릭 시 폼 제출
	document.getElementById('saveBtn').onclick = () =>
	    document.getElementById('authorityForm').submit();
	</script>

	<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />

	<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
</body>
</html>