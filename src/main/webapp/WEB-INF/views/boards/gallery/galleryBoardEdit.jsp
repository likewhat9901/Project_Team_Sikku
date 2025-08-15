<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 수정</title>
<link rel="stylesheet" href="/css/common/layout.css">
<link rel="stylesheet" href="/css/gallery.css">

<script>
// 유효성 검사를 위한 함수
function validateWriteForm() {
    const title = document.querySelector('[name="title"]').value.trim();
    const content = document.querySelector('[name="content"]').value.trim();

    if (!title) {
        alert("제목을 입력해주세요.").focus();
        return false;
    }

    if (!content) {
        alert("내용을 입력해주세요.").focus();
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
	<%@ include file="/WEB-INF/views/common/header.jsp"%>
	<header class="main-header">
		<h1>자유게시판 - 글 수정</h1>
	</header>

	<main class="board-edit">
		<form action="galleryBoardEditProc.do" method="post"
			enctype="multipart/form-data">
			<input type="hidden" name="boardIdx" value="${board.boardIdx}" /> <input
				type="hidden" name="userId" value="${board.userId}" /> <input
				type="hidden" name="category" value="${board.category}" /> <input
				type="hidden" name="likesCount" value="${board.likesCount}" /> <input
				type="hidden" name="visitcount" value="${board.visitcount}" /> <input
				type="hidden" name="postdate" value="${board.postdate}" />

			<div class="form-group">
				<label for="title">제목</label> <input type="text" id="title"
					name="title" value="${board.title}" />
			</div>

			<input type="hidden" name="userId" value="${board.userId}" />

			<div class="form-group">
				<label for="content">내용</label>
				<textarea id="content" name="content" rows="10">${board.content}</textarea>
			</div>


			<!-- 이미지 업로드 & 미리보기 영역 -->
			<div class="image-upload">
				<label for="imageFile">사진 첨부</label> <input type="file"
					id="imageFile" name="ofile" accept="image/*"
					onchange="previewImage(event)" multiple>
				<div class="image-preview" id="imagePreview">
					<p>미리보기 이미지가 여기에 표시됩니다.</p>
				</div>
			</div>


			<div class="form-actions">
				<button type="submit">수정 완료</button>
				<button type="button"
					onclick="location.href='galleryBoardView.do?boardIdx=${board.boardIdx}'">취소</button>
			</div>
		</form>
	</main>
	<%@ include file="/WEB-INF/views/common/footer.jsp"%>
</body>
</html>
