<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>그린다이어리(예명)</title>
    <link rel="stylesheet" href="/css/common/common.css">
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="main_container">
   	<jsp:include page="${contentPage}" />
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>