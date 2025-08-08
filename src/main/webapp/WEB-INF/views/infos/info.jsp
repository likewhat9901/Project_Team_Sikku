<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/info.css">
<style type="text/css">
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
</style>
</head>
<body class="info_plant">
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
    
	<div class="container">

        <!-- 식물 그리드 -->
        <div class="plant_grid">
            <!-- 샘플 식물 데이터 -->
            <a href="/plants/1" class="plant_card">
                <div class="plant_image">
                    식물 사진
                </div>
                <div class="plant_name">장미</div>
                <div class="plant_scientific">Rosa rubiginosa</div>
                <div class="plant_category">관상용</div>
            </a>

            <a href="/plants/2" class="plant_card">
                <div class="plant_image">
                    식물 정보
                </div>
                <div class="plant_name">선인장</div>
                <div class="plant_scientific">Cactaceae</div>
                <div class="plant_category">다육식물</div>
            </a>

            <a href="/plants/3" class="plant_card">
                <div class="plant_image">
                    식물 사진
                </div>
                <div class="plant_name">라벤더</div>
                <div class="plant_scientific">Lavandula</div>
                <div class="plant_category">허브</div>
            </a>

            <a href="/plants/4" class="plant_card">
                <div class="plant_image">
                    식물 정보
                </div>
                <div class="plant_name">민들레</div>
                <div class="plant_scientific">Taraxacum officinale</div>
                <div class="plant_category">야생화</div>
            </a>

            <a href="/plants/5" class="plant_card">
                <div class="plant_image">
                    식물 사진
                </div>
                <div class="plant_name">바질</div>
                <div class="plant_scientific">Ocimum basilicum</div>
                <div class="plant_category">허브</div>
            </a>

            <a href="/plants/6" class="plant_card">
                <div class="plant_image">
                    식물 정보
                </div>
                <div class="plant_name">해바라기</div>
                <div class="plant_scientific">Helianthus annuus</div>
                <div class="plant_category">관상용</div>
            </a>
        </div>
    </div>
</body>
</html>