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
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/photo.css" type="text/css">

<style type="text/css">
.photo-card {
 border: 1px solid #E6E6E6;
 padding: 5px;
 text-align: center; 
 border-radius: 10px;
 box-shadow: 0px 1px 5px rgba(0, 0, 0, 0.1);
 height: 100%;
}

.photo-card img {
 width: 100%; 
 height: 250px; 
 object-fit: cover; 
 border-radius: 5px;
 padding: 0;
}
.photo-grid {
 display: grid;
 grid-template-columns: repeat(4, 1fr);
 gap: 20px;
}


.main_menu {
    padding: 0 20px; /* 좌우 20px의 패딩 추가 */
    display: flex; /* 플렉스박스를 사용하여 자식 요소 배치 */
    align-items: center; /* 수직 중앙 정렬 */
    justify-content: space-between; /* 양쪽 끝 정렬 */
    flex-wrap: wrap; /* 자식 요소가 넘칠 경우 줄바꿈 */
}
    
.pull-right {
     float: right; 
}

</style>

</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
	<jsp:include page="/WEB-INF/views/lounge2/layout/menu.jsp"/>
</header>

<main class="min-vh-100">

			<div class="body-title">
				<em style="padding-bottom: 5px; font-size: 30px; font-weight: 800; text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.3);">
					<c:choose>
						<c:when test="${bdtype == 'room'}">인테리어 , 지금 바로 검색해보세요!</c:when>
						<c:when test="${bdtype == 'recipe'}">자취 레시피, 지금 바로 검색해보세요!</c:when>
						<c:otherwise>, 지금 바로 검색해보세요!</c:otherwise>
					</c:choose>
				</em>
				<div style="display: flex; justify-content: center; margin-top: 10px;">
					<div>
						<form name="searchForm" style="display: inline-flex; align-items: center;">
							<select name="schType" class="myselect">
								<option value="all" ${schType=="all"?"selected":""}>제목+내용</option>
								<option value="nickname" ${schType=="nickname"?"selected":""}>작성자</option>
								<option value="reg_date" ${schType=="reg_date"?"selected":""}>등록일</option>
								<option value="subject" ${schType=="subject"?"selected":""}>제목</option>
								<option value="content" ${schType=="content"?"selected":""}>내용</option>
							</select>
							<!-- 검색상자 -->
							<input type="search" name="kwd" value="${kwd}" class="searchBox" placeholder="어떤 정보를 찾고 있나요?">
							<!-- 검색버튼 -->
							<button class="mybtn" style="margin-right: 2px;" onclick="searchList();">검색&nbsp;<i class="bi bi-search"></i></button>
						</form>
					</div>
				</div>
			</div>
			
	<div class="body-container">
	    <div class="main_content">
		      <!-- 상단메뉴 -->
		      <div class="main_menu">
			        <div style="display: flex; justify-content: center; align-items: center; margin-bottom: 8px;" >
			          <p style="margin: 0;">총 게시글 ${dataCount}개 (${page} / ${total_page} 페이지)</p>
			        </div>
			        
			        <div style="display: flex; justify-content: flex-end; align-items: center; margin-bottom: 8px;">
			        </div>
			        <div style=" display: flex; justify-content: flex-end;">
			          <button class="ssbtn" text-align: right onclick="location.href='${pageContext.request.contextPath}/lounge1/${bdtype}/write';">글쓰기&nbsp;
			          <i class="bi bi-pencil"></i></button>
			        </div>
	        	</div>
	        </div>
	    
	    <!-- 글리스트 -->
		<div class="photo-grid">
			<c:forEach var="prize" items="${list}" varStatus="status">
				<div class="photo-card" style="cursor: pointer;" onclick="location.href='${articleUrl}/${prize.psnum}?${query}'">
					<div class="table table-hover m-0">		
						<img class="photo_img" src="${pageContext.request.contextPath}/uploadPath/lounge1/${prize.ssfname}">
						<h5 class="ph_subject">${prize.subject}</h5>
						<div style="display: flex; justify-content: center; align-items: center;">
							<div class="ph-info" style="margin-right: 5px; width: 25px; height: 25px; border-radius: 50%; border: 1px solid #e0e0e0; position: relative; overflow: hidden;">
								<img src="${pageContext.request.contextPath}${prize.profile_image}" class="profileImage" style="width: 100%; height: 100%;" name="profileImage" id="profileImage" alt="프로필">
							</div>
							<span class='ph_userName'>${prize.nickname}</span>
							<span>&nbsp;&nbsp;</span>
							<span>${prize.reg_date}</span>
						</div>
						<div>
							<i class="ph_icon bi bi-bookmark"></i>
							<span>${prize.boardLikeCount}&nbsp;&nbsp;</span>
							<i class="ph_icon bi bi-eye"></i>
							<span>${prize.hitCount}&nbsp;&nbsp;</span>
							<i class="ph_icon bi bi-chat-dots"></i>
							<span>${prize.replyCount}&nbsp;&nbsp;</span>
						</div>
					</div>
					
				</div>
			</c:forEach>
		</div>
	      
	      <div class="page-navigation">
	        ${dataCount == 0 ? "등록된 게시물이 없습니다." : paging}
	      </div>
	      
	    <!-- .main_content -->
		<!-- .col-md-6 -->
		<!-- .row -->
		</div>
</main>

<footer class="mt-auto py-2 text-center w-100" style="background: #F7F9FA;">
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>