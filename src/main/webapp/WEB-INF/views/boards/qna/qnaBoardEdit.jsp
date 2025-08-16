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
<link rel="stylesheet" href="/css/qnaBoardEdit.css" />
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

	<h1>Q&A 글 수정하기</h1>
	

	<div class="qna-write-container">
		<h2>게시글 수정</h2>
		<form action="/qnaBoardEditProc.do" method="post"
			class="qna-edit-form" onsubmit="return validateWriteForm()">
			<div class="qna-category-row">
				<div class="qna-category-box">
					<span>카테고리를 선택해주세요</span>
					<select name="category">
						<option value="계정문의"
							${qna.category == '계정문의' ? 'selected' : ''}>계정문의</option>
						<option value="결제문의"
							${qna.category == '결제문의' ? 'selected' : ''}>결제문의</option>
						<option value="이용문의"
							${qna.category == '이용문의' ? 'selected' : ''}>이용문의</option>
						<option value="기타문의"
							${qna.category == '기타문의' ? 'selected' : ''}>기타문의</option>
					</select>
				</div>
				
				<div class="qna-select-box">
					<label for="secretflag">
					비밀글&nbsp;
					<input type="checkbox" id="secretflag" name="secretflag" value="Y"
						${qna.secretflag == 'Y' ? 'checked' : ''} />
					</label>
				</div>
			</div>
			
			
			<input type="hidden" name="idx" value="${qna.idx}" />
			<input type="hidden" name="writerid" value="${qna.writerid}" readonly />
			<input type="hidden" name="writer" value="${qna.writer}" readonly />

			<input type="text" name="title" value="${qna.title}" />

			<textarea name="content">${qna.content}</textarea>
			<div class="qna-edit-buttons">
				<button type="submit">작성 완료</button>
				<button type="button" class="cancel-btn"
					onclick="location.href='/qnaBoardList.do'">취소</button>
			</div>
		</form>
	</div>

	<%@ include file="/WEB-INF/views/common/footer.jsp"%>
</body>
</html>
