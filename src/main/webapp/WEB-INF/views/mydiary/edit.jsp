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
			<div class="user-section">
				<span class="login-link">로그인</span> <span class="register-link">회원가입</span>
				<div class="user-icon">👤</div>
			</div>
		</div>
	</div>

	<!-- 한이 작업 -->
	<h2>게시판 수정(Mybatis)</h2>
	<form name="writeFrm" method="post" enctype="multipart/form-data"
		action="./edit.do" onsubmit="return validateForm(this);">
		<input type="hidden" name="diaryIdx" value="${myDiaryDTO.diaryIdx }" />
		<table border="1" width="90%">
			<!-- 
		<tr>
	        <td>작성자</td>
	        <td>
	            <input type="text" name="userId" style="width:150px;" 
	            	value="${myDiaryDTO.userId}" />
	        </td>
	    </tr>	
	 -->
			<tr>
				<td>온도</td>
				<td><input type="text" name="temperature" style="width: 90%;"
					value="${myDiaryDTO.temperature}" /></td>
			</tr>
			<tr>
				<td>습도</td>
				<td><input type="text" name="humidity" style="width: 90%;"
					value="${myDiaryDTO.humidity}" /></td>
			</tr>
			<tr>
				<td>일조량</td>
				<td><input type="text" name="sunlight" style="width: 90%;"
					value="${myDiaryDTO.sunlight}" /></td>
			</tr>
			<tr>
				<td>키</td>
				<td><input type="text" name="height" style="width: 90%;"
					value="${myDiaryDTO.height}" /></td>
			</tr>
			<tr>
				<td>열매 개수</td>
				<td><input type="text" name="fruit" style="width: 90%;"
					value="${myDiaryDTO.fruit}" /></td>
			</tr>
			<tr>
				<td>설명</td>
				<td><textarea name="description"
						style="width: 90%; height: 100px;">${myDiaryDTO.description}</textarea>
				</td>
			</tr>
			<tr>
				<td>이미지</td>
				<td><input type="file" name="ofile" /></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<button type="submit">작성 완료</button>
					<button type="reset">RESET</button>
					<button type="button" onclick="location.href='./list.do';">
						목록 바로가기</button>
				</td>
			</tr>
		</table>
	</form>
</body>

</html>