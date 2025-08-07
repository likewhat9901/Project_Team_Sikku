<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>식꾸</title>
<link rel="stylesheet" href="/css/myDiarystyle.css" />
<link rel="stylesheet" href="/css/main.css">
</head>
<body>
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
			<!-- 로그인 시 -->
			<sec:authorize access="isAuthenticated()">
				<span class="mypage-link"
					onclick="location.href='/member/mypage.do'">마이페이지</span>
				<span class="logout-link" onclick="location.href='/myLogout.do'">로그아웃</span>
				<div class="user-icon">👤</div>
			</sec:authorize>

		</div>
	</div>

	<!-- 다이어리 목록 Top -->
	<div class="mydiary-top-wrapper"></div>
	<div class="mydiary-top">
		<nav>
			<a href="/mycalendar/calendar.html">캘린더</a>
		</nav>
		<h2 align="center">나만의 식물 꾸미기</h2>
		<button type="button" onclick="location.href='./write.do';">글쓰기</button>
	</div>
	<!-- 목록 테이블 -->
	<table border="1" width="90%">
		<tr>
			<th width="10%">번호</th>
			<th width="*">이미지</th>
			<th width="15%">설명</th>
			<th width="10%">온도</th>
			<th width="10%">습도</th>
			<th width="10%">일조량</th>
			<th width="15%">작성일</th>
		</tr>
		<c:choose>
			<c:when test="${ empty lists }">
				<tr>
					<td colspan="5" align="center">등록된 게시물이 없습니다^^*</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${ lists }" var="row" varStatus="loop">
					<tr align="center">
						<td>
							<!-- 게시물의갯수, 페이지번호, 페이지사이즈를 통해 가상번호를 계산해서
            출력한다. --> ${ maps.totalCount - 
                (((maps.pageNum-1) * maps.pageSize)	+ loop.index)}
						</td>
						<td style="text-align: center;"><a
							href="./view.do?diaryIdx=${ row.diaryIdx }"> <c:if
									test="${not empty row.sfile}">
									<img src="/uploads/${row.sfile}" class="mydiary-thumbnail" />
								</c:if> <c:if test="${empty row.sfile}">
									<span>이미지 없음</span>
								</c:if></a></td>
						<td>${ row.description }</td>
						<td>${ row.temperature }</td>
						<td>${ row.humidity}</td>
						<td>${ row.sunlight}</td>
						<td>${ row.postdate }</td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>

	<!-- 하단 메뉴(바로가기, 글쓰기) -->
	<table border="1" width="90%">
		<tr align="center">
			<td>${ pagingImg }</td>
		</tr>
	</table>
</body>
</html>
