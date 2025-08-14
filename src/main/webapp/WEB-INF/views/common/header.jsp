<!-- /WEB-INF/views/common/header.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<link rel="stylesheet" href="/css/common/header.css">

<!-- Header Section -->
<div class="header">
    <div class="header-content">
	        <sec:authorize access="isAuthenticated()">
	    <a href="/main/member.do">
	        <div class="logo">
	            <img alt="" src="/images/header/logo.png" />
	        </div>
	    </a>
	</sec:authorize>
	
	<sec:authorize access="!isAuthenticated()">
	    <a href="/main/nonMember.do">
	        <div class="logo">
	            <img alt="" src="/images/header/logo.png" />
	        </div>
	    </a>
	</sec:authorize>
	
        <div class="nav-icons">
            <div class="nav-item" onclick="location.href='/main/nonMember.do'">
                <div class="icon-box"><img alt="" src="/images/header/icons/icon_farmer_man.png"/></div>
                <span>비회원</span>
            </div>
        	<div class="nav-item" onclick="location.href='/about/identity.do'">
	            <div class="icon-box"><img alt="" src="/images/header/icons/icon_farmhouse.png"/></div>
	            <span>소개</span>
			</div>
			<div class="nav-item" onclick="location.href='/boards/free/freeBoardList.do'">
			   <div class="icon-box"><img alt="" src="/images/header/icons/icon_community.png"/></div>
			   <span>커뮤니티</span>
			</div>
			<div class="nav-item" onclick="location.href='/mydiary/list.do'">
			   <div class="icon-box"><img alt="" src="/images/header/icons/icon_diary.png"/></div>
			   <span>다이어리</span>
		    </div>
		    <div class="nav-item" onclick="location.href='/main/nonMember.do'">
                <div class="icon-box"><img alt="" src="/images/header/icons/icon_calender.png"/></div>
                <span>캘린더</span>
            </div>
			<div class="nav-item" onclick="location.href='/dict/list.do'">
			   <div class="icon-box"><img alt="" src="/images/header/icons/icon_farmplants.png"/></div>
			   <span>식물도감</span>
			</div>
			<div class="nav-item" onclick="location.href='/mbti/list.do'">
			   <div class="icon-box"><img alt="" src="/images/header/icons/icon_recommend.png"/></div>
			   <span>MBTI</span>
			</div>
        </div>
        <!-- ✅ 로그인 상태에 따라 동적으로 변경 -->
		<div class="user-section">
		
		     <!-- 비로그인 시 -->
		     <sec:authorize access="!isAuthenticated()">
		        <span class="login-link" onclick="location.href='/myLogin.do'">로그인</span>
		        <span class="register-link" onclick="location.href='/signup.do'">회원가입</span>
		        <div class="user-icon">
			        <img alt="user icon" src="/images/header/icons/icon_farmer_man.png" />
				</div>
		     </sec:authorize>
				
		     <!-- 로그인 시 -->
		     <sec:authorize access="isAuthenticated()">
		        <span class="mypage-link" onclick="location.href='/mypage.do'">마이페이지</span>
		        <span class="logout-link" onclick="location.href='/myLogout.do'">로그아웃</span>
		        <div class="user-icon" onclick="location.href='/mypage.do'">
			        <img alt="user icon"
                         src="${sessionScope.profileImgPath != null ? sessionScope.profileImgPath : '/images/프로필.png'}" />
				</div>
		     </sec:authorize>
		</div>
	</div>
</div>

<div class="main_container">