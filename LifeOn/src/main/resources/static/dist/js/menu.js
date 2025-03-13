// 메뉴 상단 고정
/*
$(function(){
	$(window).scroll(function() {
		if ($(this).scrollTop() > 100) {
			$('.navbar').addClass('fixed-top');
		} else {
			$('.navbar').removeClass('fixed-top');
		}
	});
	
	if ($(window).scrollTop() > 100) {
		$('.navbar').addClass('fixed-top');
	}
});
*/

// 메뉴 활성화
$(function(){
    let url = window.location.pathname;
	if (url.includes("/auction")) {
		url = "/market" + url;
	}
    let urlRegExp = new RegExp(url.replace(/\/$/, '') + "$");
	$('nav .navbar-collapse>ul>li>a').each(function() {
		let filterUrl = url.split('/')[1].substring(0, 6);

		if (this.href.includes(filterUrl)) {
			$(this).addClass('active');
			return false;
		} else if (urlRegExp.test(this.href.replace(/\/$/, ''))) {
			$(this).addClass('active');
			return false;
		}
	});

	if($('nav .navbar-collapse>ul>li>a').hasClass("active")) return false;
	
	$('nav .navbar-collapse>ul>li a').each(function() {
		if (urlRegExp.test(this.href.replace(/\/$/, ''))) {
			if($(this).closest(".dropdown").parent().parent(".navbar-collapse")) {
				
				$(this).closest(".dropdown").children("a").eq(0).addClass('active');
			} else {
				$(this).closest(".dropdown").closest(".dropdown").children("a").eq(0).addClass('active');
			}
			return false;
		}
	});
	if($('nav .navbar-collapse>ul>li a').hasClass("active")) return false;
	
 	let parent = url.replace(/\/$/, '').substr(0, url.replace(/\/$/, '').lastIndexOf("/"));
 	if(! parent) parent = "/";
    let urlParentRegExp = new RegExp(parent);
	$('nav .navbar-collapse>ul>li a').each(function() {
		if($(this).attr("href")=="#") return true;
		
		let phref = this.href.replace(/\/$/, '').substr(0, this.href.replace(/\/$/, '').lastIndexOf("/"));
		if (urlParentRegExp.test(phref)) {
			if(! $(this).closest(".dropdown")) {
				$(this).addClass('active');
			} else if($(this).closest(".dropdown").parent().parent(".navbar-collapse")) {
				$(this).closest(".dropdown").children("a").eq(0).addClass('active');
			} else {
				$(this).closest(".dropdown").closest(".dropdown").children("a").eq(0).addClass('active');
			}

			return false;
		}
	});
});
