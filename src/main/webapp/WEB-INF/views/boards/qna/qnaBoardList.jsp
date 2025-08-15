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
  <link rel="stylesheet" href="/css/qnaBoardList.css" />

</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
	
	<div class="qna-list-container">
		<h1>Q&A</h1>
		
		<button class="write-btn"
			onclick="location.href='/qnaBoardView.do'">글쓰기</button>
		
		<!-- 게시글 검색 -->
		<div class="search-box">
			<form action="/qna/search.do" method="get">
				<select name="type">
					<option value="writer">작성자</option>
					<option value="title">제목</option>
					<option value="content">내용</option>
					<option value="titleAndContent">제목+내용</option>
				</select>
				<input type="text" name="keyword" placeholder="검색어를 입력하세요" />
				<button type="submit">검색</button>
			</form>
		</div>
		
		<table class="qna-list-table">
			<tr>
				<th>No</th>
				<th>카테고리</th>
				<th>제목</th>
				<th>글쓴이</th>
				<th>작성일</th>
				<th>조회수</th>
				<th>답변상태</th>
			</tr>
	    
		<!-- 공지글 -->
		<c:forEach items="${noticeRows}" var="nrow" varStatus="">
		    <tr class="notice-row">
				<td>📌</td>
				<td>${ nrow.category }</td>
				<td style="text-align:left; width:40%">
		            <a href="/qnaBoardView.do?idx=${nrow.idx}">
		                ${ nrow.title }
		            </a>
		        </td>
		        <td>${ nrow.writer }</td>
		        <td>${ nrow.formattedPostdate}</td>
		        <td>${ nrow.views}</td>
		        <td>${ nrow.answerstatus }</td>
		    </tr>
		</c:forEach>
	
		<!-- 일반 Q&A -->
		<c:forEach items="${qnaRows}" var="qrow" varStatus="var">
			<tr>
				<td>${ var.count }</td>
				<td>${ qrow.category }</td>
				<td style="text-align:left; width:40%">
		            <a href="/qnaBoardView.do?idx=${qrow.idx}">
		                <c:if test="${ qrow.secretflag == 'Y' }">🔒 </c:if>
		                ${ qrow.title }
		            </a>
		        </td>
				<td>${ qrow.writer }</td>
				<td>${ qrow.formattedPostdate}</td>
				<td>${ qrow.views}</td>
				<td>${ qrow.answerstatus }</td>
			</tr>
		</c:forEach>
		</table>

	</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
