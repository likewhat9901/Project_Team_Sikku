<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link rel="stylesheet" href="/css/common/layout.css" />
	<link rel="stylesheet" href="/css/myDiaryView.css" />
</head>
<script>
function deletePost(idx){
    var confirmed = confirm("정말로 삭제하겠습니까?"); 
    if (confirmed) {
        var form = document.writeFrm;      
        form.method = "post";  
        form.action = "delete.do";
        form.submit();  
    }
}
</script>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

	<!-- 아래 form은 확인용. hidden으로 멤버 아이디 확인 -->
	<form name="writeFrm">
		<input type="hidden" name="diaryIdx" value="${myDiaryDTO.diaryIdx }" />
	</form>
	<!-- View 페이지 HTML -->
	<div class="mydiary-container">
		<!-- 상단 메뉴는 동일하게 유지 -->
		<div class="mydiary-top-wrapper">
			<div class="mydiary-top">
				<nav class="mydiary-nav">
					<a href="/mydiary/calendar.do" class="mydiary-calendar-btn">캘린더</a>
				</nav>
				<h2 class="mydiary-title">나만의 식물 꾸미기 (보기)</h2>
				<button type="button" class="mydiary-list-btn"
					onclick="location.href='./list.do';">목록보기</button>
			</div>
		</div>

		<!-- View 카드 (기존 카드 스타일 재활용) -->
		<div class="mydiary-view-single-card">
			<div class="mydiary-card">
				<!-- 카드 헤더 (날씨 영역) -->
				<div class="mydiary-card-header">
					<div class="mydiary-card-number">🌱</div>
					<div class="mydiary-date">${ myDiaryDTO.postdate }</div>
				</div>


				<!-- 카드 내용 (줄글 영역) -->
				<div class="mydiary-card-content">
					<!-- 이미지 박스 -->
					<div class="mydiary-view-image-box">
						<c:if test="${not empty myDiaryDTO.sfile}">
							<img src="/uploads/mydiary/${myDiaryDTO.sfile}" class="mydiary-main-image"
								alt="식물 이미지" />
						</c:if>
						<c:if test="${empty myDiaryDTO.sfile}">
							<div class="mydiary-no-image-large">이미지 없음</div>
						</c:if>
					</div>
					<div class="mydiary-view-lines">

						<!-- 데이터 라인 -->
						<div class="mydiary-view-data-line">
							<div class="mydiary-view-data-item temp">
								<span class="mydiary-view-data-label">온도</span>
								<span class="mydiary-view-data-value">${ myDiaryDTO.temperature }°C</span>
							</div>
							<div class="mydiary-view-data-item humidity">
								<span class="mydiary-view-data-label">습도</span>
								<span class="mydiary-view-data-value">${ myDiaryDTO.humidity }%</span>
							</div>
							<div class="mydiary-view-data-item sunlight">
								<span class="mydiary-view-data-label">일조량</span>
								<span class="mydiary-view-data-value">${ myDiaryDTO.sunlight }lux</span>
							</div>
							<div class="mydiary-view-data-item height">
								<span class="mydiary-view-data-label">키</span>
								<span class="mydiary-view-data-value">${ myDiaryDTO.height }cm</span>
							</div>
							<div class="mydiary-view-data-item fruit">
								<span class="mydiary-view-data-label">열매</span>
								<span class="mydiary-view-data-value">${ myDiaryDTO.fruit }개</span>
							</div>
						</div>

						<div class="mydiary-view-line-title">📝 관찰 내용</div>
						<div class="mydiary-view-line-description">${ myDiaryDTO.description }</div>

						<!-- 버튼 영역 -->
						<div class="mydiary-view-buttons">
							<button type="button" class="mydiary-view-btn edit"
								onclick="location.href='./edit.do?diaryIdx=${ param.diaryIdx }';">
								수정하기</button>
							<button type="button" class="mydiary-view-btn delete"
								onclick="deletePost(${ param.diaryIdx });">삭제하기</button>
							<button type="button" class="mydiary-view-btn list"
								onclick="location.href='./list.do';">목록으로</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>

</html>