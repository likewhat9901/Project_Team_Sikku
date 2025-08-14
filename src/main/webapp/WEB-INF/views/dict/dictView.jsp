<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link rel="stylesheet" href="/css/common/layout.css" />
	<link rel="stylesheet" href="/css/dictView.css">
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
    
<div class="detail-section">
    <h1 class="detail-title">식물도감 상세정보</h1>
    <a class="list-btn" href="/dict/list.do">목록</a>
    
    <div class="plant-card">
        <div class="plant-image">
            <img alt="" src="/images/dict/${plant.imgpath}" />
        </div>
        <div class="plant-info">
        	<div class="plant-profile">
        		<div class="category">🌿 분류: ${plant.category }</div>
	            <h2 class="name">
	                ${plant.name} <span class="subtitle">${plant.engname}</span>
	            </h2>
	            <h3>🧾 개요</h3>
	            <p class="description-1">${plant.summary}</p>
	            
	            <h4>📌 기타 정보</h4>
	     		<p class="description-2">${plant.note}</p>
        	</div>
            
            <div class="info-grid">
            	<h3>🌱 생육 정보</h3>
            	<div class="item-container">
	                <div class="info-item">
	                    <span class="icon">🏠</span>
	                    <span class="label">생육 시기:</span>
	                    <span class="value">${plant.growseason}</span>
	                </div>
	                <div class="info-item">
	                    <span class="icon">📅</span>
	                    <span class="label">개화 시기:</span>
	                    <span class="value">
	                    	<c:choose>
							    <c:when test="${not empty plant.bloomingseason}">
							        ${plant.bloomingseason}
							    </c:when>
							    <c:otherwise>
							        없음
							    </c:otherwise>
							</c:choose>
	                    </span>
	                </div>
            	</div>
                <div class="item-container">
	                <div class="info-item">
	                    <span class="icon">💧</span>
	                    <span class="label">재배 습도:</span>
	                    <span class="value">${plant.humidity}</span>
	                </div>
	                <div class="info-item">
	                    <span class="icon">🌡️</span>
	                    <span class="label">재배 온도:</span>
	                    <span class="value">${plant.temperature}</span>
	                </div>
                </div>
                <div class="info-item">
                    <span class="icon">☀️</span>
                    <span class="label">햇빛 환경:</span>
                    <span class="value">${plant.sunlight}</span>
                </div>
                <div class="info-item">
                    <span class="icon">💦</span>
                    <span class="label">물 주기:</span>
                    <span class="value">${plant.water}</span>
                </div>
                <div class="info-item">
                    <span class="icon">🏥</span>
                    <span class="label">병충해:</span>
                    <span class="value">${plant.disease}</span>
                </div>
            </div>
        </div>
    </div>
    
    <div class="dict-nav-bottom">
		<a class="prev-btn" href="/dict/view.do?plantidx=${prevDict}">← 이전</a>
	  	<a class="next-btn" href="/dict/view.do?plantidx=${nextDict}">다음 →</a>
	</div>
</div>


</body>
</html>