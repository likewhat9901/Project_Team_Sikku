<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/myDiarystyle.css" />
<link rel="stylesheet" href="/css/main.css">
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
			<!-- ✅ 로그인 상태에 따라 동적으로 변경 -->
			<div class="user-section">

				<!-- 로그인 시 -->
				<sec:authorize access="isAuthenticated()">
					<span class="mypage-link"
						onclick="location.href='/member/mypage.do'">마이페이지</span>
					<span class="logout-link" onclick="location.href='/myLogout.do'">로그아웃</span>
					<div class="user-icon">👤</div>
				</sec:authorize>

			</div>
		</div>
	</div>


	<!-- 한이 작업 -->
	<h2>다이어리 작성</h2>
	<!-- 
	<form name="writeFrm" method="post" enctype="multipart/form-data"
		action="./write.do" onsubmit="return validateForm(this);">
	<table border="1" width="90%">
	    <tr>
	        <td>온도</td>
	        <td>
	            <input type="text" name="temperature" style="width:90%;" />
	        </td>
	    </tr>
	    <tr>
	        <td>습도</td>
	        <td>
	            <input type="text" name="humidity" style="width:90%;" />
	        </td>
	    </tr>
	    <tr>
	        <td>일조량</td>
	        <td>
	            <input type="text" name="sunlight" style="width:90%;" />
	        </td>
	    </tr>
	    <tr>
	        <td>키</td>
	        <td>
	            <input type="text" name="height" style="width:90%;" />
	        </td>
	    </tr>
	    <tr>
	        <td>열매 개수</td>
	        <td>
	            <input type="text" name="fruit" style="width:90%;" />
	        </td>
	    </tr>
	    <tr>
	        <td>설명</td>
	        <td>
	            <textarea name="description" style="width:90%;height:100px;"></textarea>
	        </td>
	    </tr>
	    <tr>
	        <td>이미지</td>
	        <td>
	        	<input type="file" name="ofile" />
	        </td>
	    </tr>
	    <tr>
	        <td colspan="2" align="center">
	            <button type="submit">작성 완료</button>
	            <button type="reset">RESET</button>
	            <button type="button" onclick="location.href='./list.do';">
	                목록 바로가기
	            </button>
	        </td>
	    </tr>
	</table>    
	</form>
	
	 -->
	<form name="writeFrm" method="post" enctype="multipart/form-data"
		action="${contextPath}/mydiary/write.do"
		onsubmit="return validateForm(this);">
		<table border="1" width="90%">
			<tr>
				<td width="20%">온도 (°C) <span style="color: red;">*</span></td>
				<td><input type="text" name="temperature" style="width: 200px;"
					placeholder="예: 25.5" onkeydown="return onlyNumber(event)" /> <span
					style="color: #666; font-size: 12px;">(-99.99 ~ 999.99)</span></td>
			</tr>
			<tr>
				<td>습도 (%) <span style="color: red;">*</span></td>
				<td><input type="text" name="humidity" style="width: 200px;"
					placeholder="예: 65.0" onkeydown="return onlyNumber(event)" /> <span
					style="color: #666; font-size: 12px;">(0 ~ 100)</span></td>
			</tr>
			<tr>
				<td>일조량 (시간) <span style="color: red;">*</span></td>
				<td><input type="text" name="sunlight" style="width: 200px;"
					placeholder="예: 8.5" onkeydown="return onlyNumber(event)" /> <span
					style="color: #666; font-size: 12px;">(0 ~ 24)</span></td>
			</tr>
			<tr>
				<td>키 (cm) <span style="color: red;">*</span></td>
				<td><input type="text" name="height" style="width: 200px;"
					placeholder="예: 15.5" onkeydown="return onlyNumber(event)" /> <span
					style="color: #666; font-size: 12px;">(0 ~ 999.99)</span></td>
			</tr>
			<tr>
				<td>열매 개수 <span style="color: red;">*</span></td>
				<td><input type="text" name="fruit" style="width: 200px;"
					placeholder="예: 5" onkeydown="return onlyInteger(event)" /> <span
					style="color: #666; font-size: 12px;">(0 이상의 정수)</span></td>
			</tr>
			<tr>
				<td>설명 <span style="color: red;">*</span></td>
				<td><textarea name="description"
						style="width: 90%; height: 100px;"
						placeholder="식물의 상태나 특징을 자세히 기록해주세요."></textarea>
					<div style="color: #666; font-size: 12px;">최대 500바이트 (한글 약
						166자)</div></td>
			</tr>
			<tr>
				<td>식물 사진</td>
				<td><input type="file" name="ofile" accept="image/*" />
					<div style="color: #666; font-size: 12px;">이미지 파일만 업로드 가능
						(jpg, png, gif 등), 최대 10MB</div></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<button type="submit">작성 완료</button>
					<button type="reset">초기화</button>
					<button type="button"
						onclick="location.href='${contextPath}/mydiary/list.do';">
						목록으로</button>
				</td>
			</tr>
		</table>
	</form>
	<p style="color: #666; font-size: 12px;">
		<span style="color: red;">*</span> 표시된 항목은 필수 입력 항목입니다.
	</p>
</body>

</html>