<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Q&A 상세보기</title>
  <link rel="stylesheet" href="/css/common/layout.css">
  <link rel="stylesheet" href="/css/qnaBoardView.css">
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

	<div class="qna-view-container">
		<div class="qna-view-header">
			<h1 class="title">${ qna.title }</h1>
			<c:if test="${userRole == 'ROLE_ADMIN'}">
				<button type="button" onclick="toggleAnswerForm()">관리자 답변</button>
			</c:if>
		</div>
		
		<div class="qna-post-info">
			<span class="writer">작성자: ${ qna.writer }</span>
			<span class="date post">
			작성일: ${ qna.formattedPostdate }
			</span>
			<span class="date update">
			수정일: ${ qna.formattedUpdatedate }
			</span>
			<span class="views">조회수: ${ qna.views }</span>
		</div>
		
		<div class="qna-view-content">
			<pre>${ qna.content }</pre>
		</div>
		
		<div id="answer-box" class="qna-view-answer">
			<h3>📌 답변</h3>
		
		<c:if test="${ not empty qna.answercontent }">
			<pre id="answer-pre">${qna.answercontent}</pre>
		</c:if>
		
			<!-- 2. 버튼 누르면 이 textarea/form이 보여짐 -->
			<form id="answer-form" action="/qnaBoardAnswer.do" method="post" style="display:none;">
				<input type="hidden" name="idx" value="${qna.idx}" />
				<textarea name="answercontent" rows="6" cols="80">${qna.answercontent}</textarea><br>
				<button type="submit">답변 등록</button>
			</form>
		</div>
	
		
		<div class="qna-view-buttons">
			<button onclick="location.href='/qnaBoardList.do'">목록</button>
			<button onclick="location.href='/qnaBoardEdit.do?idx=${ qna.idx }'">수정</button>
			<button onclick="if(confirm('정말 삭제할까요?')) location.href='/qnaBoardDelete.do?idx=${ qna.idx }'">삭제</button>
		</div>
	</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
<script>
function toggleAnswerForm() {
    const pre = document.getElementById('answer-pre');
    const form = document.getElementById('answer-form');

    // pre 숨기고 textarea/form 보여주기
    if (pre) {
        pre.style.display = 'none';
    }

    form.style.display = 'block';
}
</script>
</html>
