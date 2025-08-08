<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<<<<<<< HEAD
	<meta charset="UTF-8">
	<title>마이페이지</title>
	<link rel="stylesheet" href="/css/common/layout.css" />
	<link rel="stylesheet" href="/css/mypage.css">
=======
  <meta charset="UTF-8">
  <title>마이페이지</title>
  <link rel="stylesheet" href="/css/main.css">
  <link rel="stylesheet" href="/css/mypage.css">
>>>>>>> 2693aab (backup: 최초 상태)
</head>
<body>

<!-- ✅ 상단 네비게이션 바 -->
<div class="header">
  <div class="header-content">
    <div class="logo">
      <span class="home-btn" onclick="location.href='/'">로고</span> 
      <span class="site-name">그린다이어리(예명)</span>
    </div>

    <div class="nav-icons">
      <div class="nav-item"><div class="icon-box"></div><span>궁금해?</span></div>
      <div class="nav-item" onclick="location.href='/freeBoardList.do'"><div class="icon-box"></div><span>커뮤니티</span></div>
      <div class="nav-item" onclick="location.href='/mydiary/list.do'"><div class="icon-box"></div><span>다이어리</span></div>
      <div class="nav-item" onclick="location.href='/info.do'"><div class="icon-box"></div><span>식물도감</span></div>
      <div class="nav-item" onclick="location.href='/mbti.do'"><div class="icon-box"></div><span>MBTI</span></div>
    </div>

    <div class="user-section">
      <sec:authorize access="!isAuthenticated()">
        <span class="login-link" onclick="location.href='/myLogin.do'">로그인</span>
        <span class="register-link" onclick="location.href='/signup.do'">회원가입</span>
      </sec:authorize>
      <sec:authorize access="isAuthenticated()">
        <span class="mypage-link" onclick="location.href='/mypage.do'">마이페이지</span>
        <span class="logout-link" onclick="location.href='/myLogout.do'">로그아웃</span>
        <div class="user-icon">👤</div>
      </sec:authorize>
    </div>
  </div>
</div>

<!-- ✅ 마이페이지 제목 (프로필 박스 바로 위) -->
<div class="mypage-title">
  <h1>마이페이지</h1>
</div>

<!-- ✅ 마이페이지 전체 컨테이너 -->
<div class="mypage-container">

  <!-- 📌 프로필 영역 -->
  <div class="profile-card">
    <form action="/mypage/uploadProfile" method="post" enctype="multipart/form-data">
      <input type="file" id="profileImageInput" name="profileImage" accept="image/*" style="display: none;" onchange="previewImage(event)">
      <label for="profileImageInput">
        <img id="profilePreview" src="${user.profileImgPath != null ? user.profileImgPath : '/images/프로필.png'}" alt="프로필 이미지" />
      </label>
      <p class="profile-name">${username} 님</p>
      <p class="profile-id">${email}</p>
      <button class="edit-btn" type="submit">프로필 사진 저장</button>
    </form>
    <form action="/mypage/editInfo" method="get">
      <button class="edit-btn" type="submit">정보 수정</button>
    </form>
  </div>

  <!-- 📌 나의 활동 영역 -->
  <div class="activity-section">
    <h2>나의 활동</h2>

    <div class="activity-box">
      <h3>👍 좋아요 누른 글</h3>
      <table class="activity-table">
        <tr><th>제목</th><th>날짜</th></tr>
        <c:forEach var="post" items="${likedPosts}">
          <tr>
            <td>${post.title}</td>
            <td>${post.date}</td>
          </tr>
        </c:forEach>
      </table>
    </div>

    <div class="activity-box">
      <h3>💬 작성한 댓글</h3>
      <table class="activity-table">
        <tr><th>내용</th><th>날짜</th></tr>
        <c:forEach var="comment" items="${comments}">
          <tr>
            <td>${comment.content}</td>
            <td>${comment.date}</td>
          </tr>
        </c:forEach>
      </table>
    </div>

    <div class="activity-box">
      <h3>✍️ 작성한 게시글</h3>
      <table class="activity-table">
        <tr><th>제목</th><th>날짜</th></tr>
        <c:forEach var="post" items="${myPosts}">
          <tr>
            <td>${post.title}</td>
            <td>${post.date}</td>
          </tr>
        </c:forEach>
      </table>
    </div>
  </div>
</div>

<!-- 이미지 미리보기 스크립트 -->
<script>
  function previewImage(event) {
    const input = event.target;
    const preview = document.getElementById("profilePreview");

    if (input.files && input.files[0]) {
      const reader = new FileReader();
      reader.onload = function (e) {
        preview.src = e.target.result;
      };
      reader.readAsDataURL(input.files[0]);
    }
  }
</script>

</body>
</html>
