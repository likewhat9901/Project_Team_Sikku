<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head>
<meta charset="UTF-8">
<title>freeBoardList</title>
<!-- CSS import -->
<link rel="stylesheet" href="/css/free.css">
<link rel="stylesheet" href="/css/member.css">

<!-- JS import -->
<script src="/js/freeBoardList.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

	<button onclick="location.href='/boards/free/freeBoardList.do'">자유게시판</button>
	<button onclick="location.href='/galleryBoardList.do'">갤러리게시판</button>
	<input type="search">검색창
	<button onclick="location.href='/boards/free/freeBoardWrite.do'">글쓰기</button>
	<div id="board-container" class="board-container">
	
	  <!-- 카드  -->
	  <c:forEach items="${rows}" var="row" varStatus="vs">
	  <div class="board-card" style="cursor:pointer;"
	  		onclick="location.href='/boards/free/freeBoardView.do?boardIdx=${row.boardIdx}'">
    	<div class="board-idx">${row.boardIdx}추가</div>
	    <div class="board-title">${row.title}</div>
	    <div class="board-content">${row.content}</div>
	    <div class="board-footer">
	      <span>${row.memberIdx}</span>
	      <span>${row.likes} · ${row.visitcount}</span>
	    </div>
	  </div>
	  </c:forEach> 
	  
	  
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
	
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>