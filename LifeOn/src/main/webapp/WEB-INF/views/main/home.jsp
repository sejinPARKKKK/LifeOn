<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>LifeOn</title>

    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/forms.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/main/styles.css" type="text/css">
    <link rel="stylesheet" href="">

</head>
<body>

<header>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main class="container-home">
    <!-- 메인 배너 섹션 -->
    <div class="main-banner">
        <!-- 왼쪽 큰 배너 -->
        <div class="main-banner-left">
            <!-- 슬라이드 컨테이너 -->
            <div class="slider-container">
                <!-- 슬라이드 1 -->
                <c:forEach var="interior" items="${interior}">
                    <a href="<c:url value='/lounge2/interior/article/${interior.num}?page=1'/>">
                        <div class="slide">
                            <img src="${pageContext.request.contextPath}/uploadPath/lounge1/${interior.thumbnail}"
                                 alt="메인 이미지 1"
                                 class="slide-image">
                            <div class="slide-content">
                                <h2>${interior.subject}</h2>
                                <p class="subtitle">작성자 : ${interior.nickname}</p>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </div>

            <!-- 슬라이드 인디케이터 -->
            <div class="slider-indicators">
                <span class="indicator active" data-index="0"></span>
                <span class="indicator" data-index="1"></span>
                <span class="indicator" data-index="2"></span>
                <span class="indicator" data-index="3"></span>
                <span class="indicator" data-index="4"></span>
            </div>
        </div>

        <!-- 오른쪽 작은 배너 (캐러셀) -->
        <div class="main-banner-right">
            <c:forEach var="event" items="${event}">
                <div class="image-container-right">
                    <img src="${pageContext.request.contextPath}/uploads/event/${event.thumbnail}" alt="이벤트 이미지" class="placeholder-image">
                    <div class="event-overlay">
                        <p class="event-title-text">${event.subject}</p>
                    </div>
                </div>
            </c:forEach>
            <!-- 캐러셀 컨트롤 -->
            <button class="carousel-control left">
                <span class="arrow">&#10094;</span>
            </button>
            <button class="carousel-control right">
                <span class="arrow">&#10095;</span>
            </button>

            <div class="page-indicator">1/3 페이지</div>
            <div class="event-title"></div>
        </div>
    </div>

    <!-- 1인가구 팁 게시판 섹션 -->
    <div class="section">
        <div class="section-header">
            <h2>1인가구 팁 게시판</h2>
            <button class="more-btn" onclick="location.href='<c:url value='/lounge2/tip'/>'">더보기</button>
        </div>

        <div class="product-grid">
            <c:forEach var="tip" items="${tip}">
                <a href="<c:url value='/lounge2/tip/article/${tip.num}?page=1'/>">
                    <div class="product-card">
                        <div class="image-container">
                            <img src="${pageContext.request.contextPath}/uploadPath/tip/${tip.thumbnail}"
                                 alt="${tip.subject}" class="placeholder-image">
                        </div>
                        <div class="product-info">
                            <div class="product-row tip-subject">
                                <span>${tip.subject}</span>
                            </div>
                            <div class="product-row">
                                <span>작성자 : ${tip.nickname}</span>
                                <span>작성일 : ${tip.regDate}</span>
                            </div>
                            <p class="product-description">${tip.content}</p>
                        </div>
                    </div>
                </a>
            </c:forEach>
        </div>
    </div>

    <!-- 마감임박 공동구매상품 섹션 -->
    <div class="section">
        <div class="section-header">
            <h2>마감임박 공동구매상품</h2>
            <button class="more-btn" onclick="location.href='<c:url value='/market/together/main'/>'">더보기</button>
        </div>

        <div class="group-buy-grid">
            <c:forEach var="prizeMain" items="${prizeMain}">
                <div class="group-buy-card">
                    <a href="<c:url value='/market/together/detail?pnum=${prizeMain.num}'/>">
                        <div class="image-container">
                            <img src="${pageContext.request.contextPath}/uploads/product/${prizeMain.thumbnail}"
                                 alt="${prizeMain.subject}" class="placeholder-image">
                        </div>
                        <div class="day-badge">D-${prizeMain.regDate == 0 ? 'Day' : prizeMain.regDate}</div>
                        <div class="product-info-prize">
                            <p>${prizeMain.subject}</p>
                            <p class="discount"><fmt:formatNumber value="${prizeMain.disCountOrRw}"
                                                                  type="currency"/>원</p>
                            <p class="original-price"><fmt:formatNumber value="${prizeMain.price}"
                                                                        type="currency"/>원</p>
                            <span class="remaining-quantity">(${prizeMain.count}개 남음)</span>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- 지역정보 및 추천 지역모임 섹션 -->
    <div class="section local-section">
        <div class="local-info">
            <div class="section-header">
                <h2>지역정보</h2>
                <button class="more-btn" onclick="location.href='<c:url value='/city/area'/>'">더보기</button>
            </div>

            <div class="local-content">
                <h3>지역인기장소 TOP3</h3>
                <ul class="local-list">
                    <li>
                        <span>인기장소 1</span>
                        <span class="info-text">평점 4.8 • 리뷰 120개</span>
                    </li>
                    <li>
                        <span>인기장소 2</span>
                        <span class="info-text">평점 4.7 • 리뷰 98개</span>
                    </li>
                    <li>
                        <span>인기장소 3</span>
                        <span class="info-text">평점 4.6 • 리뷰 85개</span>
                    </li>
                </ul>
            </div>
            <!-- 지역 MBTI 섹션 -->
            <div class="section">
                <div class="section-header">
                    <h2>지역 MBTI</h2>
                </div>

                <div class="local-news">
                    <img src="#" alt="지역 새소식 이미지" class="news-image">
                    <div class="news-content">
                        <h3>여기는 무엇인가?</h3>
                        <p>4월 봄축제 개최합니다</p>
                        <p class="info-text">행사 안내문구</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="local-meetings">
            <div class="section-header">
                <h2>추천 지역모임</h2>
                <button class="more-btn" onclick="location.href='<c:url value='/city/meeting/main'/>'">더보기</button>
            </div>

            <div class="local-content">
                <ul class="meeting-list">
                    <c:forEach var="meeting" items="${regionMeeting}">
                        <li>
                            <a href="<c:url value='/city/meeting/article/${meeting.num}?page=1'/>">
                                <p style="font-size: 18px;">${meeting.subject}</p>
                                <p class="info-text">모임일 ${meeting.regDate} • 참가자 ${meeting.thumbnail}</p>
                                <p>${meeting.nickname}</p>
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </div>


    <!-- 정책정보 섹션 -->
    <div class="section">
        <div class="section-header">
            <h2>정책정보</h2>
            <button class="more-btn" onclick="location.href='<c:url value='/policy/list'/>'">더보기</button>
        </div>

        <div class="regional-info">
            <c:forEach var="policy" items="${policy}" varStatus="status">
                <div class="regional-card" style="position: relative;">
                    <a href="<c:url value='/policy/article/${policy.num}?page=1'/>">
                        <img src="${pageContext.request.contextPath}/dist/images/judgment1.png" alt="정책정보 이미지"
                             class="placeholder-image policy-image">
                        <div class="text-overlay" style="">
                                ${policy.subject}
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>
</main>

<script src="${pageContext.request.contextPath}/dist/main/script.js"></script>

<footer class="mt-auto py-2 text-center w-100" style="left: 0px; bottom: 0px; background: #F7F9FA;">
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>

</html>

