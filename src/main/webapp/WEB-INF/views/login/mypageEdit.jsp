<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>정보 수정</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypageEdit.css">
</head>
<body>

<!-- 🎨 배경 blob -->
<div class="edit-background">
    <div class="edit-blob edit-blob1"></div>
    <div class="edit-blob edit-blob2"></div>
    <div class="edit-blob edit-blob3"></div>
    <div class="edit-blob edit-blob4"></div>
</div>

<!-- 📝 정보 수정 폼 -->
<div class="edit-container">
    <h2>정보 수정</h2>

    <form method="post" action="/mypageEditAction.do">
        <label>현재 비밀번호</label>
        <input type="password" name="currentPassword" required>

        <label>새 비밀번호</label>
        <input type="password" name="newPassword">

        <label>활동명</label>
        <input type="text" name="username" value="${username}" required>

        <label for="phone1">전화번호</label>
        <div class="phone-inputs">
            <input type="tel" name="phone1" id="phone1" maxlength="3" required pattern="\d{3}" inputmode="numeric" value="${phone1}" title="3자리 숫자" />
            <span class="hyphen">-</span>
            <input type="tel" name="phone2" id="phone2" maxlength="4" required pattern="\d{4}" inputmode="numeric" value="${phone2}" title="4자리 숫자" />
            <span class="hyphen">-</span>
            <input type="tel" name="phone3" id="phone3" maxlength="4" required pattern="\d{4}" inputmode="numeric" value="${phone3}" title="4자리 숫자" />
        </div>

        <label>이메일</label>
        <input type="email" name="email" value="${email}" required>

        <button type="submit" class="edit-button">수정하기</button>
    </form>

    <c:if test="${not empty errorMsg}">
        <p class="edit-error">${errorMsg}</p>
    </c:if>
</div>

</body>
</html>
