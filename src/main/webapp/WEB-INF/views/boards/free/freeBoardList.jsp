<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>
<meta charset="UTF-8">
<title>freeBoardList</title>

<link rel="stylesheet" href="/css/common/layout.css">
<link rel="stylesheet" href="/css/free.css">

<!-- JS import -->
<script src="/js/freeBoardList.js"></script>
</head>
<body>
	<%@ include file="/WEB-INF/views/common/header.jsp"%>

	<div class="board-btn-container">
		<button class="board-btn blue"
			onclick="location.href='/boards/free/freeBoardList.do'">자유게시판</button>
		<button class="board-btn green"
			onclick="location.href='/boards/gallery/galleryBoardList.do'">갤러리게시판</button>
	</div>

	<div class="search-write-container">
		<form action="/boards/free/freeBoardList.do" method="get">
			<input type="search" name="searchWord" placeholder="검색어를 입력해보세요"
				value="${param.searchWord != null ? param.searchWord : ''}">
			<button type="submit" class="search-btn">검색</button>
		</form>

		<button class="write-btn"
			onclick="location.href='/boards/free/freeBoardWrite.do'">글쓰기</button>
	</div>

	<div id="board-container" class="board-container">

		<!-- 카드 부분만 수정 -->
		<c:forEach items="${rows}" var="row" varStatus="vs">
			<div class="board-card"
				onclick="location.href='/boards/free/freeBoardView.do?boardIdx=${row.boardIdx}'">
				<input type="hidden" class="board-idx" value="${row.boardIdx}">
				<div class="board-title">${row.title}</div>
				<div class="board-content-text">
					<c:choose>
						<c:when test="${fn:length(row.content) > 20}">
                ${fn:substring(row.content, 0, 20)}...
            </c:when>
						<c:otherwise>
                ${row.content}
            </c:otherwise>
					</c:choose>
				</div>
				<div class="board-footer">
					<span>작성자 : ${row.userId}</span> <span>조회수 :
						${row.visitcount} 좋아요 : ${likesCountMap[row.boardIdx]}</span>
				</div>
			</div>
		</c:forEach>


	</div>



	<%@ include file="/WEB-INF/views/common/footer.jsp"%>
</body>
</html>