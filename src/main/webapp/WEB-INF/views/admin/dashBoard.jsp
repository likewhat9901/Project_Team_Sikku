<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>활성화 대시보드</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

	<h2>주간 게시판 발행량</h2>
	
	<button onclick="location.href='/admin/index.do'">뒤로 가기</button>
	<!-- 주간 게시판 발행량 차트 출력 -->
	<canvas id="weeklyPostsChart" width="600" height="300"></canvas>
	
	<script>
		async function renderWeeklyPostsChart() {
		
		const url = '/api/dashboard/weekly-posts';
		try {
			// 백엔드 API 호출
			const response = await fetch(url, {method : 'GET'});
			const data = await response.json();
			
			// 날짜와 게시글 수를 배열로 분리
			const labels = data.map(item => item.date);
			const counts = data.map(item => item.postCount);
			
			// Chart.js 생성
			const ctx = document.getElementById("weeklyPostsChart").getContext("2d");
			new Chart(ctx, {
				type: "line",  //여기를 인기글은 bar로 바꾸장
				data: {
					labels: labels,
					datasets: [{
						label: "주간 게시글 수",
						data: counts,
						borderColor: "blue",
						backgroundColor: "rgba(0, 0, 255, 0.2)",
						fill: true,
						tension: 0.3
					}]	
				},
				options: {
					responsive: true,
					scales: {
						x: {title: {display:true, text:"날짜"}},
						y: {title: {display:true, text:"게시글 수"}, beginAtZero:true}
					}
				}
			});	
		}
		catch (err) {
			console.error("주간 게시판 발행량 차트 로드 실패", err);
		}
		}
		
		// 주간 게시판 차트 로드 실행
		renderWeeklyPostsChart();
	</script>

</body>
</html>