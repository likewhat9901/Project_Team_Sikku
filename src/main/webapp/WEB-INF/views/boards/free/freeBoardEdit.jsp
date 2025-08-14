<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 수정</title>
<link rel="stylesheet" href="/css/free.css">
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
	<header class="main-header">
		<h1>자유게시판 - 글 수정</h1>
	</header>

	<main class="board-edit">
		<form action="freeBoardEditProc.do" method="post">
			<input type="hidden" name="boardIdx" value="${board.boardIdx}" />

			<div class="form-group">
				<label for="title">제목</label> <input type="text" id="title"
					name="title" value="${board.title}" required />
			</div>

			<div class="form-group">
				<label for="content">내용</label>${likesCount}
				<textarea id="content" name="content" rows="10" required>${board.content}</textarea>
			</div>

			<div class="form-actions">
				<button type="submit">수정 완료</button>
				<button type="button" onclick= "location.href='freeBoardView.do?boardIdx=${board.boardIdx}'">취소</button>
			</div>
		</form>
	</main>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
