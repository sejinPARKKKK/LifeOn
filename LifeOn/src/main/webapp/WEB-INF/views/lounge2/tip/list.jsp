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

<script type="text/javascript">
function elapsedText(date) {
	const seconds = 1;
	const minute = seconds * 60;
	const hour = minute * 60;
	const day = hour * 24;
	
	var today = new Date();
	var elapsedTime = Math.trunc((today.getTime() - date.getTime()) / 1000);
	
	var elapsedText = "";
	if (elapsedTime < seconds) {
		elapsedText = "방금 전";
	} else if (elapsedTime < minute) {
		elapsedText = elapsedTime + "초 전";
	} else if (elapsedTime < hour) {
		elapsedText = Math.trunc(elapsedTime / minute) + "분 전";
	} else if (elapsedTime < day) {
		elapsedText = Math.trunc(elapsedTime / hour) + "시간 전";
	} else if (elapsedTime < (day * 3)) {
		elapsedText = Math.trunc(elapsedTime / day) + "일 전";
	} else {
		elapsedText = date.getFullYear() + "-" + (date.getMonth() + 1).toString().padStart(2, '0') + "-" + date.getDate().toString().padStart(2, '0');
	}
	
	return elapsedText;
}
</script>
</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
	<jsp:include page="/WEB-INF/views/lounge2/layout/menu.jsp"/>
</header>
	
<main class="min-vh-100">
	<!-- 배너 -->
    <div class="body-title">
    	<em style="padding-bottom: 5px; font-size: 30px; font-weight: 800; text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.3);">생활꿀팁, 지금 바로 검색해보세요!</em>
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
					<input type="search" name=kwd value="${kwd}" class="searchBox" placeholder="어떤 정보을 찾고 있나요?">
					<!-- 검색버튼 -->
			   		<button class="mybtn" style="margin-right: 2px;" onclick="searchList();">검색&nbsp;<i class="bi bi-search"></i></button>
				   	<!-- 새로고침 버튼 -->
					<button type="button" class="ssbtn" style="height: 40px;" onclick="location.href='${pageContext.request.contextPath}/lounge2/tip';" title="새로고침">새로고침&nbsp;<i class="bi bi-arrow-repeat"></i></button>
		   		</form>
			</div>
		</div>
	</div>
	
	
	<div class="body-container">
		<div class="body-content">
			<aside class="sidenav" id="sidenav">
				<div class="leftBox" style="margin-bottom: 10px;">
					<div style="padding: 14px 26px 10px 26px; text-align: left; font-size: 15px; font-weight: 600;">
						즐겨찾기순
					</div>
					
					<table class="table table-hover" style="table-layout: fixed; margin: 0;">
						<c:if test="${empty likeList}">
		              		<tr>
								<td style="padding: 15px 25px; word-wrap: break-word; border-top: 1px solid #e0e0e0;">
									<div style="padding-bottom:3px; text-align: left;">
										즐겨찾기가 된 <br>게시글이 없습니다.😢
									</div>
								</td>
		              		</tr>
						</c:if>
						<c:forEach var="dto" items="${likeList}" varStatus="status">
		              		<c:if test="${status.index < 5}">
			              		<tr>
									<td style="padding: 10px 25px; word-wrap: break-word; border-top: 1px solid #e0e0e0;">
										<div onclick="location.href='<c:url value='${articleUrl}/${dto.psnum}?${query}'/>'" style="padding-bottom:3px; text-align: left; cursor: pointer;">
											${dto.subject}
										</div>
									</td>
			              		</tr>
		              		</c:if>
						</c:forEach>
		            </table>
				</div>
				<div class="leftBox" style="margin-top: 0px;">
					<div style="padding: 14px 26px 10px 26px; text-align: left; font-size: 15px; font-weight: 600;">
						댓글순
					</div>
					
					<table class="table table-hover" style="table-layout: fixed; margin: 0;">
	              		<c:if test="${empty replyList}">
		              		<tr>
								<td style="padding: 15px 25px; word-wrap: break-word; border-top: 1px solid #e0e0e0;">
									<div style="padding-bottom:3px; text-align: left;">
										댓글 있는 <br>게시글이 없습니다.😢
									</div>
								</td>
		              		</tr>
						</c:if>
						<c:forEach var="dto" items="${replyList}" varStatus="status">
		              		<c:if test="${status.index < 5}">
			              		<tr>
									<td style="padding: 10px 25px; word-wrap: break-word; border-top: 1px solid #e0e0e0;">
										<div onclick="location.href='<c:url value='${articleUrl}/${dto.psnum}?${query}'/>'" style="padding-bottom:3px; text-align: left; cursor: pointer;">
											${dto.subject}
										</div>
									</td>
			              		</tr>
							</c:if>
						</c:forEach>
		            </table>
				</div>
			</aside>
			
			<div class="main_content">
				<!-- 상단메뉴 -->
				<div class="main_menu">
				   	<div>
				   		<p style="font-size: 16px; margin: 0;">총 게시글 ${dataCount}개 (${page} / ${total_page} 페이지)</p>
			   		</div>
			   		<div>
						<!-- 글쓰기 버튼 -->
						<button class="ssbtn" onclick="location.href='<c:url value='tip/write'/>'">글쓰기&nbsp;<i class="bi bi-pencil"></i></button>
					</div>
				</div>
				
				<!-- 글리스트 -->
				<div>
					<c:forEach var="dto" items="${list}" varStatus="status">
						<div class="mx-3">
					  		<div onclick="location.href='<c:url value='${articleUrl}/${dto.psnum}?${query}'/>'" style="cursor: pointer;">
								<table class="table table-hover m-0" style="table-layout: fixed;">
									<tbody>
									 	<tr>
									 		<td>
											 	<h4 class="tip_subject">
												 	${dto.subject}
												</h4>
		
											 	<div class="tip_content">
													${dto.content}
										        </div>
										        <div style="display: flex; justify-content: space-between; align-items: center;">
													<div style="display: flex; align-items: center;">
														<div class="profile" style="margin: 5px; width: 25px; height: 25px; border-radius: 50%; border: 1px solid #e0e0e0; position: relative; overflow: hidden;">
															<img src="${pageContext.request.contextPath}${dto.profile_image}" class="profileImage" style="width: 100%; height: 100%;" name="profileImage" id="profileImage" alt="프로필">
														</div>	
														<span class='tip_userName'>${dto.nickname}</span>
														<span>&nbsp;·&nbsp;</span>
													
                                    					<span id="result-${dto.psnum}"></span>
				                                    	<script type="text/javascript">
					                                    	document.addEventListener("DOMContentLoaded", function() {
					                                            const dateStr = "${dto.reg_date}".trim();
					                                            const date = new Date(dateStr);
					                                            const id = "result-${dto.psnum}";
	
					                                        	document.getElementById(id).innerText = elapsedText(date);
					                                    	});
				                                    	</script>
													</div>
													<div>
														<i class="tip_icon bi bi-bookmark"></i>
														<span>${dto.boardLikeCount}&nbsp;&nbsp;</span>
														<i class="tip_icon bi bi-eye"></i>
														<span>${dto.hitCount}&nbsp;&nbsp;</span>
														<i class="tip_icon bi bi-chat-dots"></i>
														<span>${dto.replyCount}&nbsp;&nbsp;</span>
													</div>
												</div>
											</td>
								        </tr>
		
									</tbody>
								</table>
							</div>
						</div>
					</c:forEach>
				</div>

				<div class="page-navigation" style="display: table-footer-group;">
					${dataCount == 0 ? "<p style='margin-bottom: 350px;'>등록된 게시물이 없습니다.</p>" : paging}
				</div>
				
			</div>
			
			<aside class="sidebar" id="sidebar">
				<div class="rightBox">
				
					<div style="padding: 14px 26px 10px 26px; text-align: left; font-size: 15px; font-weight: 600;">
						조회순
					</div>
					
					<table class="table table-hover" style="table-layout: fixed; margin: 0;">
						<c:if test="${empty hitList}">
		              		<tr>
								<td style="padding: 15px 25px; word-wrap: break-word; border-top: 1px solid #e0e0e0;">
									<div style="padding-bottom:3px; text-align: left;">
										조회 된 <br>게시글이 없습니다.😢
									</div>
								</td>
		              		</tr>
						</c:if>
						<c:forEach var="dto" items="${hitList}" varStatus="status">
							<c:if test="${status.index < 10}">
			              		<tr>
									<td style="padding: 10px 25px; word-wrap: break-word; border-top: 1px solid #e0e0e0;">
										<div onclick="location.href='<c:url value='${articleUrl}/${dto.psnum}?${query}'/>'" style="padding-bottom:3px; text-align: left; cursor: pointer;">
											${dto.subject}
										</div>
									</td>
			              		</tr>
		              		</c:if>
						</c:forEach>
		            </table>
				</div>
			   	<!-- 상단이동 버튼 -->
			   	<%-- <button type="button" class="top_btn" onclick="location.href='<c:url value=''/>'">TOP</button> --%>
			</aside>
		</div>
    </div>
</main>

<script type="text/javascript">
/*
$(window).scroll(function() {
	$(".sidebar").css("margin-top",Math.max(-220,0-$(this).scrollTop()));
});
 */
</script>

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
	
	let url = '${pageContext.request.contextPath}/lounge2/tip';
	location.href = url + '?' + requestParams;
}
</script>


<footer class="mt-auto py-2 text-center w-100" style="left: 0px; bottom: 0px; background: #F7F9FA;">
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>