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

.report-click {
	cursor: pointer; /* 마우스를 올리면 손 모양으로 변경 */
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
						<i class="bi bi-app"></i> 신고관리
					</h3>
				</div>

				<div class="body-main">
					<div class="body-middle">
						<div class="left">
							<p>신고목록 | 전체 ${dataCount}건
						</div>
					</div>

					<table class="table table-hover board-list">
						<thead class="table-light">
							<tr>
								<th width="70">번호</th>
								<th width="100">신고일</th>
								<th>신고 내용</th>
								<th width="100">신고자</th>
								<th width="100">처리일</th>
								<th width="100">처리 여부</th>
								<th width="100">상태수정</th>
							</tr>
						</thead>

						<tbody>
							<c:forEach var="report" items="${list}">
								<tr>
									<td>${report.repnum}</td>
									<td>${report.repd}</td>
									<td class="report-click" data-repan="${report.repan}">${report.repr}</td>
									<td>${report.nickname}</td>
									<td>${report.repsucees}</td>
									<td>${report.repsucboolean}</td>
									<th>
										<button class="btn status-change-btn"
											data-repan="${report.repan}">변경</button>
									</th>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</main>

	<!-- 신고 상세 모달 -->
	<div id="reportModal" class="modal fade" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<!-- 더 넓은 화면을 위해 modal-lg 추가 -->
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">🚨 신고된 게시글 상세 내용</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<div class="mb-3">
						<strong>제목:</strong> <span id="postTitle" class="text-primary"></span>
					</div>
					<div class="mb-3">
						<strong>작성자:</strong> <span id="postAuthor" class="text-secondary"></span>
					</div>
					<div class="mb-3">
						<strong>내용:</strong>
						<div id="postContent" class="border p-3 rounded bg-light"
							style="max-height: 300px; overflow-y: auto;"></div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-danger" id="deletePostBtn">🚫
						게시글 삭제</button>
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 상태 변경 모달 -->
	<div id="statusChangeModal" class="modal fade" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">🚀 상태 변경</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<input type="hidden" id="hiddenRepan">
					<div class="mb-3">
						<label for="statusSelect" class="form-label">처리 상태 선택:</label> <select
							id="statusSelect" class="form-select">
							<option value="이상없음">이상 없음</option>
							<option value="처리완료">처리 완료</option>
						</select>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-success" id="updateStatusBtn">변경
						완료</button>
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>


	<div class="pagenavigation" style="display: 80px;">${paging}</div>

	<script type="text/javascript">
	document.addEventListener("DOMContentLoaded", function () {
	    document.querySelectorAll(".report-click").forEach(td => {
	        td.addEventListener("click", function () {
	            let repan = this.getAttribute("data-repan");
				console.log(repan);
	            if (!repan) {
	                console.error("repan 값이 없음");
	                return;
	            }

	            // AJAX 요청을 보내서 데이터 가져오기
	            fetch("/admin/complaintManage/reportDetail?repan=" + repan)
	                .then(function(response) {
	                    return response.json();
	                })
	                .then(function(data) {
	                    document.getElementById("postTitle").textContent = data.TITLE || "제목 없음";
	                    document.getElementById("postAuthor").textContent = data.AUTHOR || "익명";
	                    document.getElementById("postContent").innerHTML = data.CONTENT || "내용 없음";

	                    //모달의 '삭제버튼'에 data-psnum 속성 동적으로 설정
	                    let deleteButton = document.getElementById("deletePostBtn");
	                    deleteButton.dataset.psnum = repan;
	                    
	                    
	                    //모달 열기
	                    var modal = new bootstrap.Modal(document.getElementById("reportModal"));
	                    modal.show();
	                })
	                .catch(function(error) { 
	                    console.error("Error fetching report details:", error);
	                });
	        });
	    });
	});
	
	document.addEventListener("DOMContentLoaded", function () {
		document.getElementById("deletePostBtn").addEventListener("click", function () {
			let psnum = this.dataset.psnum;
			if(!confirm("정말 이 게시글을 삭제하시겠습니까?")) {
				return;
			}
			
			fetch("/admin/complaintManage/delete?psnum=" + psnum)
				.then(response => response.json())
				.then(data=> {
					alert(data.message);
					
					if(data.success) {
						var modal = document.getElementById("reportModal");
						var modalInstance = bootstrap.Modal.getInstance(modal);
						modalInstance.hide(); // 모달 닫기
						
					}
				})
				.catch(error => {
        			console.error("❌ 게시글 삭제 오류:", error);
        			alert("게시글 삭제 중 오류가 발생했습니다.");
				});
			});
	});
	document.addEventListener("DOMContentLoaded", function () {
		// 상태변경 버튼 클릭 이벤트
		document.querySelectorAll(".status-change-btn").forEach(button => {
			button.addEventListener("click", function () {
				let repan = this.dataset.repan;
				
				
				document.getElementById("hiddenRepan").value = repan;
				
				let statusModal = new bootstrap.Modal(document.getElementById("statusChangeModal"));
				statusModal.show();
			});
		});
		
		document.getElementById("updateStatusBtn").addEventListener("click", function () {
		    let repan = document.getElementById("hiddenRepan").value;
		    let repsucboolean = document.getElementById("statusSelect").value;

		    // ✅ 현재 날짜 및 시간 생성
		    let now = new Date();
			now.setHours(now.getHours() + 9);  // UTC → 한국시간(KST) 변환
			let repsucees = now.toISOString().replace("T", " ").substring(0, 19);


		    fetch("/admin/complaintManage/updateStatus", {
		        method: "POST",
		        headers: {
		            "Content-Type": "application/json"
		        },
		        body: JSON.stringify({ repan: repan, repsucboolean: repsucboolean, repsucees: repsucees })
		    })
		    .then(response => response.json())
		    .then(data => {
		        alert(data.message);

		        if (data.success) {
		            var statusModal = document.getElementById("statusChangeModal");
		            var modalInstance = bootstrap.Modal.getInstance(statusModal);
		            modalInstance.hide();  // ✅ 모달 닫기

		            // ✅ 같은 repan 값을 가진 모든 행을 찾아서 업데이트 (백틱 없이)
		            document.querySelectorAll('[data-repan="' + repan + '"]').forEach(row => {
		                row.closest("tr").querySelector("td:nth-child(6)").textContent = repsucboolean;  // 상태 변경
		                row.closest("tr").querySelector("td:nth-child(5)").textContent = repsucees; // 처리일 변경
		            });

		            console.log("✅ 모든 관련 행 업데이트 완료!");
		        }
		    })
		    .catch(error => {
		        console.error("❌ 상태 변경 오류:", error);
		        alert("상태 변경 중 오류가 발생했습니다.");
		    });
		});

	});
	
	</script>
	<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />

	<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
</body>
</html>