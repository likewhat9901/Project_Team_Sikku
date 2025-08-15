<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Q&A 글쓰기</title>
  <link rel="stylesheet" href="/css/common/layout.css" />
  <link rel="stylesheet" href="/css/qnaBoardWrite.css" />
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="qna-write-container">
  <h1 class="qna-write-title">Q&A 글쓰기</h1>

  <form action="/qna/write.do" method="post" class="qna-write-form">
    
    <div class="form-row">
      <label for="category">카테고리</label>
      <select name="category" id="category">
        <option value="일반">일반</option>
        <option value="기타">기타</option>
      </select>
    </div>

    <div class="form-row">
      <label for="title">제목</label>
      <input type="text" id="title" name="title" maxlength="255" required />
    </div>

    <div class="form-row">
      <label for="content">내용</label>
      <textarea id="content" name="content" rows="10" required></textarea>
    </div>

    <div class="form-row form-checkbox">
      <label><input type="checkbox" name="secretflag" value="Y" /> 비밀글</label>
    </div>

    <div class="form-row form-btns">
      <button type="submit">등록</button>
      <button type="reset">초기화</button>
    </div>
  </form>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
