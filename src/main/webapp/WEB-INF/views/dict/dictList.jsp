<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link rel="stylesheet" href="/css/common/layout.css" />
	<link rel="stylesheet" href="/css/dictList.css">
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>    

	<!-- 식물 그리드 -->
	<div class="plant_grid">
	    <!-- 샘플 식물 데이터 -->
<c:forEach items="${ plants }" var="row" varStatus="loop">
	    <a href="./view.do?plantidx=${row.plantidx }" class="plant_card">
	        <div class="plant_image">
	            <img src="/images/dict/${row.ofile }" alt="식물사진">
	        </div>
	        <div class="plant_name">${row.name }</div>
	        <div class="plant_scientific">${row.sfile}</div>
	        <div class="plant_category">관상용</div>
	    </a>
</c:forEach>
	</div>
	
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>