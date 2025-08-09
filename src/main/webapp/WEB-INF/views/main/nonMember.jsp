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

<div class="main_container">
    <!-- Weather -->
    <div class="weather">
        <span class="weather-label">날씨정보</span>
        <div class="weather-content">
            <!-- 날씨 정보가 들어갈 공간 -->
        </div>
    </div>
    
    <!-- Ranking -->
	<div class="ranking">
	</div>

<!-- Hero Section -->
	<div class="hero-section">
		<div class="banner">
			<a href="/mbti.do">
		        <div class="mbti-banner"></div>
			</a>
		</div>
		<div class="popular-board">
			<p>인기게시물 테이블 들어가는 부분</p>
		</div>
		
	</div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>

<script type="text/javascript">
window.addEventListener('DOMContentLoaded', function () {
	const container = document.querySelector('.weather-content');
	container.innerHTML = '<p>날씨 정보를 불러오는 중...</p>';
	
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

<script>
document.addEventListener('DOMContentLoaded', function () {
    fetch('/api/ranking?category=farm')
        .then(response => response.json())
        .then(data => {
        	const rankingContainer = document.querySelector('.ranking');
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
});
</script>
</html>