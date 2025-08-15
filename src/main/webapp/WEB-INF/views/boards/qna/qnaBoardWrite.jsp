<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Q&A</title>
  <link rel="stylesheet" href="/css/common/layout.css" />
  <link rel="stylesheet" href="/css/qnaBoardView.css" />
  <script>
	function validateWriteForm() {
		const title = document.querySelector('[name="title"]').value.trim();
		const content = document.querySelector('[name="content"]').value.trim();

		if (!title) {
			alert("제목을 입력해주세요.");
			return false;
		}

		if (!content) {
			alert("내용을 입력해주세요.");
			return false;
		}

		return true;
	}
</script>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

  <h1>Q&A 글 작성하기</h1> <!-- account, payment, service, etc -->
  
  	<div class="write-container">
		<h2>게시글 작성</h2>
		<form action="/boards/qna/qnaBoardWriteProc.do" method="post"
			class="write-form" onsubmit="return validateWriteForm()">
			<input type="hidden" name="userId" value="유저아아디" />
			<input type="hidden" name="postdate" value="작성일자" />
			
			
			
			<input type="text" name="title" placeholder="제목을 입력하세요" />
			<textarea name="content" placeholder="내용을 입력하세요"></textarea>
			<div class="write-actions">
				<button type="submit">작성 완료</button>
				<button type="button" class="cancel-btn"
					onclick="location.href='/boards/qna/qnaBoardList.do'">취소</button>
			</div>
		</form>
	</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
