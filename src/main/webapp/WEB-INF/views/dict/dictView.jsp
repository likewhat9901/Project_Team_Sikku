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
      <img src="./images/${row.ofile }" alt="식물 이미지" class="plant_img">
      <div class="plant_category">📌 분류: <strong>관상용</strong></div>
    </div>

    <div class="plant_info_section">
      <h2>🧾 개요</h2>
      <p>${plant.description }</p>

      <h2>🌱 생육 환경</h2>
      <ul>
        <li><strong>생육시기:</strong> ${plant.grow_season }</li>
        <li><strong>개화시기:</strong> ${plant.blooming_season }</li>
        <li><strong>햇빛:</strong> ${plant.sunlight }</li>
        <li><strong>적정 습도:</strong> ${plant.humidity }</li>
        <li><strong>적정 온도:</strong> ${plant.temperature_min }℃ ~ ${plant.temperature_max }℃</li>
      </ul>

      <h2>📌 기타 정보</h2>
      <p>(아직 빈칸)</p>
    </div>
</div>

<link href="http://api.nongsaro.go.kr/css/api.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="http://api.nongsaro.go.kr/js/framework.js"></script>	
<script type="text/javascript" src="http://api.nongsaro.go.kr/js/openapi_nongsaro.js"></script>
	
<script type="text/javascript">
nongsaroOpenApiRequest.apiKey = "발급받은인증키";
nongsaroOpenApiRequest.serviceName = "varietyInfo";
nongsaroOpenApiRequest.operationName = "insttList";
nongsaroOpenApiRequest.htmlArea="nongsaroApiLoadingAreaInstt";
nongsaroOpenApiRequest.callback = "http://yourDomain/ajax_local_callback.jsp";
</script>
</head>

<div id="nongsaroApiLoadingAreaInstt"></div><!-- 기관명 목록 HTML 로딩 영역 -->
<div id="nongsaroApiLoadingArea"></div><!-- 메인카테고리 HTML 로딩 영역 -->
<div id="nongsaroApiLoadingArea1"></div><!-- 미들카테고리 HTML 로딩 영역 -->
<div id="nongsaroApiLoadingArea3"></div><!-- 품종 리스트 HTML 로딩 영역 -->
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>