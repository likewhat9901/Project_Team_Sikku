<!-- /WEB-INF/views/main/member.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>SpringBoot</title>
	<link rel="stylesheet" href="/css/common/layout.css" />
	<link rel="stylesheet" href="/css/member.css">
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<!-- Weather Section -->
<div class="weather">
    <span class="weather-title">🌿 현재 날씨</span>
    <div class="weather-content">
        <!-- 날씨 정보가 들어갈 공간 -->
        <div class="loading">
            <div class="loading-spinner"></div>
            날씨 정보를 불러오는 중...
        </div>
    </div>
</div>

<!-- Dashboard Section -->
<div class="dashboard">
	<h2 class="dashboard-title">내 식물 상태창</h2>
<c:forEach items="${ plants }" var="row" varStatus="loop">
	<div class="plant-container">
		<div class="navigation-btn prev-btn">&#8249;</div>
		<div class="plant-card">
			<div class="plant-left">
			    <div class="plant-image">
			        <img src="/images/status/${row.ofile }" alt="식물사진">
			    </div>
			    <div class="plant-info-box">
			        <p class="plant-name">식물명 : ${ row.name }</p>
			        <p class="plant-description">${ row.description }</p>
			    </div>
			</div>
	         <div class="plant-status">
	             <div class="status-header">식물 상태창 내용</div>
	             <div class="status-content">
	                 <!-- 상태 정보가 들어갈 공간 -->
	             </div>
	         </div>
		</div>
		<div class="navigation-btn next-btn">&#8250;</div>
	</div>
</c:forEach>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>

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
</html>