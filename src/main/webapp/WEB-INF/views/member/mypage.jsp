<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>마이페이지</title>
  <link rel="stylesheet" href="/css/common/layout.css" />
  <link rel="stylesheet" href="/css/mypage.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>


<div class="mypage1-title">
  <h1 align="right">마이페이지</h1>
</div>

<div class="mypage-container">

  <div class="profile-card">
    <form id="profileForm" enctype="multipart/form-data">
      <input type="file" id="profileImageInput" name="profileImage" accept="image/*" style="display: none;" onchange="previewImage(event)">
      <label class="imggang" for="profileImageInput">
        <img id="profilePreview"
             src="${(profileImgPath != null ? profileImgPath : '/images/프로필.png')}?t=${timestamp}"
             alt="프로필 이미지" />
      </label>
      <p class="profile-name">${username} 님</p>
      <p class="profile-id">${email}</p>

      <div class="profile-btn-group">
        <button class="edit-btn" type="button" onclick="uploadProfile()">프로필 사진 저장</button>
      </div>
    </form>

    <form action="/mypage/profileAction" method="post">
      <input type="hidden" name="action" value="reset">
      <button class="edit-btn" type="submit">기본 프로필 사진</button>
    </form>

    <form action="mypageEdit.do" method="get">
      <button class="edit-btn" type="submit">정보 수정</button>
    </form>
  </div>

  <div class="activity-section">
    <h2>나의 활동</h2>

 <div class="activity-box">
  <h3>👍 좋아요 누른 글</h3>
  <table class="activity-table">
    <tr><th>제목</th><th>날짜</th></tr>
    <c:forEach var="post" items="${likedPosts}">
      <tr>
        <td>
          <a href="/boards/free/freeBoardView.do?boardIdx=${post.boardIdx}">
            ${post.title}
          </a>
        </td>
        <td>${post.date}</td>
      </tr>
    </c:forEach>
  </table>
</div>


<div class="activity-box">
  <h3>💬 작성한 댓글</h3>
  <table class="activity-table">
    <tr><th>내용</th><th>날짜</th></tr>
    <c:forEach var="post" items="${comments}">
      <tr>
        <td class="comment-cell">
          <a href="/boards/free/freeBoardView.do?boardIdx=${post.boardIdx}">
            ${post.boardTitle} - ${post.content}
          </a>
        </td>
        <td>${post.date}</td>
      </tr>
    </c:forEach>
    <c:if test="${empty comments}">
      <tr><td colspan="2">작성한 댓글이 없습니다.</td></tr>
    </c:if>
  </table>
</div>


<div class="activity-box">
  <h3>✍️ 작성한 게시글</h3>
  <table class="activity-table">
    <tr><th>제목</th><th>날짜</th></tr>
    <c:forEach var="post" items="${myPosts}">
      <tr>
        <td>
          <a href="/boards/free/freeBoardView.do?boardIdx=${post.boardIdx}">
            ${post.title}
          </a>
        </td>
        <td>${post.date}</td>
      </tr>
    </c:forEach>
  </table>
</div>

  </div>
</div>

<script>
  function previewImage(event) {
    const input = event.target;
    const preview = document.getElementById("profilePreview");
    if (input.files && input.files[0]) {
      const reader = new FileReader();
      reader.onload = e => { preview.src = e.target.result; };
      reader.readAsDataURL(input.files[0]);
    }
  }

  function uploadProfile() {
    const form = document.getElementById("profileForm");
    const formData = new FormData(form);

    const btn = document.querySelector('.profile-btn-group .edit-btn');
    btn.disabled = true;

    fetch("/mypage/uploadProfile", { method: "POST", body: formData })
      .then(r => { if (!r.ok) throw new Error("업로드 실패"); return r.json(); })
      .then(() => {
        // 서버 DB 저장 완료 → 페이지 재렌더링(PRG처럼)
        location.replace('/mypage.do?t=' + Date.now());
      })
      .catch(err => {
        alert('업로드 오류: ' + err.message);
      })
      .finally(() => {
        btn.disabled = false;
      });
  }
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
