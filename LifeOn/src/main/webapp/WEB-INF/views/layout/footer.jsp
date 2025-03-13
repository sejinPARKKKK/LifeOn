<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!-- 로딩 -->
<div id="loadingLayout" style="display:none; position: fixed; left: 0; top:0; width: 100%; min-height: 100%; z-index: 9000; background: rgba(255, 255, 255, 0.8);">
	<div class="loader typing-indicator">
	    <div class="typing-circle"></div>
	    <div class="typing-circle"></div>
	    <div class="typing-circle"></div>
	    <div class="typing-shadow"></div>
	    <div class="typing-shadow"></div>
	    <div class="typing-shadow"></div>
	</div>
</div>

<div class="container" style="display: flex; justify-content: space-between; align-items: center;">
	<div style="width: 250px; text-align: left;">
		<ul class="nav pt-3 px-3">
		    <li class="nav-item" style="font-size: 16px; font-weight: 600;">
		    	<i class="bi bi-headset" style="padding-right: 5px;"></i>
		    	<a class="text-reset" href="<c:url value='/help'/>">고객문의</a>
		    </li>
		</ul>
		<ul class="nav px-3">
		    <li class="nav-item" style="font-size: 12px;">10:00 ~ 18:00 주말&nbsp;&middot;&nbsp;공휴일 제외</li>
		</ul>
		<ul class="nav pb-3 px-3">
		    <li class="nav-item" style="font-size: 12px;">13:00 ~ 14:00 점심시간</li>
		</ul>
    </div>
    
    <div class="justify-content-center">
		<ul class="nav p-3">
		    <li class="nav-item"><a class="text-reset" href="<c:url value='/lifeon/info'/>">회사소개</a></li>
		    <li class="nav-item"><span>&nbsp;&middot;&nbsp;</span></li>
		    <li class="nav-item"><a class="text-reset" href="#">서비스이용약관</a></li>
		    <li class="nav-item"><span>&nbsp;&middot;&nbsp;</span></li>
		    <li class="nav-item"><a class="text-reset" href="#">개인정보취급방침</a></li>
		</ul>
		<ul class="nav pb-3" style="display: inline-block;">
		    <li class="nav-item">&copy; 2025. LifeOn Co.Ltd. All Rights Reserved.</li>
		</ul>
    </div>
    
    <div style="width: 250px; text-align: right;">
    	<img src="${pageContext.request.contextPath}/dist/images/kg.jpg" alt="OpenAPI" style="width: 120px; height: 50px;">
    	<img src="${pageContext.request.contextPath}/dist/images/coolsms.jpg" alt="OpenAPI" style="width: 120px; height: 50px;">
    </div>
</div>