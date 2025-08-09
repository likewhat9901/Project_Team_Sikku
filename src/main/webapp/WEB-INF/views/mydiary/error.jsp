<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link rel="stylesheet" href="/css/common/layout.css" />
	<link rel="stylesheet" href="/css/myDiarystyle.css" />
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

	<h2>게시글이 잘못되었습니다.</h2>
	<button type="button" onclick="location.href='./list.do';">
		다이어리 목록 가기
	</button>
		
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>