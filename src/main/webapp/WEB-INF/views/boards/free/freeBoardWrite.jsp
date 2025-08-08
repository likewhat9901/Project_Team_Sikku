<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<!-- CSS import -->
<link rel="stylesheet" href="/css/free.css">
<link rel="stylesheet" href="/css/member.css">
<script>
function validateWriteForm() {
    const title = document.querySelector('[name="title"]').value.trim();
    const content = document.querySelector('[name="content"]').value.trim();

    if (!title) {
        alert("제목을 입력해주세요.");
        return false;
    }

    if (!content) {
        alert("내용을 입력해주세요.");
        return false;
    }

    return true;
}
</script>

</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
	<div class="write-container">
	    <h2>게시글 작성</h2>
	    <form action="/boards/free/freeBoardWriteProc.do" method="post" class="write-form">
	        <input type="text" name="memberIdx" placeholder="memberIdx" />
	        <input type="text" name="title" placeholder="제목을 입력하세요" />
	        <textarea name="content" placeholder="내용을 입력하세요" ></textarea>
	        <div class="write-actions">
	            <button type="submit">작성 완료</button>
	            <a href="/boards/free/freeBoardList.do" class="cancel-btn">취소</a>
	        </div>
	    </form>
	</div>
	
	<!-- 이미지 업로드 영역 -->
	<div class="image-upload-section">
	  <label for="imageInput" class="image-upload-label">📷 이미지 업로드</label>
	  <input type="file" id="imageInput" name="uploadImage" accept="image/*" onchange="previewImage(event)">
	  <div class="image-preview" id="imagePreview"></div>
	</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>