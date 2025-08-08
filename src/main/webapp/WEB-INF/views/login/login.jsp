<!-- login.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>스마트팜 로그인</title>
	<link rel="stylesheet" href="/css/common/layout.css" />
	<link rel="stylesheet" href="/css/loginSign.css">
</head>
<body>
  <!-- 배경 애니메이션 -->
  <div class="login-background">
    <div class="login-blob login-blob1"></div>
    <div class="login-blob login-blob2"></div>
    <div class="login-blob login-blob3"></div>
    <div class="login-blob login-blob4"></div>
  </div>
  
<div class="login-wrapper">
	<h2 class="form-title">login</h2>

  <!-- 로그인 폼 -->
  <div class="form-container">

    <c:if test="${empty userid}" var="loginResult">
      <c:if test="${param.error != null}">
        <p class="error-message">Login Error! <br />${errorMsg}</p>
      </c:if>

      <form action="/myLoginAction.do" method="post">
		  <label for="userid">아이디</label>
		  <input type="text" id="userid" name="my_id" placeholder="아이디 입력" required>
		
		  <label for="userpwd">비밀번호</label>
		  <input type="password" id="userpwd" name="my_pass" placeholder="비밀번호 입력" required>
		
		  <button class="form-button" type="submit">로그인</button>
		</form>
    </c:if>
    
      <c:if test="${not loginResult}">
      <p class="welcome-message">${username}님 방문해주셔서 감사합니다</p>
      <div class="logout-links">
        <a href="/main/member.do">홈페이지로</a>
      </div>
    </c:if>

  </div>
</div>
</body>
</html>