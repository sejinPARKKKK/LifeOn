<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <style>
        .main-container {
            width: 100%;
            max-width: 1820px;
        }

        .resent {
            padding-top: 50px;
            position: fixed;
            top: 160px;
            right: 40px;
            z-index: 1000;
        }

    </style>




    <title>LifeOn</title>

    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>

</head>
<body>

<header>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
    <jsp:include page="/WEB-INF/views/market/layout/menu.jsp"/>
</header>
<main class="d-flex flex-column min-vh-100 align-items-center" style="padding-top: 10px;">
    <div class="main-container">
        <div class="resent">
            <jsp:include page="/WEB-INF/views/layout/rmaket.jsp"/>
        </div>
        <div class="container">
            <jsp:include page="/WEB-INF/views/auction/auction_detail_content.jsp"/>
        </div>
    </div>
</main>


<footer class="mt-auto py-2 text-center w-100" style="left: 0px; bottom: 0px; background: #F7F9FA;">
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>



