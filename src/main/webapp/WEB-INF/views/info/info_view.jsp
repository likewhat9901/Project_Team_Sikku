<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/info_view.css">
<link rel="stylesheet" href="/css/main.css">
</head>
<body class="plant_detail_page">
	<!-- Header Section -->
	<div class="header">
		<div class="header-content">
			<div class="logo">
				<span class="home-btn" onclick="location.href='/'">로고</span> <span
					class="site-name">그린다이어리(예명)</span>
			</div>
			<div class="nav-icons">
				<div class="nav-item">
					<div class="icon-box"></div>
					<span>궁금해?</span>
				</div>
				<div class="nav-item" onclick="location.href='/freeBoardList.do'">
					<div class="icon-box"></div>
					<span>커뮤니티</span>
				</div>
				<div class="nav-item" onclick="location.href='/mydiary/list.do'">
					<div class="icon-box"></div>
					<span>다이어리</span>
				</div>
				<div class="nav-item" onclick="location.href='/info.do'">
					<div class="icon-box"></div>
					<span>식물도감</span>
				</div>
				<div class="nav-item" onclick="location.href='/mbti.do'">
					<div class="icon-box"></div>
					<span>MBTI</span>
				</div>
			</div>
			<div class="user-section">
				<span class="login-link" onclick="location.href='/myLogin.do'">로그인</span>
				<span class="register-link" onclick="location.href='/signup.do'">회원가입</span>
				<div class="user-icon">👤</div>
			</div>
		</div>
	</div>

	<!-- 디테일 컨테이너 -->
	<div class="detail_container">
		<h1 class="plant_title">${plant.name }
			<span class="plant_scientific">(식물 영어이름)</span>
		</h1>

		<div class="plant_image_section">
			<img src="./images/${row.ofile }" alt="식물 이미지" class="plant_img">
			<div class="plant_category">
				📌 분류: <strong>관상용</strong>
			</div>
		</div>

		<div class="plant_info_section">
			<h2>🧾 개요</h2>
			<p>${plant.description }</p>

			<h2>🌱 생육 환경</h2>
			<ul>
				<li><strong>생육시기:</strong> ${plant.growseason }</li>
				<li><strong>개화시기:</strong> ${plant.bloomingseason }</li>
				<li><strong>햇빛:</strong> ${plant.sunlight }</li>
				<li><strong>적정 습도:</strong> ${plant.humidity }</li>
				<li><strong>적정 온도:</strong> ${plant.temperaturemin }℃ ~
					${plant.temperaturemax }℃</li>
			</ul>

			<h2>📌 기타 정보</h2>
			<p>(아직 빈칸)</p>
		</div>
	</div>
</body>
</html>