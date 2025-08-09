<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>calendar</title>
  <link rel="stylesheet" href="/css/common/layout.css" />
  <link rel="stylesheet" href="/css/myCalendarstyle.css" />
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

  <h2>calendar</h2>
  <div class="calendar-container">
    <div class="calendar-controls">
      <button id="prev-month">◀ 이전달</button>
      <div class="calendar-title" id="calendar-title"></div>
      <button id="next-month">다음달 ▶</button>
      <button type="button" onclick="location.href='${pageContext.request.contextPath}/mydiary/write.do';">글쓰기</button>
    </div>
    <div class="calendar-header" id="calendar-header"></div>
    <div class="calendar-body" id="calendar-body"></div>
  </div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
  // 컨텍스트 경로
  const ctx = '${pageContext.request.contextPath}';
</script>

<script type="module">
    import {
      startOfMonth, endOfMonth, startOfWeek, endOfWeek,
      addDays, format, isSameMonth, isToday, subMonths, addMonths
    } from "https://cdn.skypack.dev/date-fns@2.30.0";

    let currentDate = new Date();
    let posts = [];

    async function loadPosts(year, month) {
      // month: 0~11 이므로 +1 해서 01~12 문자열로
      const y = year;
      const m = String(month + 1).padStart(2, "0");

      //const url = `${ctx}/mydiary/calendar/images?year=${y}&month=${m}`;
      const url = ctx + '/mydiary/calendar/images?year=' + y + '&month=' + m;
	  console.log('FETCH URL:', url);
	  try {
        const response = await fetch(url, { method: 'GET' });
        if (response.ok) {
          // 서버 JSON 예시: [{ postdate: '2025-08-04', imageUrl: '...'}, ...]
          posts = await response.json();
        } else {
          console.error("이미지 데이터를 불러오지 못했습니다.", response.status);
          posts = [];
        }
      } catch (e) {
        console.error("이미지 데이터 요청 중 오류:", e);
        posts = [];
      }
    }

    const header = document.getElementById("calendar-header");
    const body = document.getElementById("calendar-body");
    const title = document.getElementById("calendar-title");

    document.getElementById("prev-month").addEventListener("click", async () => {
      currentDate = subMonths(currentDate, 1);
      await renderAll();
    });

    document.getElementById("next-month").addEventListener("click", async () => {
      currentDate = addMonths(currentDate, 1);
      await renderAll();
    });

    function renderHeader() {
      header.innerHTML = "";
      ['일', '월', '화', '수', '목', '금', '토'].forEach(day => {
        const div = document.createElement('div');
        div.textContent = day;
        header.appendChild(div);
      });
    }

    function renderCalendar() {
      body.innerHTML = "";

      const monthStart = startOfMonth(currentDate);
      const monthEnd = endOfMonth(monthStart);
      const startDate = startOfWeek(monthStart, { weekStartsOn: 0 });
      const endDate = endOfWeek(monthEnd, { weekStartsOn: 0 });

      title.textContent = format(monthStart, "yyyy년 MM월");

      let day = startDate;
      while (day <= endDate) {
        const row = document.createElement('div');
        row.className = 'grid-row';

        for (let i = 0; i < 7; i++) {
          const formattedDate = format(day, 'yyyy-MM-dd');
          const cell = document.createElement('div');
          cell.className = 'calendar-cell';

          if (!isSameMonth(day, monthStart)) cell.classList.add('inactive');
          if (isToday(day)) cell.classList.add('today');

          const dateText = document.createElement('div');
          dateText.textContent = format(day, 'd');
          cell.appendChild(dateText);

          // postdate(스네이크/카멜 혼용 대비)
          const post = posts.find(p => {
            const postDateStr = p.postdate || p.postDate;
            return postDateStr && format(new Date(postDateStr), 'yyyy-MM-dd') === formattedDate && p.imageUrl;
          });

          if (post) {
            const img = document.createElement('img');
            //img.src = `${ctx}/uploads/${post.imageUrl}?v=${Date.now()}`; // 캐시 방지
            img.src = ctx + '/uploads/' + encodeURIComponent(post.imageUrl) + '?v=' + Date.now();
			img.alt = "썸네일";
            img.className = "thumbnail";
            cell.appendChild(img);
          }

          row.appendChild(cell);
          day = addDays(day, 1);
        }

        body.appendChild(row);
      }
    }

    async function renderAll() {
      await loadPosts(currentDate.getFullYear(), currentDate.getMonth());
      renderHeader();
      renderCalendar();
    }

    renderAll();
  </script>
</body>
</html>
