<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 목록</title>
<link rel="stylesheet" href="/css/admin.css" />
</head>
<body>
	<h1>관리자 페이지</h1>
	<h2>회원 목록</h2>

	<c:if test="${not empty errorMsg}">
		<p style="color: red">${errorMsg}</p>
	</c:if>
	
	<!-- 검색 -->
	<form action="/admin/index.do" method="get" style="margin-bottom: 20px;">
	    <label for="searchUserId">아이디 검색:</label>
	    <input type="text" name="searchUserId" id="searchUserId" value="${param.searchUserId}">
	    <input type="submit" value="검색">
	</form>
	
	
	<table border="1" cellpadding="5">
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
                <form action="${pageContext.request.contextPath}/admin/disableMember.do" method="post"
                      onsubmit="return confirm('정말 비활성화 하시겠습니까?');" style="display:inline;">
                    <input type="hidden" name="userid" value="${m.userid}">
                    <input type="submit" value="비활성화" class="admin-btn">
                </form>
            </c:when>
            <c:otherwise>
                <form action="${pageContext.request.contextPath}/admin/enableMember.do" method="post"
                      onsubmit="return confirm('이 회원을 다시 활성화 하시겠습니까?');" style="display:inline;">
                    <input type="hidden" name="userid" value="${m.userid}">
                    <input type="submit" value="활성화" class="admin-btn">
                </form>
            </c:otherwise>
        </c:choose>
    </td>
</tr>

		</c:forEach>
	</table>

</body>
</html>
