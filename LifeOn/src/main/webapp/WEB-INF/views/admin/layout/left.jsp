<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
// 메뉴 활성화 및 서브메뉴 토글
$(function(){
    var url = window.location.pathname;
    var urlRegExp = new RegExp(url.replace(/\/$/, '') + "$", 'i');

    try {
        $('nav ul>li>a').each(function() {
            if (urlRegExp.test(this.href.replace(/\/$/, ''))) {
                $(this).addClass('active_menu');
                $(this).closest('.menu--item').find('.submenu').slideDown();
                return false;
            }
        });
        
        // 서브메뉴 토글
        $('.has-submenu > a').on('click', function(e) {
            e.preventDefault();
            $(this).siblings('.submenu').slideToggle();
            $(this).toggleClass('open');
        });
    } catch(e) {}
});
</script>

<style>
    .submenu {
        display: none;
        padding-left: 0;
        text-align: center;
    }
    .submenu li {
        list-style: none;
        margin: 5px 0;
    }
    .menu--item.has-submenu {
        text-align: center;
    }
</style>

<nav class="vertical_nav">
	<ul id="js-menu" class="menu">
		<li class="menu--item" style="height: 380px; padding: 25px; background: #006AFF;">
			<div class="profile" style="width: 150px; height: 150px; border-radius: 70%; position: relative; overflow: hidden;">
				<img src="${sessionScope.member.profile_image}" class="profileImage" style="width: 100%; height: 100%; object-fit: cover;" name="profileImage" id="profileImage" alt="프로필">
			</div>
			<div style="color: #FFF; padding: 30px 10px 10px 10px; line-height: 2;">
				<p style="font-size: 18px; font-weight: 600; margin: 0px;">관리자 님</p>
				<p style="margin-bottom: 30px; font-size: 16px;">
					안녕하세요!&emsp;
					<a class="iconUpdate" href="" title="정보수정"><i class="bi bi-pencil-square"></i></a>
				</p>
				<span>최근접속일자</span><br>
				<span style="font-size: 11px;">2025-01-23 16:02:34</span>
			</div>
		</li>

		<li class="menu--item">
			<a href="<c:url value='/admin' />" aria-current="page" class="menu--link" title="관리자홈">
				<span class="menu--label">관리자홈</span>
			</a>
		</li>
	
		<li class="menu--item">
			<a href="<c:url value='/admin/memberManage/main'/>" class="menu--link" title="회원관리">
				<span class="menu--label">회원관리</span>
			</a>
		</li>
	
		<li class="menu--item">
			<a href="<c:url value='/admin/complaintManage/list'/>" class="menu--link" title="신고관리">
				<span class="menu--label">신고관리</span>
			</a>
		</li>
		
		<li class="menu--item">
			<a href="<c:url value='/admin/boardManage/list'/>" class="menu--link" title="게시글관리">
				<span class="menu--label">게시글관리</span>
			</a>
		</li>
	
		<li class="menu--item has-submenu">
			<a href="<c:url value='/admin/productManage/list'/>" class="menu--link" title="상품관리">
				<span class="menu--label">상품관리</span>
			</a>
			<ul class="submenu">
				<li><a href="<c:url value='/admin/productManage/stock'/>" class="menu--link" title="재고 관리">공동구매 상품 및 재고</a></li>
				<li><a href="<c:url value='/admin/productManage/list'/>" class="menu--link" title="상품 목록">공동구매 상품목록</a></li>
			</ul>
		</li>
	
		<li class="menu--item">
			<a href="<c:url value='/admin/memberQna/list'/>" class="menu--link" title="고객문의">
				<span class="menu--label">고객문의</span>
			</a>
		</li>
	</ul>
</nav>
