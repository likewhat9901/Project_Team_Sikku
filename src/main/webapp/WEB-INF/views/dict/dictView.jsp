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
<body class="plant_detail_page">
<%@ include file="/WEB-INF/views/common/header.jsp" %>
    
<!-- 디테일 컨테이너 -->
<div class="detail_container">
    <h1 class="plant_title">${plant.name } <span class="plant_scientific">(식물 영어이름)</span></h1>
    
    <div class="plant_image_section">
      <img src="./images/${row.imgpath }" alt="식물 이미지" class="plant_img">
      <div class="plant_category">📌 분류: <strong>관상용</strong></div>
    </div>

    <div class="plant_info_section">
      <h2>🧾 개요</h2>
      <p>${plant.summary }</p>

      <h2>🌱 생육 환경</h2>
      <ul>
        <li><strong>생육시기:</strong> ${plant.growseason }</li>
        <li><strong>개화시기:</strong> ${plant.bloomingseason }</li>
        <li><strong>햇빛:</strong> ${plant.sunlight }</li>
        <li><strong>적정 습도:</strong> ${plant.humidity }</li>
        <li><strong>적정 온도:</strong> ${plant.temperaturemin }℃ ~ ${plant.temperaturemax }℃</li>
      </ul>

      <h2>📌 기타 정보</h2>
      <p>(아직 빈칸)</p>
    </div>
</div>

<div class="design-section">
    <h1 class="design-title">식물도감 상세정보</h1>
    <div class="plant-card-1">
        <div class="plant-image-1">
            🌿 식물 이미지
        </div>
        <div class="plant-info-1">
        	<div class="plant-profile">
	            <h2 class="plant-name-1">
	                바질 <span class="subtitle">(식물 영어이름)</span>
	            </h2>
	            <h3>🧾 개요</h3>
	            <p class="plant-description-1">허브의 일종으로 달 빨간 줄잎 흙과 따뜻한 온도를 선호</p>
	            
	            <h4>📌 기타 정보</h4>
	     		<p class="plant-description-2">(아직 빈칸)</p>
        	</div>
            
            <div class="info-grid-1">
            	<h3>🌱 생육 정보</h3>
                <div class="info-item-1">
                    <span class="info-icon-1">☀️</span>
                    <span class="info-label-1">생육 시기:</span>
                    <span class="info-value-1">여름</span>
                </div>
                <div class="info-item-1">
                    <span class="info-icon-1">📅</span>
                    <span class="info-label-1">개화 시기:</span>
                    <span class="info-value-1">7~8월</span>
                </div>
                <div class="info-item-1">
                    <span class="info-icon-1">🏠</span>
                    <span class="info-label-1">햇빛 환경:</span>
                    <span class="info-value-1">반양지~양빛 많은 곳</span>
                </div>
                <div class="info-item-1">
                    <span class="info-icon-1">💧</span>
                    <span class="info-label-1">재배 습도:</span>
                    <span class="info-value-1">높음</span>
                </div>
                <div class="info-item-1">
                    <span class="info-icon-1">🌡️</span>
                    <span class="info-label-1">재배 온도:</span>
                    <span class="info-value-1">18°C ~ 30°C</span>
                </div>
            </div>
        </div>
    </div>
</div>



</body>
</html>