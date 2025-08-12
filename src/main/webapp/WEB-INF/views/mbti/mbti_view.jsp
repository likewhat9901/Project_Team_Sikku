<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>그린다이어리(예명)</title>
    <style type="text/css">
/* 전체 레이아웃 */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    background-color: #f5f5f5;
}

/* Header Section - 페이지 상단에 고정, 양쪽 여백 없음 */
.header {
    background: linear-gradient(135deg, #90EE90, #32CD32);
    width: 100%;
    padding: 20px 0;
}

.header-content {
    width: 100%;
    margin: 0 auto;
    padding: 0 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.header-content .logo {
    display: flex;
    align-items: center;
    gap: 15px;
}

.header-content .logo .home-btn {
    background: rgba(255, 255, 255, 0.9);
    padding: 8px 12px;
    border-radius: 8px;
    font-size: 14px;
    color: #333;
    cursor: pointer;
}

.header-content .logo .site-name {
    font-size: 20px;
    font-weight: bold;
    color: white;
}

.header-content .nav-icons {
    display: flex;
    gap: 40px;
}

.header-content .nav-icons .nav-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
    cursor: pointer;
    transition: transform 0.2s;
}

.header-content .nav-icons .nav-item:hover {
    transform: translateY(-2px);
}

.icon-box {
    background: white;
    width: 50px;
    height: 50px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 3px 12px rgba(0, 0, 0, 0.15);
}

.nav-item span {
    font-size: 14px;
    color: white;
    font-weight: 500;
}

.user-section {
    display: flex;
    align-items: center;
    gap: 20px;
}

.login-link, .register-link {
    color: white;
    text-decoration: none;
    font-size: 16px;
    cursor: pointer;
    transition: opacity 0.2s;
}

.login-link:hover, .register-link:hover {
    opacity: 0.8;
}

.user-icon {
    background: white;
    width: 40px;
    height: 40px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
    cursor: pointer;
    box-shadow: 0 3px 12px rgba(0, 0, 0, 0.15);
}

.main_container {
    max-width: 90%;
    margin: 0 auto;
    padding: 100px;
}

.mbti-section {
	padding: 50px 80px;
}

.mbti-section .title {
	margin-bottom: 50px;
}

    </style>
</head>
<body>
<!-- Header Section -->
    <div class="header">
        <div class="header-content">
            <div class="logo">
                <span class="home-btn" onclick="location.href='/'">로고</span>
                <span class="site-name">그린다이어리(예명)</span>
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
                <div class="nav-item" onclick="location.href='/'">
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
                <span class="login-link">로그인</span>
                <span class="register-link">회원가입</span>
                <div class="user-icon">👤</div>
            </div>
        </div>
    </div>

<!-- Main Container -->
    <div class="main-container">
    
<!-- MBTI Section -->
        <div class="mbti-section">
	      	<h2 class="title">MBTI뷰 페이지</h2>
	        <div class="mbti-container">
        	
			</div>
        </div>
    </div>
</body>
</html>