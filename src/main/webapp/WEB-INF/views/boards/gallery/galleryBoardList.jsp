<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>
<meta charset="UTF-8">
<title>galleryBoardList</title>
<link rel="stylesheet" href="/css/common/layout.css">
<link rel="stylesheet" href="/css/gallery.css">

<!-- JS import -->
<script src="/js/galleryBoardList.js"></script>
</head>
<body>
	<%@ include file="/WEB-INF/views/common/header.jsp"%>

	<!-- 게시판 선택 버튼 -->
	<div class="board-btn-container">
		<button class="board-btn blue"
			onclick="location.href='/boards/free/freeBoardList.do'">자유게시판</button>
		<button class="board-btn green"
			onclick="location.href='/boards/gallery/galleryBoardList.do'">갤러리게시판</button>
	</div>

	<!-- 검색창 + 글쓰기 버튼 -->
	<div class="search-write-container">
		<form action="/boards/gallery/galleryBoardList.do" method="get">
			<input type="search" name="searchWord" placeholder="검색어를 입력해보세요"
				value="${param.searchWord != null ? param.searchWord : ''}">
			<button type="submit" class="search-btn">검색</button>
		</form>

		<button class="write-btn"
			onclick="location.href='/boards/gallery/galleryBoardWrite.do'">글쓰기</button>
	</div>

	<!-- 게시물 리스트 -->
	<div class="feed-container">
		<c:forEach items="${rows}" var="row">
			<div class="feed-post"
				style="cursor:pointer;"
				onclick="location.href='/boards/gallery/galleryBoardView.do?boardIdx=${row.boardIdx}'">

				<!-- 작성자 영역 -->
				<div class="feed-header">
					<img src="/images/프로필.png" alt="profile" class="profile-img">
					<span class="username">${row.userId}</span>
				</div>

				<!-- 게시물 이미지 -->
				<div class="feed-image">
					<img src="/uploads/board/${imageMap[row.boardIdx]}" alt="게시물이미지">
				</div>

				<!-- 액션 버튼 -->
				<div class="feed-actions">
					❤️ &nbsp ${likesCountMap[row.boardIdx]} &nbsp&nbsp 
					💬 &nbsp ${commentCountMap[row.boardIdx]}
				</div>

				<!-- 게시물 내용 -->
				<div class="feed-content">
					<span class="username">${row.userId}</span>
					<c:choose>
						<c:when test="${fn:length(row.content) > 50}">
						${fn:substring(row.content, 0, 50)}...
						</c:when>
						<c:otherwise>
						${row.content}
						</c:otherwise>
					</c:choose>
				</div>

			</div>
		</c:forEach>
	</div>

	<%@ include file="/WEB-INF/views/common/footer.jsp"%>
</body>
</html>