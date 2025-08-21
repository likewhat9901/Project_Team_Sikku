<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>식꾸</title>
<link rel="stylesheet" href="/css/common/layout.css" />
<link rel="stylesheet" href="/css/myDiaryWrite.css" />
</head>
<script>
function validateForm(fm) {
    // 온도 유효성 검사
    if(fm.temperature.value == '') {
        alert("온도를 입력하세요.");
        fm.temperature.focus();
        return false;
    }
    
    var temperature = parseFloat(fm.temperature.value);
    if(isNaN(temperature)) {
        alert("온도는 숫자로 입력하세요.");
        fm.temperature.focus();
        return false;
    }
    
    if(temperature < -99.99 || temperature > 999.99) {
        alert("온도는 -99.99 ~ 999.99 사이의 값을 입력하세요.");
        fm.temperature.focus();
        return false;
    }
    
    // 습도 유효성 검사
    if(fm.humidity.value == '') {
        alert("습도를 입력하세요.");
        fm.humidity.focus();
        return false;
    }
    
    var humidity = parseFloat(fm.humidity.value);
    if(isNaN(humidity)) {
        alert("습도는 숫자로 입력하세요.");
        fm.humidity.focus();
        return false;
    }
    
    if(humidity < 0 || humidity > 100) {
        alert("습도는 0 ~ 100 사이의 값을 입력하세요.");
        fm.humidity.focus();
        return false;
    }
    
    // 일조량 유효성 검사
    if(fm.sunlight.value == '') {
        alert("일조량을 입력하세요.");
        fm.sunlight.focus();
        return false;
    }
    
    var sunlight = parseFloat(fm.sunlight.value);
    if(isNaN(sunlight)) {
        alert("일조량은 숫자로 입력하세요.");
        fm.sunlight.focus();
        return false;
    }
    
    if(sunlight < 0 || sunlight > 24) {
        alert("일조량은 0 ~ 24 사이의 값을 입력하세요.");
        fm.sunlight.focus();
        return false;
    }
    
    // 키 유효성 검사
    if(fm.height.value == '') {
        alert("키를 입력하세요.");
        fm.height.focus();
        return false;
    }
    
    var height = parseFloat(fm.height.value);
    if(isNaN(height)) {
        alert("키는 숫자로 입력하세요.");
        fm.height.focus();
        return false;
    }
    
    if(height < 0 || height > 999.99) {
        alert("키는 0 ~ 999.99 사이의 값을 입력하세요.");
        fm.height.focus();
        return false;
    }
    
    // 열매 개수 유효성 검사
    if(fm.fruit.value == '') {
        alert("열매 개수를 입력하세요.");
        fm.fruit.focus();
        return false;
    }
    
    var fruit = parseInt(fm.fruit.value);
    if(isNaN(fruit)) {
        alert("열매 개수는 숫자로 입력하세요.");
        fm.fruit.focus();
        return false;
    }
    
    if(fruit < 0 || fruit > 999999) {
        alert("열매 개수는 0 이상의 정수를 입력하세요.");
        fm.fruit.focus();
        return false;
    }
    
    // 설명 유효성 검사
    if(fm.description.value.trim() == '') {
        alert("설명을 입력하세요.");
        fm.description.focus();
        return false;
    }
    
    if(getByteLength(fm.description.value) > 500) {
        alert("설명은 500바이트 이하로 입력하세요. (한글 약 166자)");
        fm.description.focus();
        return false;
    }
    
    // 파일 유효성 검사
    if(fm.ofile.files.length > 0) {
        var file = fm.ofile.files[0];
        var fileName = file.name.toLowerCase();
        var allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp'];
        var fileExtension = fileName.split('.').pop();
        
        if(allowedExtensions.indexOf(fileExtension) === -1) {
            alert("이미지 파일만 업로드 가능합니다. (jpg, jpeg, png, gif, bmp)");
            return false;
        }
        
        // 파일 크기 체크 (10MB)
        if(file.size > 10 * 1024 * 1024) {
            alert("파일 크기는 10MB 이하로 업로드하세요.");
            return false;
        }
        
        // 파일명 길이 체크 (255바이트)
        if(getByteLength(fileName) > 255) {
            alert("파일명이 너무 깁니다. (최대 255바이트)");
            return false;
        }
    }
    
    return true;
}

// 바이트 길이 계산 함수
function getByteLength(str) {
    var byteLength = 0;
    for(var i = 0; i < str.length; i++) {
        var charCode = str.charCodeAt(i);
        if(charCode <= 0x7F) {
            byteLength += 1;
        } else if(charCode <= 0x7FF) {
            byteLength += 2;
        } else if(charCode <= 0xFFFF) {
            byteLength += 3;
        } else {
            byteLength += 4;
        }
    }
    return byteLength;
}

// 숫자 입력 제한 함수
function onlyNumber(event) {
    var key = event.key;
    if(key === 'Backspace' || key === 'Delete' || key === 'Tab' || 
       key === 'ArrowLeft' || key === 'ArrowRight' || key === '.' || key === '-') {
        return true;
    }
    if(key < '0' || key > '9') {
        event.preventDefault();
        return false;
    }
}

// 정수만 입력 제한 함수
function onlyInteger(event) {
    var key = event.key;
    if(key === 'Backspace' || key === 'Delete' || key === 'Tab' || 
       key === 'ArrowLeft' || key === 'ArrowRight') {
        return true;
    }
    if(key < '0' || key > '9') {
        event.preventDefault();
        return false;
    }
}
</script>
<body>
	<%@ include file="/WEB-INF/views/common/header.jsp"%>

	<!-- Write 페이지 HTML -->
	<div class="mydiary-container">
		<!-- 상단 메뉴 -->
		<div class="mydiary-top-wrapper">
			<div class="mydiary-top">
				<nav class="mydiary-nav">
					<a href="/mydiary/calendar.do" class="mydiary-calendar-btn">캘린더</a>
				</nav>
				<h2 class="mydiary-title">나만의 식물 꾸미기</h2>
				<button type="button" class="mydiary-list-btn"
					onclick="location.href='./list.do';">목록보기</button>
			</div>
		</div>

		<!-- Write 폼 -->
		<div class="mydiary-write-form">
			<form name="writeFrm" method="post" enctype="multipart/form-data"
				action="${contextPath}/mydiary/write.do"
				onsubmit="return validateForm(this);">

				<div class="mydiary-write-card">
					<!-- 카드 헤더 -->
					<div class="mydiary-write-header">
						<div class="mydiary-card-number">🌱</div>
						<h2>관찰 기록</h2>
					</div>

					<!-- 폼 내용 -->
					<div class="mydiary-write-content">
						<!-- 식물명 (라디오: 선택 옵션, 기본값 미선택) -->
						<div class="mydiary-write-row">
							<div class="mydiary-write-label">식물명 
								<span>선택 시 해당 식물 기준 예측에 사용됩니다.(미선택 가능)</span>
								<button type="button" class="mydiary-radio-clear"
								onclick="document.querySelectorAll('input[name=plantidx]').forEach(r=>r.checked=false)">
								선택 해제</button>
							</div>
							
							<div class="mydiary-write-input-area">
								<div class="mydiary-radio-group" role="radiogroup"
									aria-label="식물명">
									<c:forEach var="p" items="${plants}">
										<label class="mydiary-radio"> <input type="radio"
											name="plantidx" value="${p.plantidx}"> 
											<span>${p.name}</span>
										</label>
									</c:forEach>
								</div>

							</div>
						</div>
						<!-- 온도 -->
						<div class="mydiary-write-row">
							<div class="mydiary-write-label">
								온도 (°C)<span class="mydiary-write-required">*</span>
							</div>
							<div class="mydiary-write-input-area">
								<input type="text" name="temperature"
									class="mydiary-write-input" placeholder="예: 25.5"
									onkeydown="return onlyNumber(event)" />
								<div class="mydiary-write-help">(-99.99 ~ 999.99)</div>
							</div>
						</div>

						<!-- 습도 -->
						<div class="mydiary-write-row">
							<div class="mydiary-write-label">
								습도 (%)<span class="mydiary-write-required">*</span>
							</div>
							<div class="mydiary-write-input-area">
								<input type="text" name="humidity" class="mydiary-write-input"
									placeholder="예: 65.0" onkeydown="return onlyNumber(event)" />
								<div class="mydiary-write-help">(0 ~ 100)</div>
							</div>
						</div>

						<!-- 일조량 -->
						<div class="mydiary-write-row">
							<div class="mydiary-write-label">
								일조량 (시간)<span class="mydiary-write-required">*</span>
							</div>
							<div class="mydiary-write-input-area">
								<input type="text" name="sunlight" class="mydiary-write-input"
									placeholder="예: 8.5" onkeydown="return onlyNumber(event)" />
								<div class="mydiary-write-help">(0 ~ 24)</div>
							</div>
						</div>

						<!-- 키 -->
						<div class="mydiary-write-row">
							<div class="mydiary-write-label">
								키 (cm)<span class="mydiary-write-required">*</span>
							</div>
							<div class="mydiary-write-input-area">
								<input type="text" name="height" class="mydiary-write-input"
									placeholder="예: 15.5" onkeydown="return onlyNumber(event)" />
								<div class="mydiary-write-help">(0 ~ 999.99)</div>
							</div>
						</div>

						<!-- 열매 개수 -->
						<div class="mydiary-write-row">
							<div class="mydiary-write-label">
								열매 개수<span class="mydiary-write-required">*</span>
							</div>
							<div class="mydiary-write-input-area">
								<input type="text" name="fruit" class="mydiary-write-input"
									placeholder="예: 5" onkeydown="return onlyInteger(event)" />
								<div class="mydiary-write-help">(0 이상의 정수)</div>
							</div>
						</div>

						<!-- 설명 -->
						<div class="mydiary-write-row">
							<div class="mydiary-write-label">
								설명<span class="mydiary-write-required">*</span>
							</div>
							<div class="mydiary-write-input-area">
								<textarea name="description" class="mydiary-write-textarea"
									placeholder="식물의 상태나 특징을 자세히 기록해주세요."></textarea>
								<div class="mydiary-write-help">최대 500바이트 (한글 약 166자)</div>
							</div>
						</div>

						<!-- 파일 업로드 -->
						<div class="mydiary-write-row">
							<div class="mydiary-write-label">식물 사진</div>
							<div class="mydiary-write-input-area">
								<input type="file" name="ofile" accept="image/*"
									class="mydiary-write-file" />
								<div class="mydiary-write-help">이미지 파일만 업로드 가능 (jpg, png,
									gif 등), 최대 10MB</div>
							</div>
						</div>

						<!-- 버튼 영역 -->
						<div class="mydiary-write-buttons">
							<button type="submit" class="mydiary-write-btn submit">작성
								완료</button>
							<button type="reset" class="mydiary-write-btn reset">초기화</button>
							<button type="button" class="mydiary-write-btn list"
								onclick="location.href='${contextPath}/mydiary/list.do';">목록으로</button>
						</div>
					</div>
				</div>
			</form>

			<!-- 안내 메시지 -->
			<div class="mydiary-write-notice">
				<span class="mydiary-write-required">*</span> 표시된 항목은 필수 입력 항목입니다.
			</div>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/common/footer.jsp"%>
</body>

</html>