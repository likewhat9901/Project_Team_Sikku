<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>홈페이지 활성화 대시보드</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link rel="stylesheet" href="/css/dashBoard.css">
</head>
<body>

	<button onclick="location.href='/admin/index.do'">뒤로 가기</button>
	
	<div class="chart-grid-container">
	
	<div>
		<h2>주간 게시판 발행량</h2>
		<canvas id="weeklyPostsChart" ></canvas>
	</div>
		
	<div>
		<h2>주간 댓글 발행량</h2>
		<canvas id="weeklyCommentsChart" ></canvas>
	</div>
	
	<div class="chart-container">
		<h2>주간 조회수 TOP5 게시물</h2>
		<canvas id="weeklyTop5PostsChart" ></canvas>
	</div>
		
	<div class="chart-container2">
		<h2>사용자별 활동 추이</h2>
		<canvas id="weeklyUsersByActivityChart" ></canvas>
	</div>
	
	</div>
	
	<script>
		async function renderWeeklyPostsChart() {
		
		const url = '/api/dashboard/weekly-posts';
		try {
			// 백엔드 API 호출
			const response = await fetch(url, {method : 'GET'});
			const data = await response.json();
			
			// 날짜와 게시글 수를 배열로 분리
			const labels = data.map(item => item.postdate);
			const counts = data.map(item => item.postCount);
			
			// Chart.js 생성
			const ctx = document.getElementById("weeklyPostsChart").getContext("2d");
			new Chart(ctx, {
				type: "line",
				data: {
					labels: labels,
					datasets: [{
						label: "주간 게시글 수",
						data: counts,
						borderColor: "rgba(103, 58, 183, 1)",
						backgroundColor: "rgba(103, 58, 183, 0.3)",
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
	
	<!--------------------------------------------------------------------------->
	
	<script>
		async function renderWeeklyCommentsChart() {
		
		const url = '/api/dashboard/weekly-comments';
		try {
			// 백엔드 API 호출
			const response = await fetch(url, {method : 'GET'});
			const data = await response.json();
			
			// 날짜와 댓글 수를 배열로 분리
			const labels = data.map(item => item.postdate);
			const counts = data.map(item => item.postCount);
			
			// Chart.js 생성
			const ctx = document.getElementById("weeklyCommentsChart").getContext("2d");
			new Chart(ctx, {
				type: "line",  //여기를 인기글은 bar로 바꾸장
				data: {
					labels: labels,
					datasets: [{
						label: "주간 댓글 수",
						data: counts,
						borderColor: "rgba(76, 175, 80, 1)",
						backgroundColor: "rgba(76, 175, 80, 0.3)",
						fill: true,
						tension: 0.3
					}]	
				},
				options: {
					responsive: true,
					scales: {
						x: {title: {display:true, text:"날짜"}},
						y: {title: {display:true, text:"댓글 수"}, beginAtZero:true}
					}
				}
			});	
		}
		catch (err) {
			console.error("주간 댓글 발행량 차트 로드 실패", err);
		}
		}
		
		// 주간 게시판 차트 로드 실행
		renderWeeklyCommentsChart();
	</script>
	

	<!--------------------------------------------------------------------------->
	
	<script>
		async function renderWeeklyTop5PostsChart() {
		
		const url = '/api/dashboard/weekly-top5';
		try {
			// 백엔드 API 호출
			const response = await fetch(url, {method : 'GET'});
			const data = await response.json();
			
			// 라벨은 제목으로 설정
			const labels = data.map(item => item.title);
			
			// Chart.js 생성
			const ctx = document.getElementById("weeklyTop5PostsChart").getContext("2d");
			const chart = new Chart(ctx, {
			    type: "pie",
			    data: {
			        labels: data.map(d => d.title),
			        datasets: [{
			            label: "조회수",
			            data: data.map(d => d.visitcount),
			            backgroundColor: [
			            	"#4A148C",
			                "#6A1B9A",
			                "#8E24AA",
			                "#AB47BC",
			                "#CE93D8"
			            ],
                    borderColor: '#fff',
                    borderWidth: 2
			        }]
			    },
			    options: {
			        responsive: true,
			        onClick: (evt, elements) => {

		        	// 클릭한 파이조각 인덱스
	        	    const idx = elements[0].index;
		        	// 해당 게시물 정보
	        	    const post = data[idx];
	        	    
	        	    // boardIdx를 문자열로 변환
	        	    const boardIdxStr = String(post.boardIdx);

		            let url = "";
		            if (post.category === 1) {
		                url = `/boards/free/freeBoardView.do?boardIdx=`+boardIdxStr;
		            } else if (post.category === 2) {
		                url = `/boards/gallery/galleryBoardView.do?boardIdx=`+boardIdxStr;
		            }

		            window.location.href = url;
			        }
			    }
			});

	    } catch (err) {
	        console.error("주간 TOP5 차트 로드 실패", err);
	    }
	}

	// 차트 실행
	renderWeeklyTop5PostsChart();
	</script>
	
	
	<!--------------------------------------------------------------------------->
	
	<script>
		async function renderWeeklyUsersByActivityChart() {
		
		const url = '/api/dashboard/weekly-user';
		try {
			// 백엔드 API 호출
			const response = await fetch(url, {method : 'GET'});
			const data = await response.json();
			
			// 라벨은 유저ID로 설정
			const labels = data.map(item => item.userId);
			
			// Chart.js 생성
			const ctx = document.getElementById("weeklyUsersByActivityChart").getContext("2d");
			new Chart(ctx, {
				type: "bar",
				data: {
					labels: labels,
					datasets: [
				        {
				            label: "게시물",
				            data: data.map(d => d.postCount),  // 게시물 수
				            backgroundColor: "rgba(103, 58, 183, 0.8)"
				        },
				        {
				            label: "댓글",
				            data: data.map(d => d.commentCount), // 댓글 수
				            backgroundColor: "rgba(76, 175, 80, 0.8)"
				        }
				    ]	
				},
				options: {
					responsive: true,
					scales: {
						x: {title: {display:true, text:"사용자ID"}},
						y: {title: {display:true, text:"발행량"}, beginAtZero:true}
					}
				}
			});	
		}
		catch (err) {
			console.error("주간 TOP5 차트 로드 실패", err);
		}
		}
		
		//차트 실행
		renderWeeklyUsersByActivityChart();
	</script>
</body>
</html>