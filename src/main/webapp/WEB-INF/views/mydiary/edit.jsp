<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<<<<<<< HEAD
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link rel="stylesheet" href="/css/common/layout.css" />
	<link rel="stylesheet" href="/css/myDiarystyle.css" />
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
=======
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
>>>>>>> 2693aab (backup: 최초 상태)

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
<<<<<<< HEAD
	
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
=======
>>>>>>> 2693aab (backup: 최초 상태)
</body>

</html>