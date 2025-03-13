<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>LifeOn</title>

<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />

<style type="text/css">
.boardlist {
	display: flex;
	justify-content: left;
	align-items: center;
	border: 1px solid black;
	height: 600px;
}

.body-middle {
	display: flex;
	justify-content: space-between;
	align-items: center;
	width: 100%;
}

.left-list, .chat-wrap {
	width: 50%;
	height: 500px;
	margin: 1px;
	text-align: center;
	border: 1px solid #e6e6e6;
	background-color: #e6e6e6;
	overflow-y: scroll; /* 세로 스크롤바 추가 */
	overflow-x: hidden; /* 가로 스크롤 방지 */
}

/* 크롬, 엣지, 사파리 스크롤바 스타일 조정 */
.left-list::-webkit-scrollbar, .chat-wrap::-webkit-scrollbar {
	width: 10px; /* 세로 스크롤바 너비 */
}

/* 스크롤바 위아래 화살표 제거 */
.left-list::-webkit-scrollbar-button, .chat-wrap::-webkit-scrollbar-button
	{
	display: none; /* 위아래 버튼 숨김 */
}

/* 스크롤바 트랙 (배경) */
.left-list::-webkit-scrollbar-track, .chat-wrap::-webkit-scrollbar-track
	{
	background: #888;
}

/* 스크롤바 핸들 (드래그하는 부분) */
.left-list::-webkit-scrollbar-thumb, .chat-wrap::-webkit-scrollbar-thumb
	{
	background: #aaa;
}

.inquire-item {
	display: flex;
	align-items: center;
	justify-content: space-between;
}

.profile-img {
	width: 50px;
	height: 50px;
	border-radius: 50%;
}

.answer button {
	padding: 3px;
	border: 1px solid #007bff;
	background-color: #007bff;
	color: white;
	border-radius: 10%;
}

.menu-button {
	border-radius: 50%;
}


.chat-wrap .header {
	padding: 15px;
}


.header {
	display: flex;
	align-items : center;
	justify-content: center;
}

.date{
	flex: 1;
	font-weight: bold;
}

.menu-btn{
	 width: 30px;
	 height: 30px;
	 border: none;
	 border-radius: 50%;
	 background-color: #007bff; 
	 display: flex;
	 align-items: center;
	 justify-content: center;
}

.menu-btn i {
	color : white;
	font-size : 18px;
}

.menu-options{
	display : none;
	flex-direction : column;
	position: absolute;
	right : 10px;
	top : 50px;
	
}

.menu-options button {
	display : block;
	padding : 5px;
	border : none;
}

.menu-options button:hover {
	background-color: #007bff;
	color : white;
}

.menu-options.active {
	display: flex;
}

.chat-wrap {
	display: flex;
	flex-direction: column;
    position: relative;
}

.chat-body{
	flex: 1;
}


.input-div>textarea {
	width: 100%;
	height: 50px;
}

.format {
	display: none;
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
						<i class="bi bi-app"></i> 고객문의
					</h3>
				</div>

				<div class="body-head">
					<div class="body-nav">
						<button class="btn BtnA">전체</button>
						<button class="btn BtnA">답변중</button>
						<button class="btn BtnA">답변대기</button>
						<button class="btn BtnA">답변완료</button>
					</div>
				</div>

				<div class="body-middle">
					<div class="left-list">
						<div class="inquire-item">
							<div class="image">
								<img alt="프로필사진" src="#" style="width: 50px; height: 50px;">
							</div>
							<div class="nicname">
								<h3>커피</h3>
								<p>문의합니다.</p>
							</div>
							<div class="time">
								<p>01-11</p>
							</div>
							<div class="answer">
								<button>답변완료</button>
							</div>
						</div>

						<div class="inquire-item">
							<div class="image">
								<img alt="프로필사진" src="#" class="profile-img">
							</div>
							<div class="nicname">
								<h3>커피</h3>
								<p>문의합니다.</p>
							</div>
							<div class="time">
								<p>01-11</p>
							</div>
							<div class="answer">
								<button>답변완료</button>
							</div>
						</div>
					</div>
					<div class="chat-wrap">
						<div class="header">
							<span class="date">2025-01-23</span>
							<button class="menu-btn" onclick="openToggle();">
								<i class="bi bi-gear"></i>
							</button>
							
							<!-- 메뉴 옵션(기본적으로 숨김) -->
							<div class="menu-options">
								<button class="reply-btn">답변대기</button>
								<button class="complate-btn">답변완료</button>
							</div>
						</div>
						<div class="chat-body">
							<ul>
								<!-- 동적 생성 -->
							</ul>
						</div>
						<div class="input-div">
							<textarea placeholder="Press Enter for send message."></textarea>
						</div>
						<!--  format -->
						<div class="chat format">
							<ul>
								<li>
									<div class="sender">
										<span></span>
									</div>
									<div class="message">
										<span></span>
									</div>
								</li>
							</ul>
						</div>
					</div>

				</div>

			</div>
		</div>
	</main>
	<script type="text/javascript">
	document.addEventListener("DOMContentLoaded", function () {
		const buttons = document.querySelectorAll(".body-nav .btn");
		const defaultBtn = document.querySelector(".BtnA");
		
		if(defaultBtn) {
			defaultBtn.classList.add("active");
			defaultBtn.style.borderColor = "white";
			defaultBtn.style.color = "#006AFF";
		}
		
		buttons.forEach((button) => {
			button.addEventListener("click", function() {
				buttons.forEach(btn => {
					btn.classList.remove("active");
					btn.style.borderColor = "white";
					btn.style.color = "black";
				});
				
				this.classList.add("active");
				this.style.borderColor = "white";
				this.style.color = "#006AFF";
			});
		});
	});
	
	function openToggle() {	
		document.querySelector(".menu-options").classList.toggle("active");
	}
	
	document.addEventListener("click", (e) => {
		if(!e.target.closest(".menu-btn, .menu-options")) {
			document.querySelector(".menu-options").classList.remove("active");
		}
	});

	
	</script>

	<footer>
		<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
	</footer>

	<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
</body>
</html>