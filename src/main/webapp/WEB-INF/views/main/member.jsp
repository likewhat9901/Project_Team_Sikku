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

<%@ include file="/WEB-INF/views/common/features/weather.jsp" %>

<!-- Dashboard Section -->
<div class="dashboard">
	<h2 class="dashboard-title">내 식물 상태창</h2>
<c:forEach items="${ plants }" var="row" varStatus="loop">
	<div class="plant-container">
		<div class="plant-card">
			<div class="plant-info">
			    <div class="plant-image">
			        <img src="/images/status/${row.imgpath }" alt="식물사진">
			    </div>
			    <div class="plant-info-box">
			        <p class="plant-name">식물명 : ${ row.name }</p>
			        <p class="plant-description">${ row.summary }</p>
			    </div>
			</div>
			<div class="navigation-btn prev-btn">&#8249;</div>
			<div class="plant-status">
			    <div class="status-header">식물 상태창 내용</div>
			    <div class="status-content">
			        <!-- 상태 정보가 들어갈 공간 -->
			    </div>
			</div>
			<div class="navigation-btn next-btn">&#8250;</div>
		</div>
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

<!-- ===== 예측 그래프 렌더링(식물 db 완성되면 매핑처리해서 그래프 띄워야함) ===== -->
<script type="text/javascript">
(async function renderOneChart() {
  const FAIL_MSG = '데이터 불러오기에 실패했습니다.';
  const LIB_FAIL_MSG = '그래프 라이브러리 로드에 실패했습니다.';

  // 첫 번째 카드만 사용
  const container = document.querySelector('.plant-container');
  if (!container) return;

  // 카드 내부 영역 헬퍼
  const card   = container.querySelector('.plant-card');
  const box    = card.querySelector('.plant-status .status-content') || card.querySelector('.status-content') || card;
  const header = card.querySelector('.plant-status .status-header');
  const setHeader = (t) => { if (header) header.textContent = t; };
  const showMsg = (msg) => { box.innerHTML = `<div style="padding:12px;color:#666;">${msg}</div>`; };

  // Chart.js(UMD) 동적 로드
  async function ensureChart() {
    if (window.Chart) return true;
    return new Promise((resolve, reject) => {
      const s = document.createElement('script');
      s.src = 'https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js';
      s.onload = () => resolve(true);
      s.onerror = () => reject(new Error('Chart load failed'));
      document.head.appendChild(s);
    });
  }

  // 1) 라이브러리 확보
  try {
    await ensureChart();
  } catch {
    showMsg(LIB_FAIL_MSG);
    return;
  }

  // 2) 데이터 가져오기
  let json;
  try {
    const res = await fetch('/api/predict/outdoor', { headers: { 'Accept': 'application/json' } });
    if (!res.ok) { showMsg(FAIL_MSG); return; }
    json = await res.json();
  } catch {
    showMsg(FAIL_MSG);
    return;
  }

  const entries = Object.entries(json || {});
  if (!entries.length) { showMsg(FAIL_MSG); return; }

  // 3) 첫 번째 시리즈로 차트 1개(Height) 렌더
  const [name, rows] = entries[0];
  const labels = rows.map(r => Number(r.date));
  const height = rows.map(r => Number(r.height));
  if (!labels.length || height.some(isNaN)) { showMsg(FAIL_MSG); return; }

  console.log('JSON keys =', Object.keys(json));

  setHeader(`예측 그래프 · ${name}`);
  box.innerHTML = '';
  const canvas = document.createElement('canvas');
  canvas.style.height = '300px';
  box.appendChild(canvas);

  const chart = new window.Chart(canvas.getContext('2d'), {
    type: 'line',
    data: {
      labels,
      datasets: [{ label: 'Height', data: height, tension: 0.2 }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        x: { title: { display: true, text: 'date' } },
        y: { title: { display: true, text: 'height' } }
      }
    }
  });

  // 필요시 나중에 파괴할 수 있게 저장
  container._charts = [chart];
})();
</script>

</html>