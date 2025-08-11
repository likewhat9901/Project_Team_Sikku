<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>식꾸</title>
	<link rel="stylesheet" href="/css/common/layout.css" />
	<link rel="stylesheet" href="/css/myDiarystyle.css" />
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

		<!-- 다이어리 목록 Top -->
		<div class="mydiary-container">
			<div class="mydiary-top-wrapper">
				<div class="mydiary-top">
					<nav class="mydiary-nav">
						<a href="/mydiary/calendar.do" class="mydiary-calendar-btn">캘린더</a>
					</nav>
					<h2 class="mydiary-title">나만의 식물 꾸미기</h2>
					<button type="button" class="mydiary-write-btn"
						onclick="location.href='./write.do';">글쓰기!!</button>
				</div>
			</div>

			<!-- 다이어리 카드 그리드 -->
			<c:choose>
				<c:when test="${ empty lists }">
					<div class="mydiary-empty-state">등록된 게시물이 없습니다^^*</div>
				</c:when>
				<c:otherwise>
					<div class="mydiary-grid">
						<c:forEach items="${ lists }" var="row" varStatus="loop">
							<div class="mydiary-card">
								<!-- 카드 헤더 (날씨 영역) -->
								<div class="mydiary-card-header">
									<div class="mydiary-card-number">${ maps.totalCount - (((maps.pageNum-1) * maps.pageSize) + loop.index)}
									</div>
									<div class="mydiary-weather-icons">
										<span>☀️</span> <span>☁️</span> <span>🌈</span> <span>🌡️</span>
									</div>
									<div class="mydiary-date">${ row.postdate }</div>
								</div>

								<!-- 이미지 박스 -->
								<div class="mydiary-image-box"
									onclick="location.href='./view.do?diaryIdx=${ row.diaryIdx }'">
									<c:if test="${not empty row.sfile}">
										<img src="/uploads/${row.sfile}" class="mydiary-main-image"
											alt="식물 이미지" />
									</c:if>
									<c:if test="${empty row.sfile}">
										<div class="mydiary-no-image-large">이미지 없음</div>
									</c:if>
								</div>

								<!-- 카드 내용 (줄글 영역) -->
								<div class="mydiary-card-content">
									<div class="mydiary-lines">
										<div class="mydiary-line">오늘의 식물 관찰 기록</div>
										<div class="mydiary-line">${ row.description }</div>
										<div class="mydiary-line">
											<span class="mydiary-data-item temp">${ row.temperature }°C</span>
											<span class="mydiary-data-item humidity">${ row.humidity }%</span>
											<span class="mydiary-data-item sunlight">${ row.sunlight }lux</span>
										</div>
										<div class="mydiary-empty-line"></div>
										<div class="mydiary-empty-line"></div>
										<div class="mydiary-empty-line"></div>
									</div>
								</div>
							</div>
						</c:forEach>
					</div>
				</c:otherwise>
			</c:choose>

			<!-- 페이징 -->
			<div class="mydiary-paging-wrapper">
				<div class="mydiary-paging-container">${ pagingImg }</div>
			</div>

		</div>
	</div>
	
<%@ include file="/WEB-INF/views/common/footer.jsp"%>
</body>
</html>
