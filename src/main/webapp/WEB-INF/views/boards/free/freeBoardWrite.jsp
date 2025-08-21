<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<!-- CSS import -->
<link rel="stylesheet" href="/css/common/layout.css">
<link rel="stylesheet" href="/css/free.css">
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
	<%@ include file="/WEB-INF/views/common/header.jsp"%>

	<div class="write-container">
		<h2>게시글 작성</h2>
		<form action="/boards/free/freeBoardWriteProc.do" method="post"
			class="write-form" onsubmit="return validateWriteForm()">
			<input type="hidden" name="userId" value="${loginUserId}" /> <input
				type="hidden" name="postdate" value="${postdate}" /> <input
				type="text" name="title" placeholder="제목을 입력하세요" />
			<textarea name="content" placeholder="내용을 입력하세요"></textarea>
			<div class="write-actions">
				<button type="submit">작성 완료</button>
				<button type="button" class="cancel-btn"
					onclick="location.href='/boards/free/freeBoardList.do'">취소</button>
			</div>
		</form>
	</div>

	<%@ include file="/WEB-INF/views/common/footer.jsp"%>
</body>
</html>