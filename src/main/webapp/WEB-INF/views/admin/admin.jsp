<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>관리자 페이지</title>
  <link rel="stylesheet" href="/css/admin.css" />
</head>
<body>
<div class="admin-wrapper">
  <!-- 사이드바 -->
  <div class="admin-sidebar">
    <ul>
      <li class="admin-tab-btn active" data-tab="member">회원관리</li>
      <li class="admin-tab-btn" data-tab="report">신고된 게시물</li>
    </ul>
  </div>

  <!-- 본문 컨텐츠 -->
  <div class="admin-content">

    <!-- 회원관리 탭 -->
    <div class="admin-tab-content" id="member-tab">
      <h1 class="admin-title">관리자 페이지</h1>
      <h2 class="admin-subtitle">회원 목록</h2>

      <form action="/admin/index.do" method="get" class="admin-search-form">
        <label for="searchUserId">아이디 검색:</label>
        <input type="text" name="searchUserId" id="searchUserId" class="admin-search-input" value="${param.searchUserId}">
        <input type="submit" value="검색" class="admin-search-btn">
      </form>

      <table class="admin-table">
        <tr>
          <th>아이디</th>
          <th>활동명</th>
          <th>전화번호</th>
          <th>이메일</th>
          <th>권한</th>
          <th>활성여부</th>
        </tr>
        <c:forEach var="m" items="${members}">
          <tr>
            <td>${m.userid}</td>
            <td>${m.username}</td>
            <td>${m.phonenumber}</td>
            <td>${m.email}</td>
            <td>
              <form action="${pageContext.request.contextPath}/admin/changeAuthority.do" method="post" style="display:inline;">
                <input type="hidden" name="userid" value="${m.userid}">
                <select name="authority">
                  <option value="ROLE_USER" ${m.authority == 'ROLE_USER' ? 'selected' : ''}>USER</option>
                  <option value="ROLE_ADMIN" ${m.authority == 'ROLE_ADMIN' ? 'selected' : ''}>ADMIN</option>
                </select>
                <input type="submit" value="변경" class="admin-btn">
              </form>
            </td>
            <td>
              <c:choose>
                <c:when test="${m.enabled == 1}">
                  <form action="${pageContext.request.contextPath}/admin/disableMember.do" method="post" onsubmit="return confirm('정말 비활성화 하시겠습니까?');" style="display:inline;">
                    <input type="hidden" name="userid" value="${m.userid}">
                    <input type="submit" value="비활성화" class="admin-btn">
                  </form>
                </c:when>
                <c:otherwise>
                  <form action="${pageContext.request.contextPath}/admin/enableMember.do" method="post" onsubmit="return confirm('이 회원을 다시 활성화 하시겠습니까?');" style="display:inline;">
                    <input type="hidden" name="userid" value="${m.userid}">
                    <input type="submit" value="활성화" class="admin-btn">
                  </form>
                </c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>
      </table>
    </div>

    <!-- 신고 게시물 탭 -->
    <div class="admin-tab-content" id="report-tab" style="display:none;">
    <h1 class="admin-title">관리자 페이지</h1>
      <h2 class="admin-subtitle">🚨 신고된 게시글 목록</h2>
      <c:if test="${empty reportedPosts}">
        <p>신고된 게시글이 없습니다.</p>
      </c:if>
      <c:if test="${not empty reportedPosts}">
        <table class="admin-table">
          <tr>
            <th>게시글 ID</th>
            <th>작성자</th>
            <th>제목</th>
            <th>신고 사유</th>
            <th>신고 수</th>
            <th>바로가기</th>
            <th>작성자 비활성화</th>
          </tr>
          <c:forEach var="post" items="${reportedPosts}">
            <tr>
              <td>${post.boardIdx}</td>
              <td>${post.userId}</td>
              <td>${post.title}</td>
              <td>${post.content}</td>
              <td>${post.reportCount}</td>
              <td><a href="/boards/free/freeBoardView.do?boardIdx=${post.boardIdx}" target="_blank">보기</a></td>
              <td>
                <form action="${pageContext.request.contextPath}/admin/disableMember.do" method="post" onsubmit="return confirm('해당 작성자를 비활성화 하시겠습니까?');">
                  <input type="hidden" name="userid" value="${post.userId}" />
                  <input type="submit" value="작성자 비활성화" class="admin-btn">
                </form>
              </td>
            </tr>
          </c:forEach>
        </table>
      </c:if>
    </div>
  </div>
</div>

<!-- 탭 전환 JS -->
<script>
  document.querySelectorAll(".admin-tab-btn").forEach(btn => {
    btn.addEventListener("click", function() {
      document.querySelectorAll(".admin-tab-btn").forEach(b => b.classList.remove("active"));
      this.classList.add("active");
      const tab = this.dataset.tab;
      document.querySelectorAll(".admin-tab-content").forEach(div => {
        div.style.display = "none";
      });
      document.getElementById(tab + "-tab").style.display = "block";
    });
  });
</script>
</body>
</html>