<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<div class="container-fluid p-2">
	<div class="row">
		<div class="col-auto d-lg-none align-self-center">
			<button type="button" id="toggleMenu" class="toggle_menu">
				<i class="bi bi-list"></i>
			</button>
		</div>
		<div class="col align-self-center">
			<img class="fs-4" src="${pageContext.request.contextPath}/dist/images/logo.png" alt="logo" style="padding: 10px; width: 150px; height: 60px; object-fit: cover;">
		</div>
		<div class="col-auto text-end align-self-center ps-3">
			<div style="font-size: 14px;">
				<a href="${pageContext.request.contextPath}/"><i class="bi bi-box-arrow-right" style="font-size: 20px;" title="나가기"></i></a>
			</div>
		</div>
	</div>
</div>