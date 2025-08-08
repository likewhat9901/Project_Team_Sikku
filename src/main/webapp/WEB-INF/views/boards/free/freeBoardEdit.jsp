<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 수정</title>
<link rel="stylesheet" href="/css/free.css">
<link rel="stylesheet" href="/css/member.css">
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
	<header class="main-header">
		<h1>자유게시판 - 글 수정</h1>
	</header>

	<main class="board-edit">
		<form action="freeBoardEditProc.do" method="post">
			<input type="hidden" name="boardIdx" value="${row.boardIdx}" />

			<div class="form-group">
				<label for="title">제목</label> <input type="text" id="title"
					name="title" value="${row.title}" required />
			</div>

			<div class="form-group">
				<label for="writer">작성자</label> <input type="text" id="writer"
					name="memberIdx" value="${row.memberIdx}" readonly />
			</div>

			<div class="form-group">
				<label for="content">내용</label>
				<textarea id="content" name="content" rows="10" required>${row.content}</textarea>
			</div>

			<div class="form-actions">
				<button type="submit">수정 완료</button>
				<a href="freeBoardView.do?boardIdx=${row.boardIdx}">취소</a>
			</div>
		</form>
	</main>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
