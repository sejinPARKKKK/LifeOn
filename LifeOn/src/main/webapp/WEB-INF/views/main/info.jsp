<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>LifeOn</title>

<script src="https://cdn.jsdelivr.net/npm/echarts/dist/echarts.min.js"></script>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<style type="text/css">
@font-face {
    font-family: 'SBAggroB';
    src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_2108@1.1/SBAggroB.woff') format('woff');
    font-weight: normal;
    font-style: normal;
}

#info {
	width: 80%;
	height: 500px;
	padding-bottom: 20px;
}

h1, h3, h5 {
	width: 80%;
	font-family: 'SBAggroB', sans-serif;
}

p {
	margin: 0;
}
    
.content {
	width: 80%;
	font-size: 18px;
	padding-bottom: 60px;
}

.team-card {
    background-color: white;
    width: 300px;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    margin: 0 35px 20px 0px;
    text-align: center;
    padding: 20px;
    transition: transform 0.3s ease;
}

.team-card:hover {
    transform: translateY(-10px);
}

.team-card img {
    width: 100%;
    height: 200px;
    object-fit: cover;
    border-radius: 10px;
    padding-bottom: 10px;
}

.team-name {
	width: 100%;
	font-family: 'SBAggroB', sans-serif;
}

.role {
	margin-bottom: 10px;
	font-weight: bold;
	color: #006AFF;
}

.chat-message {
    max-width: 70%;
    padding: 10px;
    border-radius: 10px;
    display: inline-block;
    margin-bottom: 10px;
    font-size: 14px;
    line-height: 1.4;
}

.left {
    background-color: #e1e1e1;
    align-self: flex-start;
    border-top-left-radius: 0;
}

.right {
    background-color: #007bff;
    color: white;
    align-self: flex-end;
    border-top-right-radius: 0;
}

.chat-message span {
    display: inline-block;
    word-wrap: break-word;
}
 
</style>
</head>
<body>

<header>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main class="d-flex flex-column min-vh-100 align-items-center" style="padding-top: 164px; padding-bottom: 80px; background: #FBFBFB;">
	<div style="width: 1280px; padding-top: 60px; display: flex; flex-direction: column; align-items: center; background: #FFF; border: 10px solid #006AFF;">

		<div style="width: 80%; padding-bottom: 20px;"><img src="${pageContext.request.contextPath}/dist/images/logo.png" alt="logo" style="width: 200px; height: 100px;"></div>
		
		<h3 style="margin-bottom: 40px;">1인가구 플랫폼</h3>
		<div id="info"></div>
		<div class="content">
			1인 가구의 증가에 따라, 1인 가구의 특성과 요구에 최적화된 맞춤형 서비스의 필요성이 점차 커지고 있으며,<br>
			이에 따라 <b>LifeOn</b>은 1인가구를 위한 서비스를 제공하고 새로운 시작을 지원하는 플랫폼을 제작하게 되었습니다.<br><br>

			<b>‘삶이 시작된다’</b>는 의미로,
			혼자서도 풍요롭고 의미 있는 삶을 살아갈 수 있도록 다양한 취향과 스타일을 제시하고,
			각자의 독립적인 공간을 존중하면서도, 같은 취향을 가진 이들과 함께 더 나은 삶을 만들어갈 수 있는 다양한 서비스를 제공합니다.<br><br>
			이곳에서, 혼자서도 충분히 행복하고 의미 있는 삶을 추구하는 사람들은 서로의 경험을 나누며 더 풍성한 삶을 시작할 수 있습니다. 다양한 형태의 1인 가구가 모여 서로의 가치를 존중하고, 더불어 살아가는 세상을 만들어갑니다.
		</div>		
		
		<h3 style="margin-bottom: 40px;">LifeOn의 다양한 주제</h3>
		<div class="content">
			<h5>🎤 라운지</h5>
			편안한 커뮤니티 공간에서 다양한 정보를 나누고 소통하세요.<br>
			인테리어 자랑, 자취 요리 레시피, 생활 팁 등 실용적인 정보뿐만 아니라,<br>
			일상 속 이야기를 자유롭게 공유할 수 있는 커뮤니티 공간입니다.<br><br>
			<h5>🛍️ 마켓</h5>
			공동구매, 물품 대여, 물품 경매 등 다양한 거래 활동을 지원하는 마켓 공간입니다.<br>
			필요하거나 불필요한 물건을 서로 나누며, 합리적인 가격으로 거래를 할 수 있습니다.<br><br>
			<h5>🔍 지역정보</h5>
			살기 좋은 지역에 대한 리뷰와 추천을 통해 내게 맞는 거주지를 찾을 수 있습니다.<br>
			또한, 지역 모임을 통해 가까운 이웃과 소통하고, 함께 활동을 즐길 수 있는 기회를 제공합니다.<br><br>
			<h5>👀 정책정보</h5>
			1인 가구를 위한 맞춤형 정책 정보를 제공합니다.<br>
			1인 가구가 활용할 수 있는 정부의 다양한 지원 정책을 쉽고 빠르게 확인할 수 있습니다.<br>
			실생활에 도움이 되는 정책들을 정리하여, 더 나은 생활을 위한 정보들을 제공합니다.
		</div>	
		
		<h3 style="margin-bottom: 30px;">LifeOn의 팀 소개</h3>
		<div class="content" style="display: flex; padding-bottom: 0">
			<div class="team-card">
	            <img src="${pageContext.request.contextPath}/dist/images/0.png" alt="프로필">
	            <h4 class="team-name">한장희강사님</h4>
	            <p class="role">개발자 멘토</p>
	            <p>
	            	지도/교육<br>
	            	설계 및 방향 제시<br>
	            	오류개선
	            </p>
	        </div>
	        
			<div class="team-card">
	            <img src="${pageContext.request.contextPath}/dist/images/1.png" alt="프로필">
	            <h4 class="team-name">고세정</h4>
	            <p class="role">개발자 리더</p>
	            <p>
	            	생활팁 및 일상게시판<br>
	            	물품대여/판매관리<br>
	            	즐겨찾기
	            </p>
	        </div>

	        <div class="team-card">
	            <img src="${pageContext.request.contextPath}/dist/images/2.png" alt="프로필">
	            <h4 class="team-name">이민재</h4>
	            <p class="role">엘리트 개발자</p>
	            <p>
	            	메인페이지<br>
	            	물품경매/판매관리<br>
	            	통합검색
	            </p>
	        </div>
	    </div>
		<div class="content" style="display: flex; padding-bottom: 40px;">
	        <div class="team-card">
	            <img src="${pageContext.request.contextPath}/dist/images/3.png" alt="프로필">
	            <h4 class="team-name">박래영</h4>
	            <p class="role">실리콘밸리 개발자</p>
	            <p>
	            	인테리어 및 자취요리<br>
	            	지역모임<br>
	            	지역소개<br>
	            	지역MBTI
	            </p>
	        </div>

	        <div class="team-card">
	            <img src="${pageContext.request.contextPath}/dist/images/4.png" alt="프로필">
	            <h4 class="team-name">박세진</h4>
	            <p class="role">코딩 천재</p>
	            <p>
	            	회원가입/로그인/문자인증<br>
	            	공동구매/판매내역<br>
	            	포인트충전<br>
	            	관심상품/주문내역<br>
	            </p>
	        </div>

	        <div class="team-card">
	            <img src="${pageContext.request.contextPath}/dist/images/5.png" alt="프로필">
	            <h4 class="team-name">박호진</h4>
	            <p class="role">밀리터리 개발자</p>
	            <p>
	            	정책정보/이벤트<br>
	            	오픈톡 채팅<br>
	            	고객센터<br>
	            	관리자페이지
	            </p>
	        </div>
		</div>
		
		<h3 style="margin-bottom: 40px;">팀프로젝트 소감한마디</h3>
		<div class="content" style="display: flex; flex-direction: column;">
			<p class="role">고세정</p>
			<div class="chat-message left">
	            <span>
	            	팀원들과 함께 아이디어를 나누고 서로 협력하며 구현해 나가는 과정이 정말 흥미롭고 보람 있었고,<br>
	            	각자의 역할을 맡아 문제를 해결하고, 의견을 주고받으면서 결과물을 만들어가는 과정에서 큰 성취감을 느꼈습니다.
	            </span>
	        </div>
	        
	        <p class="role" style="text-align: end;">이민재</p>
	        <div class="chat-message right">
	            <span>🤔</span>
	        </div>
	        
	        <p class="role">박래영</p>
	        <div class="chat-message left">
	            <span>이번 프로젝트를 통해 또 다른 배움을 얻을 수 있어 좋았습니다.<br> 팀원들과 협업을 통해 성장할 수 있었던 좋은 기회가 된 것 같습니다.</span>
	        </div>
	        
	        <p class="role" style="text-align: end;">박세진</p>
	        <div class="chat-message right">
	            <span>이번 프로젝트는 Spring Boot 환경에서 진행되었으며, 기존 Spring MVC에 비해 자동 설정과<br>어노테이션 기반 개발 덕분에 설정이 간소화되고 개발 속도가 비약적으로 향상됨을 실감할 수 있었습니다.</span>
	        </div>
	        
			<p class="role">박호진</p>
			<div class="chat-message left">
	            <span>이번 프로젝트는 마지막이라 부담이 컸지만 팀원들과 원활한 소통으로 잘 마무리할 수 있었던 것 같아요.<br> 다들 너무 고생했어요.</span>
	        </div>
		</div>
	</div>

</main>

<script type="text/javascript">
document.addEventListener("DOMContentLoaded", function () {
    var chartDom = document.getElementById('info');
    var myChart = echarts.init(chartDom);
    var option;

    option = {
      tooltip: {
        trigger: 'axis',
        axisPointer: {
          type: 'shadow'
        }
      },
      legend: {},
      xAxis: [
        {
          type: 'category',
          data: ['2017', '2018', '2019', '2020', '2021', '2022', '2023']
        }
      ],
      yAxis: [
        {
          type: 'value'
        }
      ],
      series: [
        {
          name: '1인가구',
          type: 'bar',
          stack: 'Ad',
          emphasis: {
            focus: 'series'
          },
          label: {
            show: true,
            formatter: '{c}'
          },
          data: [5619, 5849, 6148, 6643, 7166, 7502, 7829]
        },
        {
          name: '2인가구',
          type: 'bar',
          stack: 'Ad',
          emphasis: {
            focus: 'series'
          },
          label: {
            show: true,
            formatter: '{c}'
          },
          data: [5260, 5446, 5663, 5865, 6077, 6261, 6346]
        },
        {
          name: '3인가구',
          type: 'bar',
          stack: 'Ad',
          emphasis: {
            focus: 'series'
          },
          label: {
            show: true,
            formatter: '{c}'
          },
          data: [4179, 4204, 4218, 4201, 4170, 4185, 4195]
        },
        {
          name: '4인 이상',
          type: 'bar',
          stack: 'Ad',
          emphasis: {
            focus: 'series'
          },
          label: {
            show: true,
            formatter: '{c}'
          },
          data: [4616, 4481, 4315, 4218, 4036, 3826, 3703]
        }
      ]
    };

    myChart.setOption(option);
});
</script>

<footer class="mt-auto py-2 text-center w-100" style="left: 0px; bottom: 0px; background: #F7F9FA;">
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>

</html>