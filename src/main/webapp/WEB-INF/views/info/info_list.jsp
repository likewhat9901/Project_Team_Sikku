<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/info_list.css">
<link rel="stylesheet" href="/css/main.css">
</head>
<body class="info_plant">
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
    
	<div class="container">

        <!-- 식물 그리드 -->
        <div class="plant_grid">
            <!-- 샘플 식물 데이터 -->
<c:forEach items="${ plants }" var="row" varStatus="loop">
            <a href="/plants?plant_idx=${row.plantidx }" class="plant_card">
                <div class="plant_image">
                    <img src="./images/${row.ofile }" alt="식물사진">
                </div>
                <div class="plant_name">${row.name }</div>
                <div class="plant_scientific">${row.sfile}</div>
                <div class="plant_category">관상용</div>
            </a>
</c:forEach>
        </div>
    </div>
</body>
</html>