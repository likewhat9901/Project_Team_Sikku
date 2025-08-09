<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head>
<meta charset="UTF-8">
<title>freeBoardList</title>

<link rel="stylesheet" href="/css/free.css">

<!-- JS import -->
<script src="/js/freeBoardList.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
	
	<div class="board-btn-container">
	<button class="board-btn blue"
		onclick="location.href='/boards/free/freeBoardList.do'">자유게시판</button>
	<button class="board-btn green"
		onclick="location.href='/galleryBoardList.do'">갤러리게시판</button>
	</div>
	
	<div class="search-write-container">
	<input type="search">검색창
	<button class="write-btn"
		onclick="location.href='/boards/free/freeBoardWrite.do'">글쓰기</button>
	</div>
		
	<div id="board-container" class="board-container">
	
	  <!-- 카드  -->
	  <c:forEach items="${rows}" var="row" varStatus="vs">
	  <div class="board-card" style="cursor:pointer;"
	  		onclick="location.href='/boards/free/freeBoardView.do?boardIdx=${row.boardIdx}'">
    	<div class="board-idx">${row.boardIdx}</div>
	    <div class="board-title">${row.title}</div>
	    <div class="board-content">${row.content}</div>
	    <div class="board-footer">
	      <span>${row.userId}</span>
	      <span>${row.likes} · ${row.visitcount}</span>
	    </div>
	  </div>
	  </c:forEach> 
	  
	  
	</div>


	
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>