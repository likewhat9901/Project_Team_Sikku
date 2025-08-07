<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>  <!-- Spring Security 태그 추가 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SpringBoot</title>
<link rel="stylesheet" href="/css/main.css">
</head>
<body>

<!-- Header Section -->
<div class="header">
   <div class="header-content">
      <div class="logo">
         <span class="home-btn" onclick="location.href='/'">로고</span> 
         <span class="site-name">그린다이어리(예명)</span>
      </div>

      <div class="nav-icons">
         <div class="nav-item">
            <div class="icon-box"></div>
            <span>궁금해?</span>
         </div>
         <div class="nav-item" onclick="location.href='/freeBoardList.do'">
            <div class="icon-box"></div>
            <span>커뮤니티</span>
         </div>
         <div class="nav-item" onclick="location.href='/mydiary/list.do'">
            <div class="icon-box"></div>
            <span>다이어리</span>
         </div>
         <div class="nav-item" onclick="location.href='/info.do'">
            <div class="icon-box"></div>
            <span>식물도감</span>
         </div>
         <div class="nav-item" onclick="location.href='/mbti.do'">
            <div class="icon-box"></div>
            <span>MBTI</span>
         </div>
      </div>

      <!-- ✅ 로그인 상태에 따라 동적으로 변경 -->
      <div class="user-section">

         <!-- 비로그인 시 -->
         <sec:authorize access="!isAuthenticated()">
            <span class="login-link" onclick="location.href='/myLogin.do'">로그인</span>
            <span class="register-link" onclick="location.href='/signup.do'">회원가입</span>
         </sec:authorize>

         <!-- 로그인 시 -->
         <sec:authorize access="isAuthenticated()">
            <span class="mypage-link" onclick="location.href='/mypage.do'">마이페이지</span>
            <span class="logout-link" onclick="location.href='/myLogout.do'">로그아웃</span>
            <div class="user-icon">👤</div>
         </sec:authorize>

      </div>
   </div>
</div>

<!-- Main Container -->
<div class="main_container">

   <!-- Weather Section -->
   <div class="weather">
      <span class="weather-label">날씨정보</span>
      <div class="weather-content">
         <!-- 날씨 정보가 들어갈 공간 -->
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
                     <img src="/images/${row.ofile }" alt="식물사진">
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
</div>

<!-- 날씨 JS -->
<script type="text/javascript">
window.addEventListener('DOMContentLoaded', function () {
    fetch('/api/weather')
        .then(response => response.json())
        .then(data => {
            const container = document.querySelector('.weather-content');
            container.innerHTML = '';

            if (!data || data.length === 0) {
                container.innerHTML = '<p>날씨 정보를 불러올 수 없습니다.</p>';
                return;
            }

            const latest = data[0];
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
</body>
</html>
