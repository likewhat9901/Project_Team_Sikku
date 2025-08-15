<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Q&A 상세보기</title>
  <link rel="stylesheet" href="/css/qna-view.css">
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="qna-view-container">
  <h1 class="qna-view-title">${ qna.title }</h1>

  <div class="qna-meta">
    <span class="meta-writer">작성자: ${ qna.writer }</span>
    <span class="meta-date">
      작성일: <fmt:formatDate value="${ qna.postdate }" pattern="yyyy-MM-dd HH:mm" />
    </span>
    <span class="meta-views">조회수: ${ qna.views }</span>
  </div>

  <div class="qna-content">
    <pre>${ qna.content }</pre>
  </div>

  <c:if test="${ not empty qna.answercontent }">
    <div class="qna-answer">
      <h3>📌 답변</h3>
      <pre>${ qna.answercontent }</pre>
    </div>
  </c:if>

  <div class="qna-buttons">
    <button onclick="location.href='/qna/qnaBoardList.do'">목록</button>
    <button onclick="location.href='/qna/edit.do?idx=${ qna.idx }'">수정</button>
    <button onclick="if(confirm('정말 삭제할까요?')) location.href='/qna/delete.do?idx=${ qna.idx }'">삭제</button>
  </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
