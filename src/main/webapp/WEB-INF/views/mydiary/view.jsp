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

	<!-- Header Section -->
	<div class="header">
		<div class="header-content">
			<div class="logo">
				<span class="home-btn">로고</span> <span class="site-name">그린다이어리(예명)</span>
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

	<h2>게시판 읽기(Mybatis)</h2>
	<!-- 아래 form은 확인용. hidden으로 멤버 아이디 확인 -->
	<form name="writeFrm">
		<input type="hidden" name="diaryIdx" value="${myDiaryDTO.diaryIdx }" />
	</form>
	<table border="1" width="90%">
		<colgroup>
			<col width="18%" />
			<col width="18%" />
			<col width="18%" />
			<col width="18%" />
			<col width="28" />
		</colgroup>
		<!-- 게시글 정보 -->
		<tr>
			<td>작성일</td>
			<td colspan="4">${ myDiaryDTO.postdate }</td>
		</tr>
		<tr>
			<td>이미지</td>
			<td colspan="4" height="100" style="text-align: center;"><img
				src="/uploads/${myDiaryDTO.sfile }" class="mydiary-img" /></td>
		</tr>
		<tr>
			<td>내용</td>
			<td colspan="4" height="100">${ myDiaryDTO.description }</td>
		</tr>
		<tr>
			<td>온도</td>
			<td>습도</td>
			<td>일조량</td>
			<td>키</td>
			<td>열매개수</td>
		</tr>
		<tr>
			<td>${ myDiaryDTO.temperature }</td>
			<td>${ myDiaryDTO.humidity }</td>
			<td>${ myDiaryDTO.sunlight }</td>
			<td>${ myDiaryDTO.height }</td>
			<td>${ myDiaryDTO.fruit }</td>
		</tr>
		<!-- 하단 메뉴(버튼) -->
		<tr>
			<td colspan="5" align="center">
				<button type="button"
					onclick="location.href='./edit.do?diaryIdx=${ param.diaryIdx }';">
					수정하기</button>
				<button type="button" onclick="deletePost(${ param.diaryIdx });">
					삭제하기</button>
				<button type="button" onclick="location.href='./list.do';">
					목록 바로가기</button>
			</td>
		</tr>
	</table>
</body>

</html>