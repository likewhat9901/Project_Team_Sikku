
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta charset="UTF-8">
<title>freeBoardList</title>

<style>
<!-- CSS - Header  -->
.main_container {
    width: 100%;
    min-height: 100vh;
}

.main_header {
    background: white;
    padding: 15px 30px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.main_logo {
    font-size: 18px;
    font-weight: 600;
    color: #333;
}

.main_nav {
    display: flex;
    gap: 30px;
}

.main_nav a {
    text-decoration: none;
    color: #666;
    font-weight: 500;
    padding: 8px 16px;
    border-radius: 6px;
    transition: background-color 0.3s;
}

.main_nav a:hover {
    background-color: #f0f0f0;
    color: #333;
}

.main_nav .active {
    background-color: #333;
    color: white;
}
<!--------------------------------------------------------------------- -->
<!-- CSS - Body  -->
body {
  font-family: sans-serif;
  margin: 0;
  padding: 1rem;
  background: #f5f5f5;
}
.board-container {
  margin-top: 50px;
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
  justify-content: center;
}
.board-card {
  background: white;
  border-radius: 10px;
  box-shadow: 0 0 5px rgba(0,0,0,0.1);
  padding: 1rem;
  width: 48%;
  box-sizing: border-box;
}
.board-title {
  font-size: 1.1rem;
  font-weight: bold;
  margin-bottom: 0.5rem;
}
.board-content {
  font-size: 0.9rem;
  color: #555;
  margin-bottom: 0.8rem;
}
.board-footer {
  font-size: 0.8rem;
  color: #888;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-top: 1px solid #eee;
  padding-top: 0.5rem;
}
@media (max-width: 600px) {
  .board-card {
    width: 100%;
  }
}
</style>

<!-- 
<script>
  window.addEventListener('scroll', function() {
    if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight) {
      // 여기에 Ajax 호출 혹은 게시물 추가 함수 넣기
    }
  });
</script>
 -->
</head>

<!-- 헤더 -->
<header class="main_header">
    <div class="main_logo">Site name</div>
    <nav class="main_nav">
        <a href="/">메인</a>
        <a href="/freeBoardList.do" class="active">커뮤니티</a>
        <a href="#">다이어리</a>
        <a href="/info.do">식물도감</a>
    </nav>
</header>
	      
	      
<body>
	<div class="board-container">
	  <!-- 카드 1 -->
	  <div class="board-card" onclick="location.href='/freeBoardView.do'" style="cursor:pointer;">
	    <div class="board-title">나 여자인데 연봉 7800이양</div>
	    <div class="board-content">저연차라 젊음ㅎㅎ 내 미래의 남편은 적어도 2배는 벌길...</div>
	    <div class="board-footer">
	      <span>한국가스공사 · 익명</span>
	      <span>조회 225 · 좋아요 38</span>
	    </div>
	  </div>
	
	  <!-- 카드 2 -->
	  <div class="board-card">
	    <div class="board-title">남자들은.. 정말 많이 사랑하면 데이트비용 대부분 부담하나요?</div>
	    <div class="board-content">제가 너무 틀에 박혀있는건지... 사랑하면 같이 쓰는거라고 생각했는데...</div>
	    <div class="board-footer">
	      <span>세화사 · 익명</span>
	      <span>조회 13K · 좋아요 283</span>
	    </div>
	  </div>
	
	  <!-- 카드 3 -->
	  <div class="board-card">
	    <div class="board-title">인스턴트 음식을 처음 먹어본 나이?</div>
	    <div class="board-content">소개팅한 상대가 인스턴트를 처음 먹은게 직장생활 이후라고 하던데...</div>
	    <div class="board-footer">
	      <span>CJ프레시웨이 · 익명</span>
	      <span>조회 0 · 좋아요 0</span>
	    </div>
	  </div>
	
	  <!-- 카드 4 -->
	  <div class="board-card">
	    <div class="board-title">페이</div>
	    <div class="board-content">네이버페이 카카오페이 다 쓰시나요? 20대인데 무조건 있어야 하는건지...</div>
	    <div class="board-footer">
	      <span>네이버 · 익명</span>
	      <span>조회 0 · 좋아요 0</span>
	    </div>
	  </div>
	</div>

	<!--  
	
	<div class="board-container">
	    <c:forEach items="${lists}" var="row">
	        <div class="board-card">
	            <div class="board-title">
	                <a href="./freeboardView?idx=${row.BOARD_IDX}">
	                    ${row.TITLE}
	                </a>
	            </div>
	            <div class="board-content">
	                ${row.CONTENT}
	            </div>
	            <div class="board-meta">
	                <span>👤 ${row.MEMBER_IDX}</span>
	                <span>👁 ${row.VISITCOUNT}</span>
	                <span>🕒 ${row.POSTDATE}</span>
	            </div>
	        </div>
	    </c:forEach>
	</div>
	
	  -->
	

</body>
</html>