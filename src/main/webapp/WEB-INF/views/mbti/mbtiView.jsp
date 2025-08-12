<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>그린다이어리(예명)</title>
    <link rel="stylesheet" href="/css/common/layout.css" />
    <link rel="stylesheet" href="/css/mbtiView.css">
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

    
<!-- MBTI Section -->
<div class="mbti-section">
	<h2 class="title">${MBTI.name } 추천식물</h2>
	<div class="mbti-container">
	    <!-- 왼쪽 이미지 -->
	    <div class="mbti-img">
	        <img src="/images/mbti/${MBTI.imgfile}" alt="${MBTI.name}">
	    </div>
	
	    <!-- 오른쪽 내용 -->
	    <div class="mbti-info">
	        <div class="plant-name">
	            ${MBTI.indoor}
	        </div>
	        <div class="plant-desc">
	            ${MBTI.inreason}
	        </div>
	    </div>
	</div>
</div>
    
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>