<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link rel="stylesheet" href="/css/common/layout.css" />
	<link rel="stylesheet" href="/css/myDiarystyle.css" />
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

	<!-- 한이 작업 -->
	<div class="mydiary-container">
		<!-- 상단 메뉴 -->
		<div class="mydiary-top-wrapper">
			<div class="mydiary-top">
				<nav class="mydiary-nav">
					<button class="mydiary-calendar-btn"
						onclick="location.href='./calendar.do';">캘린더</button>
				</nav>
				<h1 class="mydiary-title">식물 다이어리 수정</h1>
				<button type="button" class="mydiary-write-btn list"
                                onclick="location.href='${contextPath}/mydiary/list.do';">목록으로</button>
				<div></div>
			</div>
		</div>

		<!-- 수정 폼 -->
		<div class="mydiary-write-form">
			<div class="mydiary-write-card">
				<div class="mydiary-write-header">
					<h2>다이어리 수정하기</h2>
				</div>

				<div class="mydiary-write-content">
					<form name="writeFrm" method="post" enctype="multipart/form-data"
						action="./edit.do" onsubmit="return validateForm(this);">
						<input type="hidden" name="diaryIdx"
							value="${myDiaryDTO.diaryIdx}" />

						<!-- 식물명 (라디오: 선택 옵션, 기본값 미선택) -->
<div class="mydiary-write-row">
  <label class="mydiary-write-label">식물명</label>
  <div class="mydiary-write-input-area">
    <div class="mydiary-radio-group" role="radiogroup" aria-label="식물명">
      <c:forEach var="p" items="${plants}">
        <label class="mydiary-radio">
          <input type="radio"
                 name="plantidx"
                 value="${p.plantidx}"
                 <c:if test="${myDiaryDTO.plantidx == p.plantidx}">checked</c:if>>
          <span>${fn:escapeXml(p.name)}</span>
        </label>
      </c:forEach>
      <!-- 선택 해제(미선택으로 바꾸기) -->
      <button type="button" class="mydiary-radio-clear"
              onclick="document.querySelectorAll('input[name=plantidx]').forEach(r=>r.checked=false)">
        선택 해제
      </button>
    </div>
    <div class="mydiary-write-help">선택 시 해당 식물 기준 예측에 사용됩니다. (미선택 가능)</div>
  </div>
</div>

						<div class="mydiary-write-row">
							<label class="mydiary-write-label"> 온도 <span
								class="mydiary-write-required">*</span>
							</label>
							<div class="mydiary-write-input-area">
								<input type="text" name="temperature"
									class="mydiary-write-input" value="${myDiaryDTO.temperature}"
									placeholder="온도를 입력하세요" />
								<div class="mydiary-write-help">예: 25°C</div>
							</div>
						</div>

						<div class="mydiary-write-row">
							<label class="mydiary-write-label"> 습도 <span
								class="mydiary-write-required">*</span>
							</label>
							<div class="mydiary-write-input-area">
								<input type="text" name="humidity" class="mydiary-write-input"
									value="${myDiaryDTO.humidity}" placeholder="습도를 입력하세요" />
								<div class="mydiary-write-help">예: 60%</div>
							</div>
						</div>

						<div class="mydiary-write-row">
							<label class="mydiary-write-label"> 일조량 <span
								class="mydiary-write-required">*</span>
							</label>
							<div class="mydiary-write-input-area">
								<input type="text" name="sunlight" class="mydiary-write-input"
									value="${myDiaryDTO.sunlight}" placeholder="일조량을 입력하세요" />
								<div class="mydiary-write-help">예: 8시간</div>
							</div>
						</div>

						<div class="mydiary-write-row">
							<label class="mydiary-write-label"> 키 <span
								class="mydiary-write-required">*</span>
							</label>
							<div class="mydiary-write-input-area">
								<input type="text" name="height" class="mydiary-write-input"
									value="${myDiaryDTO.height}" placeholder="키를 입력하세요" />
								<div class="mydiary-write-help">예: 15cm</div>
							</div>
						</div>

						<div class="mydiary-write-row">
							<label class="mydiary-write-label"> 열매 개수 </label>
							<div class="mydiary-write-input-area">
								<input type="text" name="fruit" class="mydiary-write-input"
									value="${myDiaryDTO.fruit}" placeholder="열매 개수를 입력하세요" />
								<div class="mydiary-write-help">예: 3개</div>
							</div>
						</div>

						<div class="mydiary-write-row">
							<label class="mydiary-write-label"> 설명 </label>
							<div class="mydiary-write-input-area">
								<textarea name="description" class="mydiary-write-textarea"
									placeholder="식물의 상태나 특이사항을 자세히 적어주세요">${myDiaryDTO.description}</textarea>
							</div>
						</div>

						<div class="mydiary-write-row">
							<label class="mydiary-write-label"> 이미지 </label>
							<div class="mydiary-write-input-area">
								<input type="file" name="ofile" class="mydiary-write-file"
									accept="image/*" />
								<div class="mydiary-write-help">식물 사진을 업로드해주세요 (선택사항)</div>
							</div>
						</div>

						<div class="mydiary-write-buttons">
							<button type="submit" class="mydiary-write-btn submit">수정
								완료</button>
							<button type="reset" class="mydiary-write-btn reset">초기화</button>
							<button type="button" class="mydiary-write-btn list"
								onclick="location.href='./list.do';">목록 바로가기</button>

							<div class="mydiary-write-notice">💡 모든 정보를 정확히 입력한 후 수정 완료
								버튼을 클릭해주세요.</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>

</html>