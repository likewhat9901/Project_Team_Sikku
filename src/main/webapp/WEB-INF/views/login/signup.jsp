<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<<<<<<< HEAD
	<meta charset="UTF-8">
	<title>스마트팜 회원가입</title>
	<link rel="stylesheet" href="/css/common/layout.css" />
	<link rel="stylesheet" href="/css/loginSign.css">
=======
  <meta charset="UTF-8">
  <title>스마트팜 회원가입</title>
  <link rel="stylesheet" href="./css/style.css">
>>>>>>> 2693aab (backup: 최초 상태)
</head>
<body>
  <div class="signup-background">
    <!-- 블롭 애니메이션 배경 -->
    <div class="signup-blob signup-blob1"></div>
    <div class="signup-blob signup-blob2"></div>
    <div class="signup-blob signup-blob3"></div>
    <div class="signup-blob signup-blob4"></div>

    <div class="signup-wrapper">
      <h2 class="form-title">sign up</h2>

      <!-- 회원가입 폼 -->
      <div class="form-container">
        <form action="/signupAction.do" method="post">

          <label for="userid">아이디</label>
          <input type="text" name="userid" id="userid" required>
          <%
            String idError = (String) request.getAttribute("idError");
            if (idError != null) {
          %>
            <p class="error"><%= idError %></p>
          <%
            }
          %>

          <label for="userpw">비밀번호</label>
          <input type="password" name="userpw" id="userpw" required>

          <label for="userpw_confirm">비밀번호 확인</label>
          <input type="password" name="userpw_confirm" id="userpw_confirm" required>
          <%
            String error = (String) request.getAttribute("pwError");
            if (error != null) {
          %>
            <p class="error"><%= error %></p>
          <%
            }
          %>

          <label for="username">사이트 활동명</label>
          <input type="text" name="username" id="username" required>
			
			<%
			  String activityNameError = (String) request.getAttribute("activityNameError");
			  if (activityNameError != null) {
			%>
			  <p class="error"><%= activityNameError %></p>
			<%
			  }
			%>

          <label for="phone1">전화번호</label>
          <div class="phone-inputs">
			  <input type="tel" name="phone1" id="phone1" maxlength="3" required pattern="\d{3}" inputmode="numeric" title="3자리 숫자" />
			  <span class="hyphen">-</span>
			  <input type="tel" name="phone2" id="phone2" maxlength="4" required pattern="\d{4}" inputmode="numeric" title="4자리 숫자" />
			  <span class="hyphen">-</span>
			  <input type="tel" name="phone3" id="phone3" maxlength="4" required pattern="\d{4}" inputmode="numeric" title="4자리 숫자" />
			</div>
			
			<%
			  String phoneError = (String) request.getAttribute("phoneError");
			  if (phoneError != null) {
			%>
			  <p class="error"><%= phoneError %></p>
			<%
			  }
			%>
			
          <label for="email_id">이메일</label>
          <div class="email-inputs">
            <input type="text" name="email_id" id="email_id" placeholder="이메일" required>
            <span>@</span>
            <input type="text" name="email_domain" id="email_domain" placeholder="도메인 입력" required>

            <select id="email_select" onchange="onEmailSelectChange(this)">
              <option value="">직접입력</option>
              <option value="gmail.com">gmail.com</option>
              <option value="naver.com">naver.com</option>
              <option value="daum.net">daum.net</option>
              <option value="hanmail.net">hanmail.net</option>
            </select>
          </div>
          <%
            String emailErr = (String) request.getAttribute("emailError");
            if (emailErr != null) {
          %>
            <p class="error"><%= emailErr %></p>
          <%
            }
          %>

          <button class="form-button" type="submit">가입 완료</button>
        </form>

        <div class="footer-link">
          <a href="/myLogin.do">이미 계정이 있으신가요?</a>
        </div>
      </div>
    </div>
  </div>

  <script>
    const phone1 = document.getElementById('phone1');
    const phone2 = document.getElementById('phone2');
    const phone3 = document.getElementById('phone3');

    phone1.addEventListener('input', () => {
      if (phone1.value.length === 3) phone2.focus();
    });
    phone2.addEventListener('input', () => {
      if (phone2.value.length === 4) phone3.focus();
    });
    phone3.addEventListener('input', () => {
      if (phone3.value.length === 4) phone3.blur();
    });

    function onEmailSelectChange(select) {
      const emailDomainInput = document.getElementById('email_domain');
      if (select.value === "") {
        emailDomainInput.value = "";
        emailDomainInput.readOnly = false;
        emailDomainInput.focus();
      } else {
        emailDomainInput.value = select.value;
        emailDomainInput.readOnly = true;
      }
    }
  </script>
</body>
</html>
