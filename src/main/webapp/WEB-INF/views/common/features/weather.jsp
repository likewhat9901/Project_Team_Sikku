<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<style>
/* Weather Section */
.weather {
	width: 100%; min-height: 170px;
    background: linear-gradient(135deg, #a8e6a3, #7dd3c0);
    border-radius: 25px;
    padding: 20px 25px;
    box-shadow: 0 8px 32px rgba(76, 175, 80, 0.2);
    border: 2px solid rgba(139, 195, 74, 0.3);
}
.weather-title {
    color: black;
    font-size: 1.2em;
    font-weight: 800;
    margin-bottom: 15px;
    display: flex;
    align-items: center;
    gap: 8px;
}
.weather-content {
    display: flex;
    flex-wrap: wrap;  /* 한 줄에 다 안 들어가면 자동 줄바꿈 */
    gap: 16px;
    justify-content: center;
    align-items: center;
    padding: 18px 5px;
    width: 100%;     /* 한 줄에 쭉 나올 수 있게 */
}
.weather-item {
    display: flex;
    align-items: center;
    background: #fff;
    padding: 8px 14px;
    border-radius: 8px;
    box-shadow: 0 1px 3px rgba(60,80,120,0.08);
    min-width: 90px;
    font-weight: 500;
    white-space: nowrap;  /* 줄바꿈 금지 */
}
.weather-item:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(76, 175, 80, 0.25);
}
.weather-label {
    color: #1b5e20;
    font-size: 1em;
    font-weight: 700;
    margin-right: 8px;
    opacity: 0.85;
}
</style>

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