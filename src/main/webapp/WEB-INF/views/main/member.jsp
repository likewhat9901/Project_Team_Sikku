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
	<!-- 다이어리에 글을 작성하지 않았을 때 -->
<c:choose>
	<c:when test="${empty plants}">
		<div class="plant-container placeholder" data-placeholder="true">
        <div class="plant-card">
          <div class="plant-info">
            <div class="plant-image">
              <!-- 기본 이미지 -->
              <img src="/images/placeholder/plantrb_whitebg.png" alt="기본 식물 이미지">
              <!-- 
              
              <img src="/images/header/logo.png" alt="기본 식물 이미지">
               -->
            </div>
            <div class="plant-info-box">
              <p class="plant-name">식물명 : 나의 식꾸</p>
              <p class="plant-description">요약 정보는 다이어리를 작성하면 자동으로 채워져요.</p>
            </div>
          </div>
          <!--        
          왼쪽 버튼   
          <div class="navigation-btn prev-btn" aria-hidden="true">&#8249;</div>
           -->
          <div class="plant-status">
            <div class="status-header">식물 상태창</div>
            <div class="status-content">
              <a class="btn-write" href="/mydiary/write.do"
                 style="display:inline-block;padding:10px 14px;border:1px solid #2b7;color:#2b7;border-radius:8px;text-decoration:none;">
               + 다이어리를 작성해주세요
              </a>
            </div>
          </div>
          <!-- 
          오른쪽 버튼
          <div class="navigation-btn next-btn" aria-hidden="true">&#8250;</div>          
           -->
        </div>
      </div>
    </c:when>
    
    <c:otherwise>
    <!-- 다이어리에 글을 썼을 때 보이는 기존 카드 형식. -->
<c:forEach items="${ plants }" var="row" varStatus="loop">
	<div class="plant-container" data-plant-name="${row.name}" >
		<div class="plant-card">
			<div class="plant-info">
			    <div class="plant-image">
			        <img src="/images/dict/${row.imgpath }" alt="식물사진">
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
</c:otherwise>
  </c:choose>
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
(async function renderChartsForAllCards() {
  const FAIL_MSG = '데이터 불러오기에 실패했습니다.';
  const LIB_FAIL_MSG = '그래프 라이브러리 로드에 실패했습니다.';

  // 0) 카드 수집 (placeholder 제외)
  const containers = Array.from(document.querySelectorAll('.plant-container'))
    .filter(c => !(c.dataset.placeholder === 'true' || c.classList.contains('placeholder')));

  //0-1) 로딩 스피너 스타일 1회 주입
  (function injectLoaderStyle() {
    if (document.getElementById('chart-loader-style')) return;
    const st = document.createElement('style');
    st.id = 'chart-loader-style';
    st.textContent = '@keyframes spin{to{transform:rotate(360deg)}}';
    document.head.appendChild(st);
  })();

  // 0-2) 모든 카드에 우선 "로딩" 메시지 표시
  const loaderHTML =
    '<div style="display:flex;align-items:center;gap:8px;padding:12px;color:#666;">' +
      '<span style="width:14px;height:14px;border:2px solid #bbb;border-top-color:transparent;border-radius:50%;display:inline-block;animation:spin 1s linear infinite"></span>' +
      '<span>잠시만 기다려 주세요...</span>' +
    '</div>';
  containers.forEach(container => {
    const card   = container.querySelector('.plant-card');
    const header = card?.querySelector('.plant-status .status-header');
    const box    = card?.querySelector('.plant-status .status-content');
    if (header) header.textContent = '예측 그래프 준비중';
    if (box) box.innerHTML = loaderHTML;
  });
  
  // 1) Chart.js 로드(한 번만)
  async function ensureChart() {
    if (window.Chart) 
    	return true;
    return new Promise((resolve, reject) => {
      const s = document.createElement('script');
      s.src = 'https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js';
      s.onload = () => resolve(true);
      s.onerror = () => reject(new Error('Chart load failed'));
      document.head.appendChild(s);
    });
  }
  try { 
	await ensureChart(); 
  } catch { 
	console.warn(LIB_FAIL_MSG); 
	return; 
  }

  // 2) 예측 데이터 한 번만 가져오기
  let json;
  try {
    const res = await fetch('/api/predict/outdoor', 
    		{ headers: { 'Accept': 'application/json' } });
    if (!res.ok) { 
		console.warn(FAIL_MSG); 
		return; }
    	json = await res.json();
  } catch {
    	console.warn(FAIL_MSG);
    	return;
  }

  // 3) 키를 빠르게 찾기 위한 헬퍼 (이름/idx 둘 다 지원)
  //    - JSON 키가 문자열 이름이라면 name으로 매칭
  function pickSeries(plantName) {
    if (!json) return null;
    if (!plantName) return null;

    const trimmedName = plantName.trim(); // 앞뒤 공백 제거
    if (Object.prototype.hasOwnProperty.call(json, trimmedName)) {
        return { key: trimmedName, rows: json[trimmedName] };
    }
    return null;
  }

  //4) 각 카드에 대해 해당 시리즈 렌더
  containers.forEach(container => {
    const card   = container.querySelector('.plant-card');
    const header = card.querySelector('.plant-status .status-header');
    const box    = card.querySelector('.plant-status .status-content');
    if (!header || !box){
		console.error("header, box error");
    	return;
	}
    const plantName = (container.dataset.plantName || '').trim();
    const found = pickSeries(plantName);
	
    // 1. 키 없음
    if (!found) {
      header.textContent = '예측 그래프 준비중';
      box.innerHTML = plantName + `<div>${"의 데이터는 준비중입니다."}</div>`;
      return;
    }

    // 2. 키는 있으나 데이터 비어있거나 형식 문제
    const rows = found.rows;
    console.error(rows);
    if (!Array.isArray(rows) || !rows.length) {
      header.textContent = '예측 그래프 준비중';
      box.innerHTML = plantName + `<div>${"의 데이터가 비어있습니다."}</div>`;
      return;
    }

    const labels = rows.map(r => Number(r.date));
    const height = rows.map(r => Number(r.height));
    if (!labels.length || height.some(isNaN)) {
      header.textContent = '예측 그래프 : ' +found.key;
      box.innerHTML = `<div style="padding:12px;color:#666;">${DATA_NOT_READY}</div>`;
      return;
    }

	// fruitnum: fruitnum에서 하나라도 숫자값이 있으면 열매수 축/라인을 함께 그림
    const fruit = rows.map(r => (r && r.fruitnum != null ? Number(r.fruitnum) : null));
    const hasFruit = fruit.some(v => typeof v === 'number' && !Number.isNaN(v));

   	console.error("found.key:" ,found.key);
    // 3. 정상 데이터 → 차트 렌더
    header.textContent = '예측 그래프 : ' + found.key;
    box.innerHTML = '';
    const canvas = document.createElement('canvas');
    canvas.style.height = '300px';
    box.appendChild(canvas);

 	// 마지막 값을 예측으로 가정
    const n = labels.length;
    const lastIdx = n - 1;

    // height 데이터 준비
    const hActual = height.slice();
    if (n >= 1) hActual[lastIdx] = null;

    // 예측 구간: 마지막-1 → 마지막만 남긴 라인(점선)
    const hPred = new Array(n).fill(null);
    if (n >= 2) {
      hPred[lastIdx - 1] = height[lastIdx - 1];
      hPred[lastIdx] = height[lastIdx];
    } else if (n === 1) {
      // 데이터가 1개뿐이면 그 1개를 예측 점으로만 표시
      hPred[lastIdx] = height[lastIdx];
    }

 	// Fruit 실측/예측 (있을 때만)
    let fActual = null, fPred = null;
    if (hasFruit) {
      fActual = fruit.slice();
      if (n >= 1) fActual[lastIdx] = null;

      fPred = new Array(n).fill(null);
      if (n >= 2) {
        fPred[lastIdx - 1] = fruit[lastIdx - 1];
        fPred[lastIdx]     = fruit[lastIdx];
      } else if (n === 1) {
        fPred[lastIdx]     = fruit[lastIdx];
      }
    }
    
    // 마지막 점에 "예측" 라벨을 달아주는 간단 플러그인
    const annotateLastPoint = {
      id: 'annotateLastPoint',
      afterDatasetsDraw(chart) {
        const meta = chart.getDatasetMeta(1); // height 데이터셋
        const el = meta?.data?.[lastIdx];
        if (!el) return;
        const {ctx} = chart;
        ctx.save();
        ctx.fillStyle = '#666';
        ctx.textAlign = 'left';
        ctx.textBaseline = 'bottom';
        ctx.fillText('예측', el.x -50, el.y);
        ctx.restore();
      }
    };

 	// 데이터셋 구성
    const datasets = [
      {
        label: 'Height(실측)',
        data: hActual,
        tension: 0.2,
        pointRadius: 3,
        pointHoverRadius: 5,
        yAxisID: 'y'
      },
      {
        label: 'Height(예측)',
        data: hPred,
        tension: 0.2,
        borderDash: [6, 4],
        borderWidth: 2,
        pointRadius: (ctx) => (ctx.dataIndex === lastIdx ? 6 : 0),
        pointHoverRadius: (ctx) => (ctx.dataIndex === lastIdx ? 8 : 0),
        yAxisID: 'y'
      }
    ];
 	
    if (hasFruit) {
      datasets.push(
        {
          label: '열매수(실측)',
          data: fActual,
          tension: 0.2,
          pointRadius: 3,
          pointHoverRadius: 5,
          yAxisID: 'y2'
        },
        {
          label: '열매수(예측)',
          data: fPred,
          tension: 0.2,
          borderDash: [6, 4],
          borderWidth: 2,
          pointRadius: (ctx) => (ctx.dataIndex === lastIdx ? 6 : 0),
          pointHoverRadius: (ctx) => (ctx.dataIndex === lastIdx ? 8 : 0),
          yAxisID: 'y2'
        }
      );
    }
    
    const chart = new window.Chart(canvas.getContext('2d'), {
      type: 'line',
      data: { labels, datasets },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: true },
          tooltip: {
            callbacks: {
              label: (ctx) => {
                const val = ctx.parsed.y;
                return (ctx.datasetIndex === 1 ? '예측: ' : '실측: ') + val;
              }
            }
          }
        },
        scales: {
          x: { title: { display: true, text: '주차' } },
          y: { title: { display: true, text: '식물 키' } },
          ...(hasFruit ? {
            y2: {
              position: 'right',
              title: { display: true, text: '열매 수' },
              grid: { drawOnChartArea: false }
            }
          } : {})
        }
      },
      plugins: [annotateLastPoint]
    });
    container._chart = chart;
  });

})();
</script>


</html>