<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/forms.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/photo.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/auction_main.css" type="text/css">
    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
    <style>
        .main-container {
            width: 100%;
            max-width: 1200px;
        }

        .resent {
            padding-top: 50px;
            position: fixed;
            top: 160px;
            right: 40px;
            z-index: 1000;
        }

    </style>
<%--  TODO 전체 마감 진행전 아직 미완성 --%>

    <style>

        .category-text {
            margin-left: 5px;
            margin-right: 20px;
            cursor: pointer;
        }

        .main-category {
            font-size: 18px;
            display: flex;
            list-style: none;
            padding: 5px 10px;
            margin-bottom: 5px;
        }
    </style>


    <title>LifeOn</title>

</head>
<body>

<header>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
    <jsp:include page="/WEB-INF/views/market/layout/menu.jsp"/>
</header>

<main class="d-flex flex-column min-vh-100 align-items-center" style="padding-top: 30px;">
    <div class="main-container">
        <div class="resent">
            <jsp:include page="/WEB-INF/views/layout/rmaket.jsp"/>
        </div>

        <div class="auction-header">
            <h2 class="auction-title">경매장</h2>
        </div>

        <div class="category-container">
            <c:if test="${category.categoryType != 'all'}">
                <div class="category-header">
                    <span class="category-back" onClick="toggleAllCategory()">
                        <i class="fas fa-arrow-left"></i> ${category.categoryBigName}
                    </span>
                </div>
            </c:if>

            <ul class="main-category">
                <c:if test="${category.categoryType eq 'all'}">
                    <c:forEach var="category" items="${category.categoryList}">
                        <li class="category-text"
                            onclick="toggleBigCategory(${category.cbn},'big','${category.cbc}','${category.cbc}')">${category.cbc}</li>
                    </c:forEach>
                </c:if>
                <c:if test="${category.categoryType eq 'big' || category.categoryType eq 'small'}">
                    <li class="category-text ${param.categoryName eq '전체' || param.categoryType eq 'big' ? 'active' : ''}"
                        onclick="toggleSmallCategory(${category.cbn},'big','${category.categoryBigName}','전체')">전체</li>
                    <c:forEach var="categoryBig" items="${category.categoryList}">
                        <li class="category-text ${category.categoryType eq 'small' && (categoryBig.csc eq param.categoryName || param.categoryName eq '전체') ? 'active' : ''}"
                            onclick="toggleSmallCategory(${category.cbn},'small','${category.categoryBigName}','${categoryBig.csc}')">${categoryBig.csc}</li>
                    </c:forEach>
                </c:if>
            </ul>
        </div>

        <div id="auction-main-prize">
            <jsp:include page="/WEB-INF/views/auction/auction_main_prize.jsp"/>
        </div>

        <div class="page-navigation">
            ${dataCount == 0 ? "등록된 게시물이 없습니다." : paging}
        </div>
    </div>
</main>

<footer class="mt-auto py-2 text-center w-100" style="left: 0px; bottom: 0px; background: #F7F9FA;">
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>

<script>
    function toggleAllCategory() {
        let url = `${pageContext.request.contextPath}/auction`;
        location.href = url;
    }

    function toggleBigCategory(cbn, categoryType, BCategoryName, categoryName,) {
        let url = `${pageContext.request.contextPath}/auction`;
        let rCategoryType = encodeURIComponent(categoryType);
        let rCategoryName = encodeURIComponent(categoryName);
        let searchType = '';
        let searchTerm = '';
        let page = 1;
        location.href = url + '/category?cbn=' + cbn + '&categoryType=' + rCategoryType + '&categoryName=' + rCategoryName + '&searchType=' + searchType + '&searchTerm=' + searchTerm + '&page=' + page;
    }

    function toggleSmallCategory(cbn, categoryType, BCategoryName, categoryName,) {
        let url = `${pageContext.request.contextPath}/auction`;
        let rCategoryType = encodeURIComponent(categoryType);
        let rCategoryName = encodeURIComponent(categoryName);
        let searchType = '';
        let searchTerm = '';
        let page = 1;
        let BigCategoryName = encodeURIComponent(BCategoryName);
        location.href = url + '/category?cbn=' + cbn + '&categoryType=' + rCategoryType + '&categoryBName=' + BigCategoryName + '&categoryName=' + rCategoryName + '&searchType=' + searchType + '&searchTerm=' + searchTerm + '&page=' + page;
    }
</script>
</body>
</html>



