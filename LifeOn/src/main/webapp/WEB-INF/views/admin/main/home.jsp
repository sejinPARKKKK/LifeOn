<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>LifeOn</title>

<script src="https://cdn.jsdelivr.net/npm/echarts/dist/echarts.min.js"></script>
<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
<style type="text/css">
/* 추가 커스텀 스타일 */
.state-card {
	text-align: center;
	padding: 1rem;
	position: relative;
	border-left: 5px solid #007bff; /* 파란색 바 추가 */
	border-radius: 10px;
	background: white;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.chart-container {
	width: 100%;
	height: 300px;
	margin: auto;
}

.state-card:hover {
	background-color: #f0f8ff; /* 연한 파란색 (Aliceblue) */
	transform: translateY(-5px); /* 약간 위로 올라감 */
	box-shadow: 0 4px 10px rgba(0, 123, 255, 0.3); /* 그림자 강조 */
}
</style>
</head>
<body>

	<header class="container-fluid header-top fixed-top px-4">
		<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />
	</header>

	<main>
		<jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
		<div class="wrapper">
			<div class="container">
				<div class="container my-5">
					<!-- 상단 통계 카드: 누적 방문자 수, 오늘 방문자, 총 회원수, 오늘 가입자 -->
					<div class="row mb-4">
						<div class="col-md-3 mb-3">
							<div class="card state-card shadow-sm">
								<h5>누적 방문자 수</h5>
								<p id="totalVisitors" class="fs-4 fw-bold">0명</p>
							</div>
						</div>
						<div class="col-md-3 mb-3">
							<div class="card state-card shadow-sm">
								<h5>오늘 방문자</h5>
								<p id="todayVisitors" class="fs-4 fw-bold">0명</p>
							</div>
						</div>
						<div class="col-md-3 mb-3">
							<div class="card state-card shadow-sm">
								<h5>총 회원수</h5>
								<p id="totalMembers" class="fs-4 fw-bold">0명</p>
							</div>
						</div>
						<div class="col-md-3 mb-3">
							<div class="card state-card shadow-sm">
								<h5>오늘 가입자</h5>
								<p id="todayNewMembers" class="fs-4 fw-bold">00명</p>
							</div>
						</div>
					</div>

					<!-- 중단 차트: 회원 연령대(Bar), 남녀 성비(Pie) -->
					<div class="row mb-4">
						<div class="col-md-6 mb-3">
							<div class="card shadow-sm p-3">
								<h5 class="mb-3">회원 연령대</h5>
								<div class="chart-container">
									<div id="ageChart" style="width: 100%; height: 300px;"></div>
								</div>
							</div>
						</div>
						<div class="col-md-6 mb-3">
							<div class="card shadow-sm p-3">
								<h5 class="mb-3">남녀 성비</h5>
								<div class="chart-container">
									<div id="genderChart" style="width: 100%; height: 300px;"></div>
								</div>
							</div>
						</div>
					</div>

					<!-- 하단 카테고리 통계: 클릭 수가 많은 카테고리 -->
					<div class="row">
						<div class="col-md-12">
							<div class="card shadow-sm p-3">
								<h5 class="mb-3">조회수가 많은 카테고리</h5>
								<div class="chart-container">
									<div id="categoryChart" style="width: 100%; height: 300px;"></div>
								</div>
							</div>
						</div>
					</div>
				</div>


			</div>
		</div>
	</main>
	<script type="text/javascript">
	
	document.addEventListener("DOMContentLoaded", function() {
	    fetch('/admin/main/totalVisitors')
	        .then(response => response.json())
	        .then(data => {
	            document.getElementById('totalVisitors').innerText = data + "명";
	        })
	        .catch(error => console.error('누적 방문자 수 가져오기 실패 : ', error));

	    fetch('/admin/main/todayVisitors')
	        .then(response => response.json())
	        .then(data => {
	            document.getElementById('todayVisitors').innerText = data + "명";
	        })
	        .catch(error => console.error('오늘 방문자 수 가져오기 실패 : ', error));
	});
	
	document.addEventListener("DOMContentLoaded", function () {
	   // 총 회원 수 가져오기
	   fetch('/admin/main/totalMembers')
	        .then(response => response.json())
	        .then(data => {
	            document.getElementById('totalMembers').innerText = data + "명";
	        })
	        .catch(error => console.error('총 회원 수 가져오기 실패:', error));
	});
	
	document.addEventListener("DOMContentLoaded", function () {
        // 오늘 가입한 회원 수 불러오기
        fetch('/admin/main/todayNewMembers')
            .then(response => response.json())
            .then(data => {
                document.getElementById('todayNewMembers').innerText = data + "명";
            })
            .catch(error => console.error('오늘 가입자 수 가져오기 실패:', error));
    });
	
	
	document.addEventListener("DOMContentLoaded", function() {
		//회원 연령대 (ECharts)
		var ageChart = echarts.init(document.getElementById('ageChart'));
		
		// 서버에서 연령대 데이터 가져오기
		fetch('/admin/main/memberAgeDistribution')
			.then(response => response.json())
			.then(data => {
				//서버에서 받은 데이터를 차트 형식에 맞게 변환
				const ageLabels = data.map(item => item.AGE_GROUP); 
				const ageValues = data.map(item => item.COUNT);
				 var option = {
			                title: {
			                    text: '회원 연령대 분포'
			                },
			                tooltip: {
			                    trigger: 'axis'
			                },
			                xAxis: {
			                    type: 'category',
			                    data: ageLabels
			                },
			                yAxis: {
			                    type: 'value'
			                },
			                series: [
			                    {
			                        name: '회원 수',
			                        data: ageValues,
			                        type: 'line',
			                        smooth: true,
			                        itemStyle: {
			                            color: '#007bff'
			                        }
			                    }
			                ]
			            };

			            ageChart.setOption(option);
			})
			.catch(error => console.error('연령대 데이터 가져오기 실패:', error));
		window.addEventListener('resize', function() {
	        ageChart.resize();
	    });
	});
	
	document.addEventListener("DOMContentLoaded", function () {
	    var genderChart = echarts.init(document.getElementById('genderChart'));

	    fetch('/admin/main/genderRatio')
	        .then(response => response.json())
	        .then(data => {
	            console.log("📌 남녀 성비 데이터:", data); // JSON 데이터 확인

	            // 📌 데이터 변환
	            const genderLabels = data.map(item => item.GENDER_GROUP);
	            const genderValues = data.map(item => item.COUNT);

	            var option = {
	                tooltip: {
	                    trigger: 'item'
	                },
	                legend: {
	                    top: '5%',
	                    left: 'center'
	                },
	                series: [
	                    {
	                        name: '회원 성비',
	                        type: 'pie',
	                        radius: ['40%', '70%'], // 도넛 형태
	                        avoidLabelOverlap: false,
	                        itemStyle: {
	                            borderRadius: 10,
	                            borderColor: '#fff',
	                            borderWidth: 2
	                        },
	                        label: {
	                            show: false,
	                            position: 'center'
	                        },
	                        emphasis: {
	                            label: {
	                                show: true,
	                                fontSize: 20,
	                                fontWeight: 'bold'
	                            }
	                        },
	                        labelLine: {
	                            show: false
	                        },
	                        data: genderLabels.map((label, index) => ({
	                            name: label,
	                            value: genderValues[index]
	                        }))
	                    }
	                ]
	            };

	            genderChart.setOption(option);
	        })
	        .catch(error => console.error('남녀 성비 데이터 가져오기 실패:', error));

	    // 📌 창 크기 변경 시 차트 크기 자동 조정
	    window.addEventListener('resize', function() {
	        genderChart.resize();
	    });
	});
	
	/*
	//카테고리별 조회수 
	document.addEventListener("DOMContentLoaded", function () {
	    // 초기 데이터 생성
	    const data = [];
	    for (let i = 0; i < 5; ++i) {
	        data.push(Math.round(Math.random() * 200));
	    }

	    // 클릭 수가 많은 카테고리 (ECharts)
	    var categoryChart = echarts.init(document.getElementById('categoryChart'));

	    var option = {
	        xAxis: {
	            max: 'dataMax'
	        },
	        yAxis: {
	            type: 'category',
	            data: ['라운지', '마켓', '지역정보', '홈', '정책정보'],
	            inverse: true,
	            animationDuration: 300,
	            animationDurationUpdate: 300,
	            max: 4 // 상위 3개 막대만 표시
	        },
	        series: [
	            {
	                realtimeSort: true,
	                name: '조회수',
	                type: 'bar',
	                data: data,
	                label: {
	                    show: true,
	                    position: 'right',
	                    valueAnimation: true
	                }
	            }
	        ],
	        legend: {
	            show: true
	        },
	        animationDuration: 0,
	        animationDurationUpdate: 3000,
	        animationEasing: 'linear',
	        animationEasingUpdate: 'linear'
	    };

	    categoryChart.setOption(option);

	    // 실시간 데이터 업데이트 함수
	    function updateChart() {
	        for (var i = 0; i < data.length; ++i) {
	            if (Math.random() > 0.9) {
	                data[i] += Math.round(Math.random() * 2000);
	            } else {
	                data[i] += Math.round(Math.random() * 200);
	            }
	        }
	        categoryChart.setOption({
	            series: [
	                {
	                    type: 'bar',
	                    data: data
	                }
	            ]
	        });
	    }

	    // 0초 후 실행, 이후 3초마다 데이터 업데이트
	    setTimeout(function () {
	        updateChart();
	    }, 0);

	    setInterval(function () {
	        updateChart();
	    }, 3000);

	    // 창 크기 변경 시 차트 크기 자동 조정
	    window.addEventListener('resize', function() {
	        categoryChart.resize();
	    });
	});
	*/
	 document.addEventListener("DOMContentLoaded", function () {
         var categoryChart = echarts.init(document.getElementById('categoryChart'));

         function updateCategoryChart() {
             fetch('/admin/main/viewCounts')
                 .then(response => response.json())
                 .then(data => {
                     console.log("📌 카테고리별 조회수:", data);

                     // 📌 데이터 변환
                     const categories = Object.keys(data);
                     const viewCounts = Object.values(data);

                     var option = {
                         xAxis: {
                             type: 'category',
                             data: categories
                         },
                         yAxis: {
                             type: 'value'
                         },
                         series: [
                             {
                                 name: '조회수',
                                 type: 'bar',
                                 data: viewCounts
                             }
                         ]
                     };

                     categoryChart.setOption(option);
                 })
                 .catch(error => console.error('카테고리별 조회수 데이터 가져오기 실패:', error));
         }

         // ✅ 차트 업데이트 실행
         updateCategoryChart();

     });
	
	
	</script>
	<footer>
		<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
	</footer>



	<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
</body>
</html>