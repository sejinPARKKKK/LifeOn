<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>LifeOn</title>

<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp"/>

</head>
<body>

<header class="container-fluid header-top fixed-top px-4">
	<jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
</header>
	
<main>
	<jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>
	<div class="wrapper">
		<div class="container">
	    	<p> 관리자 템플릿 </p>
		</div>
	</div>
</main>

<footer>
	<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp"/>
</body>
</html>