<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
body.plant_detail_page {
  font-family: 'Noto Sans KR', Arial, sans-serif;
  background-color: #fefefe;
  color: #333;
  line-height: 1.6;
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.main_header {
    background: white;
    padding: 15px 30px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.main_logo {
    font-size: 18px;
    font-weight: 600;
    color: #333;
}

.main_nav {
    display: flex;
    gap: 30px;
}

.main_nav a {
    text-decoration: none;
    color: #666;
    font-weight: 500;
    padding: 8px 16px;
    border-radius: 6px;
    transition: background-color 0.3s;
}

.main_nav a:hover {
    background-color: #f0f0f0;
    color: #333;
}

.main_nav .active {
    background-color: #333;
    color: white;
}

.detail_container {
  max-width: 800px;
  margin: auto;
  background: white;
  border: 1px solid #ccc;
  border-radius: 12px;
  padding: 40px;
  box-shadow: 0 4px 8px rgba(0,0,0,0.05);
}

.plant_title {
  font-size: 32px;
  font-weight: bold;
  border-bottom: 2px solid #ddd;
  padding-bottom: 10px;
  margin-bottom: 20px;
}

.plant_scientific {
  font-size: 20px;
  color: #666;
}

.plant_image_section {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
  gap: 20px;
}

.plant_img {
  width: 200px;
  height: auto;
  border-radius: 8px;
  border: 1px solid #ccc;
}

.plant_category {
  font-size: 18px;
  background-color: #f0f0f0;
  padding: 10px 15px;
  border-radius: 8px;
}

.plant_info_section h2 {
  margin-top: 30px;
  font-size: 24px;
  color: #2b4c7e;
  border-bottom: 1px solid #ddd;
  padding-bottom: 5px;
}

.plant_info_section p,
.plant_info_section ul {
  margin-top: 10px;
  margin-left: 10px;
}

.plant_info_section ul {
  list-style-type: disc;
}
</style>
</head>
<body class="plant_detail_page">
	<!-- 헤더 -->
    <header class="main_header">
        <div class="main_logo">Site name</div>
        <nav class="main_nav">
            <a href="/">메인</a>
            <a href="/freeBoardList.do">커뮤니티</a>
            <a href="#">다이어리</a>
            <a href="/info.do" class="active">식물도감</a>
        </nav>
    </header>
    
  	<div class="detail_container">
    <h1 class="plant_title">🌻 해바라기 <span class="plant_scientific">(Helianthus annuus)</span></h1>
    
    <div class="plant_image_section">
      <img src="sunflower.jpg" alt="해바라기 이미지" class="plant_img">
      <div class="plant_category">📌 분류: <strong>관상용</strong></div>
    </div>

    <div class="plant_info_section">
      <h2>🧾 개요</h2>
      <p>해바라기는 국화과의 식물로, 해를 따라 움직이는 독특한 특징을 가지고 있다. 씨앗은 간식으로 먹거나 기름을 짜는 데 사용된다.</p>

      <h2>🌱 생육 환경</h2>
      <ul>
        <li><strong>햇빛:</strong> 햇빛을 매우 좋아함 (양지)</li>
        <li><strong>물 주기:</strong> 흙이 마르면 충분히</li>
        <li><strong>온도:</strong> 15~30℃</li>
      </ul>

      <h2>📌 기타 정보</h2>
      <p>해바라기는 여름에 꽃을 피우며, 꽃말은 ‘존경’, ‘기다림’이다.</p>
    </div>
  </div>
</body>
</html>