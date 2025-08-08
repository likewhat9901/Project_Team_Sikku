<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>그린다이어리(예명)</title>
    <link rel="stylesheet" href="/css/common/layout.css" />
    <link rel="stylesheet" href="/css/mbtiList.css">
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<!-- Main Container -->
    <div class="main-container">
    
<!-- MBTI Section -->
        <div class="mbti-section">
	      	<h2 class="title">MBTI별 추천 식물</h2>
	        <div class="mbti-container">
        	
<c:forEach items="${ MBTIs }" var="row" varStatus="loop">
	            <div class="card">
	            	<a href="./view.do?idx=${row.mbtiIdx }">
		                <div class="image">
		                    <img src="/images/mbti/${row.imgfile }" alt="MBTI사진">
		                </div>
		            </a>
	            </div>
</c:forEach>
			</div>
        </div>
    </div>
    
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>