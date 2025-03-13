<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
	.nav-scroller {
		display: flex;
		align-items: center;
		justify-content: flex-start;

		margin-top: 84px;
		height: 60px;
		color: #333;
		border-top: 1px solid #D9D9D9;
		border-bottom: 1px solid #D9D9D9;
	}
	.sub-link {
		color: #333;
	}

	.sub-link:hover, .sub-link.active {
		color: #006AFF;
		text-decoration: none;
	}

</style>

<script type="text/javascript">
	$(function(){
		var url = window.location.pathname;
		var urlRegExp = new RegExp(url.replace(/\/$/, '') + "$");

		try {
			$('.sub-link').each(function() {
				if (urlRegExp.test(this.href.replace(/\/$/, ''))) {
					$(this).addClass('active');
					return false;
				}
			});

			if (!$('.sub-link').hasClass('active')) {
				var parent = url.replace(/\/$/, '').substring(0, url.replace(/\/$/, '').lastIndexOf('/'));
				if (!parent) parent = '/';
				var urlParentRegExp = new RegExp(parent);

				$('.sub-link').each(function() {
					if ($(this).attr('href') === '#' || !$(this).attr('href').trim()) return true;
					var phref = this.href.replace(/\/$/, '').substring(0, this.href.replace(/\/$/, '').lastIndexOf('/'));
					if (urlParentRegExp.test(phref)) {
						$(this).addClass('active');
						return false;
					}
				});
			}

		} catch (e) {
			console.error(e);
		}

		$('.sub-link').on('click', function() {
			$('.sub-link').removeClass('active');
			$(this).addClass('active');
		});
	});
</script>

<div class="nav-scroller">
	<nav class="container nav" aria-label="navigation">
		<a class="nav-link sub-link" aria-current="page" href="<c:url value='/lounge1/room'/>">공동구매</a>
		<a class="nav-link sub-link" href="<c:url value='/lounge1/recipe'/>">물품대여</a>
		<a class="nav-link sub-link" href="<c:url value='/lounge2/tip'/>">경매장</a>
	</nav>
</div>