<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>SpringBoot</title>
	<link rel="stylesheet" href="/css/common/layout.css" />
	<link rel="stylesheet" href="/css/nonMember.css">
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

    <!-- Weather -->
    <div class="weather">
        <span class="weather-title">🌿 현재 날씨</span>
		<div class="weather-content">
		    <!-- 날씨 정보가 들어갈 공간 -->
		    <%@ include file="/WEB-INF/views/common/features/loading.jsp" %>
    	</div>
    </div>
    
    <!-- Ranking -->
	<div class="ranking-container">
		<div class="category-select-container">
			<select id="category-select" onchange="fetchRanking(this.value);">
		        <option value="farm">텃밭식물</option>
		        <option value="foliage">관엽식물</option>
		    </select>
	    </div>
		<div class="ranking">
			<%@ include file="/WEB-INF/views/common/features/loading.jsp" %>
	    </div>
	</div>

<!-- Hero Section -->
	<div class="hero-section">
		<div class="banner-container">
			<!-- 이전 버튼 -->
			<button class="nav-buttons prev" onclick="changeSlideLeft();">❮</button>
			
			<div class="banner">
				<img class="banner-img" src="/images/banner/mbti_banner.jpg" alt="Banner1" onclick="location.href='/mbti/list.do'"/>
				<img class="banner-img" src="/images/banner/about_banner.jpg" alt="Banner2" onclick="location.href='/about/identity.do'"/>
				<img class="banner-img" src="/images/banner/diary_banner.jpg" alt="Banner2" onclick="location.href='/mydiary/list.do'"/>
			</div>
			
			<!-- 다음 버튼 -->
			<button class="nav-buttons next" onclick="changeSlideRight();">❯</button>
		</div>
		
		<div class="popular-board">
			<h2>자유게시판 인기 Top10</h2>
			<!-- 인기게시물 테이블이 들어갈 공간 -->
			<div class="board-container">
				<%@ include file="/WEB-INF/views/common/features/loading.jsp" %>
			</div>
		</div>
		
	</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
<!-- 날씨 정보 불러오기 -->
<script type="text/javascript">
window.addEventListener('DOMContentLoaded', function () {
    fetch('/api/weather')
        .then(response => response.json())
        .then(data => {
        	// console.log("data:", data);
            const container = document.querySelector('.weather-content');
            container.innerHTML = '';

            if (!data || data.length === 0) {
                container.innerHTML = '<p>날씨 정보를 불러올 수 없습니다.</p>';
                return;
            }

            // 최신 데이터 1개만 보여줌 (첫 번째 값)
            const latest = data[0];
            // console.log("latest 데이터:", latest);
            // console.log("latest의 키", Object.keys(latest));
            // 시간 포맷 변환 (선택)
            const timeStr = latest.YYMMDDHHMI
			    ? `${latest.YYMMDDHHMI.slice(0,4)}-${latest.YYMMDDHHMI.slice(4,6)}-${latest.YYMMDDHHMI.slice(6,8)} ${latest.YYMMDDHHMI.slice(8,10)}:${latest.YYMMDDHHMI.slice(10,12)}`
			    : '';

            const html = `
                <span class="weather-item"><span class="weather-label">🕑 관측:</span> \${timeStr}</span>
                <span class="weather-item"><span class="weather-label">📍 지점:</span> \${latest.STN}</span>
                <span class="weather-item"><span class="weather-label">🌡️ 기온:</span> \${latest.TA}℃</span>
                <span class="weather-item"><span class="weather-label">💧 습도:</span> \${latest.HM}%</span>
                <span class="weather-item"><span class="weather-label">🌧️ 강수:</span> \${latest["RN-DAY"]}mm</span>
                <span class="weather-item"><span class="weather-label">💨 풍속:</span> \${latest.WS1}m/s</span>
                <span class="weather-item"><span class="weather-label">🧭 풍향:</span> \${latest.WD1}°</span>
                <span class="weather-item"><span class="weather-label">🧪 기압:</span> \${latest.PA}hPa</span>
            `;
            container.innerHTML = html;

        })
        .catch(err => {
            document.querySelector('.weather-content').innerHTML = '<p>날씨 정보를 불러올 수 없습니다.</p>';
        });
});
</script>

<!-- 랭킹 시상대 불러오기 -->
<script>
function fetchRanking(category) {
	console.log("식물랭킹 category: "+category);
	const rankingContainer = document.querySelector('.ranking');
	rankingContainer.innerHTML = 
		`<%@ include file="/WEB-INF/views/common/features/loading.jsp" %>`;
	
    fetch('/api/ranking?category='+category)
        .then(response => response.json())
        .then(data => {
        	rankingContainer.innerHTML = ''; // 기존 시상대 초기화

            if (data.error) {
            	rankingContainer.innerHTML = `<p style="color:red;">\${data.error}</p>`;
                return;
            }
			
            const topN = data.top10.slice(0, 10);
            
            topN.forEach((item, index) => {
            	const height = 180 - index * 10;
            	const html = `
            		<div class="step-container">
	                    <img src="\${item.image}" alt="\${item.name}" />
	                    <div class="step" style="height:\${height}px; background-color: #5cb85c;">
	                        <div class="rank">\${index + 1}위</div>
	                        <div class="name">\${item.name}</div>
	                        <div class="volume">(\${item.volume.toFixed(2)})</div>
	                    </div>
                    </div>
                `;
                rankingContainer.innerHTML += html;
            });
        })
        .catch(err => {
            console.error("API 호출 에러:", err);
        });
}

// 페이지 로드 시 기본 'farm' 카테고리로 데이터 로드
fetchRanking('farm');
    
</script>

<!-- 슬라이드 배너 기능 -->
<script type="text/javascript">

//슬라이드 배너
const slider = document.querySelector('.banner');
const banners = document.querySelectorAll('.banner-img'); // 모든 배너 이미지
let index = 0;

function changeSlideLeft() {
    index = (index - 1 + banners.length) % banners.length; // 이미지 인덱스를 순차적으로 변경
    slider.style.transform = `translateX(-\${index * 100}%)`; // 슬라이드를 오른쪽으로 이동
    
    console.log("changeSlideLeft 호출");
}

function changeSlideRight() {
    index = (index + 1) % banners.length; // 이미지 인덱스를 순차적으로 변경
    slider.style.transform = `translateX(-\${index * 100}%)`; // 슬라이드를 왼쪽으로 이동

    console.log("changeSlideRight 호출");
}

// 5초마다 자동으로 이미지 변경
setInterval(changeSlideRight, 5000);

</script>

<script type="text/javascript">
function fetchPopularBoards(category) {
	console.log("인기게시물 category: "+category);
	const boardContainer = document.querySelector('.board-container');
	const board_header = document.querySelector('.popular-board h2');
	
	// 로딩 표시
	boardContainer.innerHTML = 
		`<%@ include file="/WEB-INF/views/common/features/loading.jsp" %>`;
	
    fetch('/api/popularBoards?category='+category)
        .then(response => response.json())
        .then(data => {
        	boardContainer.innerHTML = ''; // 기존 시상대 초기화
        	
            if (data.error) {
            	boardContainer.innerHTML = `<p style="color:red;">\${data.error}</p>`;
                return;
            }
			
            const top10 = data.top10;
            const category_name = data.category_name;
            board_header.innerHTML = category_name+ ' 인기 Top10';
            
         	// 테이블 헤더 만들기
            let tableHTML = `
                <table border="1" style="width:100%; ">
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th>제목</th>
                            <th>날짜</th>
                        </tr>
                    </thead>
                    <tbody>
            `;
            
            top10.forEach((item, index) => {
                // 날짜가 없으면 빈칸 처리
                const date = item.date || '';
                tableHTML += `
                    <tr>
                        <td style="text-align:center;">\${index + 1}</td>
                        <td>\${item.title || '제목 없음'}</td>
                        <td style="text-align:center;">\${date}</td>
                    </tr>
                `;
            });
            
            tableHTML += '</tbody></table>';

            boardContainer.innerHTML = tableHTML;
        })
        .catch(err => {
            console.error("API 호출 에러:", err);
            boardContainer.innerHTML = '<p style="color:red;">인기게시물을 불러오는 중 오류가 발생했습니다.</p>';
        });
}

fetchPopularBoards('free');
</script>
</html>