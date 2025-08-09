<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 스프링 시큐리티에서 제공하는 taglib을 사용하기 위한 지시어 -->
<%@taglib uri="http://www.springframework.org/security/tags" prefix="s" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link rel="stylesheet" href="/css/common/layout.css" />
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

	<h2>Admin 영역</h2>
	ADMIN권한만 접근할 수 있습니다.<br>
	
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>