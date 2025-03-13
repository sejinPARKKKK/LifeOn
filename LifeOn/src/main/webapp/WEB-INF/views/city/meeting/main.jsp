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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/meeting.css" type="text/css">

</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
	<jsp:include page="/WEB-INF/views/city/layout/menu.jsp"/>
</header>

  <main class="min-vh-100">
 
   <div class="search-bar">
          <input id="search-bar-input" class="search-content" type="text" placeholder="원하는 모임을 찾아보세요!"/>
          <span class="icon icon-search" ><i class="bi bi-search" style="font-size: 16px; padding-top: 3px;"></i></span>
        </div>
		
		<!-- 카테고리 -->
        <div class="category-container">
          <nav class="category-nav">
            <ul>
			    <li class="category-subcontainer">
			        <a class="category ${empty param.cbn ? 'selected' : ''}" href="<c:url value='/city/meeting/main'/>">전체</a>
			    </li>
    
		    <c:forEach var="main" items="${listCategory}">
		        <li class="category-subcontainer">
		            <a class="category ${param.cbn eq main.cbn ? 'selected' : ''}" href="<c:url value='/city/meeting/main?cbn=${main.cbn}'/>">${main.cbc}</a>
		        </li>
   			</c:forEach>
		</ul>
	</nav>
</div>

        <div class="meeting__options">
          <div class="region-category">
            <label for="category"></label>
            <div class="select-box select-box--input select-box--round">
              <select id="select-box__options" class="dropdown">
              	<option>지역 선택</option>
                <option>금천구</option>
                <option>관악구</option>
                <option>구로구</option>
                <option>강서구</option>
                <option>강북구</option>
                <option>강남구</option>
                <option>강동구</option>
                <option>광진구</option>
                <option>노원구</option>
                <option>도봉구</option>
                <option>동작구</option>
                <option>동대문구</option>
                <option>마포구</option>
                <option>서초구</option>
                <option>송파구</option>
                <option>성동구</option>
                <option>성북구</option>
                <option>서대문구</option>
                <option>양천구</option>
                <option>영등포구</option>
                <option>용산구</option>
                <option>종로구</option>
                <option>중구</option>
                <option>중랑구</option>
            </select>
            </div>
          </div>
          <div class="meeting-activate-option">
            <span>모집완료 제외</span>
            <input type="checkbox" id="toggle" checked hidden="hidden" />
            <label for="toggle" class="toggle-switch">
              <span class="toggle-button"></span>
            </label>
          </div>
        </div>
     
      
      	<div style="display: flex; justify-content: flex-end; margin: 10px auto 10px; max-width: 1280px;">
          <button class="btn" onclick="location.href='${pageContext.request.contextPath}/city/meeting/write';">글쓰기</button>
        </div>
	<div>
      <section class="main__content">
       	 <c:forEach var="dto" items="${list}">
        	<div class="meetings">
  
              <div onclick="location.href='<c:url value='${articleUrl}/${dto.psnum}?${query}'/>'" style="cursor: pointer;">
              <div class="meeting__header">
                <div class="meeting__info-detail-more">
                  <span class="meeting__category">${dto.cbc}</span>
                  <span class="meeting__location"><i class="bi bi-geo-alt"></i>${dto.loca}</span>
                  <span class="meeting__date"><i class="bi bi-calendar-check"></i>&nbsp;${dto.mdate}</span>
      				
                </div>
                </div>
              </div>
              <div>
                <h5 class="meeting__title">${dto.subject}</h5>
              </div>
              <div class="meeting_infos">
              	<span class="meeting__category">#${dto.age}</span>
              	<span class="meeting__category">#${dto.gender}</span>
              	<span class="meeting__category">#${dto.person_c}</span>
             
              
              <div style="display: flex; justify-content: space-between; align-items: left;">
				 <div class="status-box" style="font-size: 10px; font-weight: bold;">
				    <div class="meeting__status ${dto.ies eq '모집완료' ? 'meeting__status--off' : 'meeting__status--on'}">
				       	${dto.ies}
				    </div>
				</div>
				
                  <div style="margin-top: 5px">
						<i class="tip_icon bi bi-bookmark"></i>
						<span>${dto.boardLikeCount}&nbsp;&nbsp;</span>
						<i class="tip_icon bi bi-eye"></i>
						<span>${dto.hitCount}&nbsp;&nbsp;</span>
						<i class="tip_icon bi bi-chat-dots"></i>
						<span>${dto.replyCount}&nbsp;&nbsp;</span>
                  </div>
                  </div>
                  </div>
                  </div>
          		</c:forEach>
      </section>
                 <div class="page-navigation" style="margin-block: auto;">
					${dataCount == 0 ? "등록된 모임모집이 없습니다.." : paging}
				</div>
   </div>
                  

    </main>
    
<script type="text/javascript">
document.querySelectorAll('.category').forEach(function(category) {
	category.addEventListener('click', function() {
	
	document.querySelectorAll('.category').forEach(function(c) {
	      c.classList.remove('selected');
	    });

	    // 클릭한 카테고리에 selected 클래스 추가
	    category.classList.add('selected');
	});
});
</script>

<footer class="mt-auto py-2 text-center w-100" style="background: #F7F9FA;">
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>