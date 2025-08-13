<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<!-- CSS import -->
<link rel="stylesheet" href="/css/gallery.css">
<script>
// 유효성 검사를 위한 함수
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
    
    if (form.ofile.value == "") {
        alert("첨부파일은 필수 입력입니다.");
        return false;
    }

    return true;
}

//미리보기 함수
function previewImage(event) {
    const preview = document.getElementById('imagePreview');
    preview.innerHTML = ''; // 기존 내용 제거
    
    const files = event.target.files;
    
    if (files.length > 0) {
		Array.from(files).forEach(file => {

		//FileReader 웹 애플리케이션이 사용자 파일을 읽을 수 있도록 만드는 객체
        const reader = new FileReader();
        
        reader.onload = function(e) {
			// 새로운 <img> HTML 요소를 생성하여 img 상수에 할당
            const img = document.createElement('img');
			// 새로 생성한 <img> 요소의 src 속성에 reader가 읽어들인 데이터 URL을 할당
            img.src = e.target.result;
            img.style.maxWidth = '100px';
            img.style.margin = '5px';
            img.style.borderRadius = '8px';
            // <img> 요소를 imagePreview div 안에 자식 요소로 추가
            preview.appendChild(img);
        }
        // FileReader가 file 변수에 담긴 파일을 데이터 URL 형태로 읽기.
        reader.readAsDataURL(file);
	});
    } else {
        preview.innerHTML = '<p>미리보기 이미지가 여기에 표시됩니다.</p>';
    }
}

</script>



</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="write-container">
    <h2>게시글 작성</h2>
    <form action="/boards/gallery/galleryBoardWriteProc.do" 
          method="post" 
          enctype="multipart/form-data"
          class="write-form" 
          onsubmit="return validateWriteForm()" >
          
    	
          
        <input type="hidden" name="userId" value="${loginUserId}" />
        <input type="hidden" name="postdate" value="${postdate}" />
        <input type="hidden" name="category" value=2 />
        
        <input type="text" name="title" placeholder="제목을 입력하세요" />
        <textarea name="content" placeholder="내용을 입력하세요"></textarea>

        <!-- 이미지 업로드 & 미리보기 영역 -->
        <div class="image-upload">
            <label for="imageFile">사진 첨부</label>
            <input type="file" id="imageFile" name="ofile" accept="image/*"
            		onchange="previewImage(event)" multiple>
            <div class="image-preview" id="imagePreview">
                <p>미리보기 이미지가 여기에 표시됩니다.</p>
            </div>
        </div>

        <div class="write-actions">
            <button type="submit">작성 완료</button>
            <button type="button" class="cancel-btn" 
                onclick="location.href='/boards/gallery/galleryBoardList.do'">취소</button>
        </div>
    </form>
</div>
	
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>