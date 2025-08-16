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
		<h1 class="title">${ qna.title }</h1>
		
		<div class="qna-view-header">
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
		
	<c:if test="${ not empty qna.answercontent }">
		<div class="qna-view-answer">
			<h3>📌 답변</h3>
			<pre>${ qna.answercontent }</pre>
		</div>
	</c:if>
		
		<div class="qna-view-buttons">
			<button onclick="location.href='/qnaBoardList.do'">목록</button>
			<c:if test="${ qna.writerid == userId }">
				<button onclick="location.href='/qnaBoardEdit.do?idx=${ qna.idx }'">수정</button>
				<button onclick="if(confirm('정말 삭제할까요?')) location.href='/qnaBoardDelete.do?idx=${ qna.idx }'">삭제</button>
			</c:if>
			
		</div>
	</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
