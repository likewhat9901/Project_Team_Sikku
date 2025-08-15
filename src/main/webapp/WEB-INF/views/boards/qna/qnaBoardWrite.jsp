<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
	<%@ include file="/WEB-INF/views/common/header.jsp"%>

	<h1>Q&A 글 작성하기</h1>
	<!-- account, payment, service, etc -->

	<div class="qna-write-container">
		<h2>게시글 작성</h2>
		<form action="/qnaBoardWriteProc.do" method="post"
			class="qna-write-form" onsubmit="return validateWriteForm()">

			<div class="qna-category-box">
				<span>카테고리를 선택해주세요</span>
				<select name="category">
					<option value="account">계정 문의</option>
					<option value="payment">결제</option>
					<option value="service">이용 문의</option>
					<option value="etc">기타문의</option>
				</select>
			</div>
			
			<div class="qna-select-box">
				<label for="secretflag">
				<input type="checkbox" id="secretflag" name="secretflag" value="Y" />
				비밀글
				</label>
			</div>
			
			<input type="text" name="writerid" value="${writerid}" readonly />
			<input type="text" name="writer" value="${writer}" readonly />

			<input type="text" name="title" placeholder="제목을 입력하세요" />

			<textarea name="content" placeholder="내용을 입력하세요"></textarea>
			<div class="qna-write-buttons">
				<button type="submit">작성 완료</button>
				<button type="button" class="cancel-btn"
					onclick="location.href='/qnaBoardList.do'">취소</button>
			</div>
		</form>
	</div>

	<%@ include file="/WEB-INF/views/common/footer.jsp"%>
</body>
</html>
