<!-- /WEB-INF/views/common/header.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<<<<<<< HEAD
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<link rel="stylesheet" href="/css/common/header.css">

=======
<link rel="stylesheet" href="./css/common/common.css">
>>>>>>> 2693aab (backup: 최초 상태)
<!-- Header Section -->
<div class="header">
    <div class="header-content">
        <a href="/">
         <div class="logo">
             <span class="home-btn">로고</span>
             <span class="site-name">그린다이어리(예명)</span>
         </div>
    	</a>
        <div class="nav-icons">
<<<<<<< HEAD
            <div class="nav-item" onclick="location.href='/main/nonMember.do'">
                <div class="icon-box"></div>
                <span>비회원 페이지</span>
            </div>
        	<div class="nav-item" onclick="location.href='/about/identity.do'">
            <div class="icon-box"></div>
	            <span>궁금해?</span>
			</div>
			<div class="nav-item" onclick="location.href='/boards/freeBoardList.do'">
=======
            <div class="nav-item" onclick="location.href='/nonMember.do'">
                <div class="icon-box"></div>
                <span>비회원 페이지</span>
            </div>
        	<div class="nav-item" onclick="location.href='/corp/identity.do'">
            <div class="icon-box"></div>
	            <span>궁금해?</span>
			</div>
			<div class="nav-item" onclick="location.href='/freeBoardList.do'">
>>>>>>> 2693aab (backup: 최초 상태)
			   <div class="icon-box"></div>
			   <span>커뮤니티</span>
			</div>
			<div class="nav-item" onclick="location.href='/mydiary/list.do'">
			   <div class="icon-box"></div>
			   <span>다이어리</span>
			</div>
<<<<<<< HEAD
			<div class="nav-item" onclick="location.href='/dict/list.do'">
			   <div class="icon-box"></div>
			   <span>식물도감</span>
			</div>
			<div class="nav-item" onclick="location.href='/mbti/list.do'">
=======
			<div class="nav-item" onclick="location.href='/info.do'">
			   <div class="icon-box"></div>
			   <span>식물도감</span>
			</div>
			<div class="nav-item" onclick="location.href='/mbti.do'">
>>>>>>> 2693aab (backup: 최초 상태)
			   <div class="icon-box"></div>
			   <span>MBTI</span>
			</div>
        </div>
        <!-- ✅ 로그인 상태에 따라 동적으로 변경 -->
		<div class="user-section">
		
		     <!-- 비로그인 시 -->
		     <sec:authorize access="!isAuthenticated()">
		        <span class="login-link" onclick="location.href='/myLogin.do'">로그인</span>
		        <span class="register-link" onclick="location.href='/signup.do'">회원가입</span>
		     </sec:authorize>
		
		     <!-- 로그인 시 -->
		     <sec:authorize access="isAuthenticated()">
		        <span class="mypage-link" onclick="location.href='/mypage.do'">마이페이지</span>
		        <span class="logout-link" onclick="location.href='/myLogout.do'">로그아웃</span>
		        <div class="user-icon">👤</div>
		     </sec:authorize>
		</div>
	</div>
</div>
