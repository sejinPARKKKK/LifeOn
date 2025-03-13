<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="icon" href="data:;base64,iVBORw0KGgo=">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>LifeOn</title>

    <%-- TODO 진행전, 중, 성공 ,실패 미완 --%>

    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/menu3.css" type="text/css">
    <!-- <script type="text/javascript" src="${pageContext.request.contextPath}/dist/js/menu2.js"></script> -->
    <style>
        * {
            padding: 0;
            margin: 0;
        }

        p {
            margin: 0;
            padding: 0;
        }


        .btn-seller {
            width: 300px;
            padding: 0;

        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        .table th, .table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }

        .table th {
            background-color: #f4f4f4;
        }

        .btn {
            padding: 5px 10px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
        }


        .wrapper {
            display: flex;
            padding: 20px 20px 20px 350px;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 8px;
        }

        .table th, .table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }

        .table td {
            border: 1px solid #ddd;
            padding: 5px 0 5px 0;
            text-align: center;
        }

        .table th {
            background-color: #f4f4f4;
        }

        .btn {
            padding: 5px 10px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
        }

        .btn-edit {
            background-color: #007bff;
            color: white;
        }

        .btn-delete {
            background-color: #dc3545;
            color: white;
        }

        .btn-order {

            background-color: #28a745;
            color: white;
        }

        .status-tabs {
            display: flex;
            gap: 15px;
            font-size: 18px;
            font-weight: bold;
        }

        .status-tabs a {
            text-decoration: none;
            color: black;
            padding: 5px 10px;
            border-radius: 5px;
        }

        .status-tabs a.active {
            background-color: #007bff;
            color: white;
        }

        h2 {
            font-size: 24px;
            margin-bottom: 15px;
        }

        .search-date {
            width: 100px;
            border: 1px solid rgba(184, 184, 184, 0.59);
            border-radius: 8px;

        }

        .search-date-btn {
            border: 0;
            width: 80px;
            height: 30px;
            border-radius: 8px;
            background: #b8b6b6;
            color: white;
            font-size: 13px;
            font-weight: 100;
        }

        .container-seller {
            width: 1300px;
        }

        .search-date::placeholder {
            color: #c8c8c8;
        }

        .sell-select-box {
            border: 0;
            border-radius: 8px;
            width: 100px;
            height: 30px;
            background: #e6e6e6
        }

        .registration-btn {
            background: rgba(29, 35, 39, 0.38);
            margin-left: 10px;
        }

        .sell-btn {
            display: flex;
            padding: 30px 0 30px 0;
            gap: 10px;
            align-items: center;

        }





        /* 대시보드 요약 섹션 스타일 */
        .dashboard-summary {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
            gap: 20px;
        }

        .summary-card {
            flex: 1;
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            display: flex;
            align-items: center;
            transition: transform 0.3s ease;
        }

        .summary-card:hover {
            transform: translateY(-5px);
        }

        .summary-icon {
            background: #f8f9fa;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 24px;
            color: #007bff;
        }

        .summary-content h3 {
            font-size: 16px;
            margin-bottom: 5px;
            color: #6c757d;
        }

        .summary-count {
            font-size: 24px;
            font-weight: bold;
            color: #343a40;
        }

        /* 상태 필터 스타일 */
        .status-filter {
            display: flex;
            gap: 10px;
            margin: 20px 0;
        }

        .status-btn {
            padding: 8px 15px;
            border: 1px solid #ddd;
            border-radius: 20px;
            background: white;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .status-btn.active {
            background: #007bff;
            color: white;
            border-color: #007bff;
        }

        /* 테이블 스타일 개선 */
        .table {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        .table th {
            background-color: #f8f9fa;
            font-weight: 600;
            padding: 15px 10px;
        }

        .table td {
            padding: 15px 10px;
            vertical-align: middle;
        }

        .table tr:hover {
            background-color: #f8f9fa;
        }

        /* 상태 셀 스타일 */
        .status-cell {
            font-weight: 600;
            border-radius: 5px;
            padding: 5px 10px !important;
        }

        .status-active {
            background-color: rgba(40, 167, 69, 0.1);
            color: #28a745;
        }

        .status-completed {
            background-color: rgba(0, 123, 255, 0.1);
            color: #007bff;
        }

        .status-failed {
            background-color: rgba(220, 53, 69, 0.1);
            color: #dc3545;
        }

        .status-pending {
            background-color: rgba(255, 193, 7, 0.1);
            color: #ffc107;
        }

        /* 상품 정보 스타일 */
        .product-link {
            display: flex;
            align-items: center;
            text-decoration: none;
            color: inherit;
        }

        .product-image {
            margin-right: 15px;
        }

        .product-image img {
            border-radius: 5px;
            object-fit: cover;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .product-info {
            text-align: left;
        }

        .product-name {
            font-weight: 600;
            margin-bottom: 5px;
            color: #343a40;
        }

        .product-price, .product-final-price {
            font-size: 14px;
            color: #6c757d;
        }

        /* 버튼 스타일 개선 */
        .btn {
            padding: 8px 15px;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .btn-order {
            background-color: #007bff;
            color: white;
        }

        .btn-edit {
            background-color: #28a745;
            color: white;
        }

        .btn-delete {
            background-color: #dc3545;
            color: white;
        }

        .registration-btn {
            background: #343a40;
            color: white;
            padding: 10px 20px;
            font-weight: 500;
        }

        /* 데이터 없음 스타일 */
        .no-data {
            text-align: center;
            padding: 50px 0;
            background: #f8f9fa;
            border-radius: 10px;
            margin: 20px 0;
        }

        .no-data-icon {
            font-size: 50px;
            color: #6c757d;
            margin-bottom: 20px;
        }

        .no-data p {
            font-size: 18px;
            color: #6c757d;
            margin-bottom: 20px;
        }

        /* 페이지네이션 스타일 */
        .page-navigation {
            margin-top: 30px;
            text-align: center;
        }



    </style>

    <script !src="">
        function dateSearch() {
            location.href = "${pageContext.request.contextPath}/mypage/seller/info?stDate=" + $(".search-date:eq(0)").val() + "&edDate=" + $(".search-date:eq(1)").val();
        }
    </script>

</head>
<body>

<header>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<%--

<main class="wrapper">
    <jsp:include page="/WEB-INF/views/mypage/left.jsp"/>
    <div class="container-seller">
        <h2>경매 상품목록</h2>
        <div class="d-flex flex-column align-items-start w-100">
            <div>
                <p style="font-size: 30px; font-weight: 500;">판매내역</p>
            </div>
        </div>
        <div class="d-flex justify-content-between align-items-center w-100">
            <label style="padding-top: 10px; font-size: 13px;">
                <div>
                    등록일 기반 검색
                </div>
                <input class="search-date" type="date" value="${stDate}"> ~
                <input class="search-date" type="date" value="${edDate}">
                <button class="search-date-btn" onclick="dateSearch()">기간적용</button>
            </label>
            <div class="d-flex">
                <button type="button" class="btn registration-btn"
                        onclick="location.href='<c:url value='/mypage/seller/registration'/>'">상품 등록
                </button>
            </div>
        </div>

        <table class="table">
            <thead>
            <tr>
                <th>번호</th>
                <th>경매 상태</th>
                <th>경매기간</th>
                <th>상품</th>
                <th>등록일</th>
                <th>판매방법</th>
                <th>비고</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="prize" items="${prizeList}" varStatus="status">
                <tr>
                    <td>${dataCount - (page-1) * size - status.index}</td>
                    <td>[${prize.prStatus}]</td>
                    <td class="date-check" data-st="${prize.stDate}" data-ed="${prize.edDate}">
                        시작일 : ${prize.stDate}<br>
                        종료일 : ${prize.edDate}<br><br>
                        <p id="date-time">

                        </p>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/auction/prizeDetail?pnum=${prize.pnum}">
                            <img src="${pageContext.request.contextPath}/uploads/seller/${prize.thumbnail}" alt="상품 이미지"
                                 width="50">
                            <br>${prize.prName}
                            <br>현재가 : <fmt:formatNumber value="${prize.price}" type="currency"/>
                            <br>낙찰가 : <fmt:formatNumber value="${prize.finalP}" type="currency"/>
                        </a>
                    </td>
                    <td>${prize.upToDate}</td>
                    <td>${prize.tradeType}</td>
                    <td class="btn-seller">
                        <div class="sell-btn">
                            <c:if test="${prize.prStatus eq '진행중'}">
                                <span style="padding-left: 10px;"></span>
                            </c:if>
                            <c:if test="${prize.prStatus ne '진행중'}">
                                <span style="padding-left: 20px;"></span>
                            </c:if>
                            <button class="btn btn-order"
                                    onclick="location.href='${pageContext.request.contextPath}/mypage/seller/seller-update?pnum=${prize.pnum}'">
                                수정하기
                            </button>
                            <c:if test="${prize.prStatus eq '마감'}">
                                <button class="btn btn-edit">판매완료</button>
                            </c:if>
                            <c:if test="${prize.prStatus eq '마감' || prize.prStatus eq '경매 실패'}">
                                <button class="btn btn-delete" onClick="deletePrize(${prize.pnum})">삭제 ❌</button>
                            </c:if>
                            <c:if test="${prize.prStatus eq '진행중'}">
                                <button class="btn btn-edit"
                                        onclick="if(confirm('진짜 낙찰처리 하시겠습니까?')) location.href='${pageContext.request.contextPath}/mypage/seller/bidding?pnum=${prize.pnum}'">
                                    낙찰처리
                                </button>
                            </c:if>
                            <c:if test="${prize.prStatus eq '진행중' || prize.prStatus eq '진행전'}">
                                <button class="btn btn-delete"
                                        onclick="if(confirm('진짜 경매를 취소 하시겠습니까?')) location.href='${pageContext.request.contextPath}/mypage/seller/seller-delete?pnum=${prize.pnum}'">
                                    경매취소
                                </button>
                            </c:if>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <div class="page-navigation">
            ${dataCount == 0 ? "상품목록이 없습니다." : paging}
        </div>
    </div>
</main>

--%>

<main class="wrapper">
    <jsp:include page="/WEB-INF/views/mypage/left.jsp"/>
    <div class="container-seller">
        <!-- 대시보드 요약 섹션 추가 -->
        <div class="dashboard-summary">
            <div class="summary-card">
                <div class="summary-icon">
                    <i class="fas fa-gavel"></i>
                </div>
                <div class="summary-content">
                    <h3>진행중인 경매</h3>
                    <p class="summary-count">${activeAuctionCount != null ? activeAuctionCount : 0}</p>
                </div>
            </div>
            <div class="summary-card">
                <div class="summary-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="summary-content">
                    <h3>완료된 경매</h3>
                    <p class="summary-count">${completedAuctionCount != null ? completedAuctionCount : 0}</p>
                </div>
            </div>
            <div class="summary-card">
                <div class="summary-icon">
                    <i class="fas fa-coins"></i>
                </div>
                <div class="summary-content">
                    <h3>총 판매액</h3>
                    <p class="summary-count"><fmt:formatNumber value="${totalSales != null ? totalSales : 0}" type="currency"/></p>
                </div>
            </div>
            <div class="summary-card">
                <div class="summary-icon">
                    <i class="fas fa-star"></i>
                </div>
                <div class="summary-content">
                    <h3>판매자 평점</h3>
                    <p class="summary-count">${sellerRating != null ? sellerRating : '0.0'} / 5.0</p>
                </div>
            </div>
        </div>

        <h2>경매 상품목록</h2>
        <div class="d-flex flex-column align-items-start w-100">
            <div>
                <p style="font-size: 30px; font-weight: 500;">판매내역</p>
            </div>
        </div>
        <div class="d-flex justify-content-between align-items-center w-100">
            <label style="padding-top: 10px; font-size: 13px;">
                <div>
                    등록일 기반 검색
                </div>
                <input class="search-date" type="date" value="${stDate}"> ~
                <input class="search-date" type="date" value="${edDate}">
                <button class="search-date-btn" onclick="dateSearch()">기간적용</button>
            </label>
            <div class="d-flex">
                <button type="button" class="btn registration-btn"
                        onclick="location.href='<c:url value='/mypage/seller/registration'/>'">상품 등록
                </button>
            </div>
        </div>

        <!-- 상태 필터 추가 -->
        <div class="status-filter">
            <button class="status-btn active" data-status="all">전체</button>
            <button class="status-btn" data-status="진행전">진행전</button>
            <button class="status-btn" data-status="진행중">진행중</button>
            <button class="status-btn" data-status="마감">마감</button>
            <button class="status-btn" data-status="경매 실패">경매 실패</button>
        </div>

        <table class="table">
            <thead>
            <tr>
                <th>번호</th>
                <th>경매 상태</th>
                <th>경매기간</th>
                <th>상품</th>
                <th>등록일</th>
                <th>판매방법</th>
                <th>비고</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="prize" items="${prizeList}" varStatus="status">
                <tr class="auction-row" data-status="${prize.prStatus}">
                    <td>${dataCount - (page-1) * size - status.index}</td>
                    <td class="status-cell ${prize.prStatus eq '진행중' ? 'status-active' : prize.prStatus eq '마감' ? 'status-completed' : prize.prStatus eq '경매 실패' ? 'status-failed' : 'status-pending'}">[${prize.prStatus}]</td>
                    <td class="date-check" data-st="${prize.stDate}" data-ed="${prize.edDate}">
                        시작일 : ${prize.stDate}<br>
                        종료일 : ${prize.edDate}<br><br>
                        <p id="date-time">

                        </p>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/auction/prizeDetail?pnum=${prize.pnum}" class="product-link">
                            <div class="product-image">
                                <img src="${pageContext.request.contextPath}/uploads/seller/${prize.thumbnail}" alt="상품 이미지"
                                     width="80">
                            </div>
                            <div class="product-info">
                                <p class="product-name">${prize.prName}</p>
                                <p class="product-price">현재가 : <fmt:formatNumber value="${prize.price}" type="currency"/></p>
                                <p class="product-final-price">낙찰가 : <fmt:formatNumber value="${prize.finalP}" type="currency"/></p>
                            </div>
                        </a>
                    </td>
                    <td>${prize.upToDate}</td>
                    <td>${prize.tradeType}</td>
                    <td class="btn-seller">
                        <div class="sell-btn">
                            <c:if test="${prize.prStatus eq '진행중'}">
                                <span style="padding-left: 10px;"></span>
                            </c:if>
                            <c:if test="${prize.prStatus ne '진행중'}">
                                <span style="padding-left: 20px;"></span>
                            </c:if>
                            <button class="btn btn-order"
                                    onclick="location.href='${pageContext.request.contextPath}/mypage/seller/seller-update?pnum=${prize.pnum}'">
                                수정하기
                            </button>
                            <c:if test="${prize.prStatus eq '마감'}">
                                <button class="btn btn-edit">판매완료</button>
                            </c:if>
                            <c:if test="${prize.prStatus eq '마감' || prize.prStatus eq '경매 실패'}">
                                <button class="btn btn-delete" onClick="deletePrize(${prize.pnum})">삭제 ❌</button>
                            </c:if>
                            <c:if test="${prize.prStatus eq '진행중'}">
                                <button class="btn btn-edit"
                                        onclick="if(confirm('진짜 낙찰처리 하시겠습니까?')) location.href='${pageContext.request.contextPath}/mypage/seller/bidding?pnum=${prize.pnum}'">
                                    낙찰처리
                                </button>
                            </c:if>
                            <c:if test="${prize.prStatus eq '진행중' || prize.prStatus eq '진행전'}">
                                <button class="btn btn-delete"
                                        onclick="if(confirm('진짜 경매를 취소 하시겠습니까?')) location.href='${pageContext.request.contextPath}/mypage/seller/seller-delete?pnum=${prize.pnum}'">
                                    경매취소
                                </button>
                            </c:if>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <!-- 데이터가 없을 때 표시할 메시지 -->
        <c:if test="${empty prizeList}">
            <div class="no-data">
                <div class="no-data-icon">
                    <i class="fas fa-box-open"></i>
                </div>
                <p>등록된 상품이 없습니다.</p>
                <button type="button" class="btn registration-btn"
                        onclick="location.href='<c:url value='/mypage/seller/registration'/>'">상품 등록하기
                </button>
            </div>
        </c:if>

        <div class="page-navigation">
            ${dataCount == 0 ? "상품목록이 없습니다." : paging}
        </div>
    </div>
</main>



<script type="text/javascript">

    function deletePrize(pnum) {
        location.href = '${pageContext.request.contextPath}/mypage/seller/seller-delete?pnum=' + pnum;
    }


    $(function () {
        $('.date-check').each(function (index, element) {
            let stDate = $(element).data('st');
            let edDate = $(element).data('ed');
            let now = new Date();
            let austDay = new Date(stDate);
            let stRemainingTime = new Date(stDate) - now;
            let edRemainingTime = new Date(edDate) - now;

            if (stRemainingTime > 0) {
                $(element).find('#date-time').countdown({
                    until: austDay,
                    format: 'dHMS',
                    layout: '<span class="time-content">오픈시간</span> <br>' +
                        '<span class="time">{dn}일 {hn}시간 {mn}분 {sn}초</span>'
                });
            } else if (edRemainingTime > 0) {
                austDay = new Date(edDate);
                $(element).find('#date-time').countdown({
                    until: austDay,
                    format: 'dHMS',
                    layout: '<span class="time-content">마감시간</span> <br>' +
                        '<span class="time">{dn}일 {hn}시간 {mn}분 {sn}초</span>'
                });
            }
        });
    });



    function deletePrize(pnum) {
        location.href = '${pageContext.request.contextPath}/mypage/seller/seller-delete?pnum=' + pnum;
    }

    $(function () {
        // 기존 카운트다운 코드
        $('.date-check').each(function (index, element) {
            let stDate = $(element).data('st');
            let edDate = $(element).data('ed');
            let now = new Date();
            let austDay = new Date(stDate);
            let stRemainingTime = new Date(stDate) - now;
            let edRemainingTime = new Date(edDate) - now;

            if (stRemainingTime > 0) {
                $(element).find('#date-time').countdown({
                    until: austDay,
                    format: 'dHMS',
                    layout: '<span class="time-content">오픈시간</span> <br>' +
                        '<span class="time">{dn}일 {hn}시간 {mn}분 {sn}초</span>'
                });
            } else if (edRemainingTime > 0) {
                austDay = new Date(edDate);
                $(element).find('#date-time').countdown({
                    until: austDay,
                    format: 'dHMS',
                    layout: '<span class="time-content">마감시간</span> <br>' +
                        '<span class="time">{dn}일 {hn}시간 {mn}분 {sn}초</span>'
                });
            }
        });

        // 상태 필터 기능
        $('.status-btn').click(function() {
            $('.status-btn').removeClass('active');
            $(this).addClass('active');

            const status = $(this).data('status');

            if (status === 'all') {
                $('.auction-row').show();
            } else {
                $('.auction-row').hide();
                $('.auction-row[data-status="' + status + '"]').show();
            }
        });

        // 행 호버 효과
        $('.table tr').hover(
            function() {
                $(this).addClass('hover');
            },
            function() {
                $(this).removeClass('hover');
            }
        );
    });


</script>



<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>