<!-- /WEB-INF/views/main/member.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>SpringBoot</title>
	<link rel="stylesheet" href="/css/common/layout.css" />
	<link rel="stylesheet" href="/css/member.css">
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%@ include file="/WEB-INF/views/common/features/weather.jsp" %>

<!-- Dashboard Section -->
<div class="dashboard">
	<h2 class="dashboard-title">내 식물 상태창</h2>
<c:forEach items="${ plants }" var="row" varStatus="loop">
	<div class="plant-container">
		<div class="plant-card">
			<div class="plant-info">
			    <div class="plant-image">
			        <img src="/images/status/${row.ofile }" alt="식물사진">
			    </div>
			    <div class="plant-info-box">
			        <p class="plant-name">식물명 : ${ row.name }</p>
			        <p class="plant-description">${ row.description }</p>
			    </div>
			</div>
			<div class="navigation-btn prev-btn">&#8249;</div>
			<div class="plant-status">
			    <div class="status-header">식물 상태창 내용</div>
			    <div class="status-content">
			        <!-- 상태 정보가 들어갈 공간 -->
			    </div>
			</div>
			<div class="navigation-btn next-btn">&#8250;</div>
		</div>
	</div>
</c:forEach>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>