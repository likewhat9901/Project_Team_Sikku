<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자유게시판 상세보기</title>
<!-- CSS import -->
<link rel="stylesheet" href="/css/free.css">
<link rel="stylesheet" href="/css/member.css">
<script>
// 댓글 수정 폼을 토글하는 함수
function toggleEditForm(commentIdx) {
    // 해당 commentIdx에 맞는 폼 요소를 찾습니다.
    // 백틱(`)을 사용하여 템플릿 리터럴로 ID 문자열을 생성합니다.
    const form = document.getElementById(`editForm-${commentIdx}`);
    
    // 폼 요소가 제대로 찾아졌는지 확인합니다.
    if (form) {
        // 현재 display 상태에 따라 'block' (보이기) 또는 'none' (숨기기)으로 토글합니다.
        if (form.style.display === "none") {
            form.style.display = "block"; // 폼 보이기
        } else {
            form.style.display = "none"; // 폼 숨기기
        }
    } else {
        // 폼을 찾지 못했을 경우 콘솔에 에러 메시지를 출력하여 디버깅에 도움을 줍니다.
        console.error(`Error: Form with ID 'editForm-${commentIdx}' not found. Check commentIdx value and form ID.`);
    }
}
</script>

</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
	<!-- 헤더 -->
	<header class="main-header">
	    <h1>자유게시판 상세보기</h1>
	</header>

	<!-- 본문 -->
	<main class="board-detail">
	
	    <div class="board-boardIdx">
	        <label>게시물일련번호:</label>
	        <span>${board.boardIdx}</span>
	    </div>
	    
	    <div class="board-title">
	        <label>제목:</label>
	        <span>${board.title}</span>
	    </div>
	    <div class="board-writer">
	        <label>작성자:</label>
	        <span>${board.memberIdx}</span>
	    </div>
	    <div class="board-date">
	        <label>작성일:</label>
	        <span>${board.postdate}</span>
	    </div>
	    <div class="board-visit">
	        <label>조회수:</label>
	        <span>${board.visitcount}</span>
	    </div>
	    <div class="board-content">
	        <label>내용:</label>
	        <div>${board.content}</div>
	    </div>
	</main>

	<!-- 버튼 영역 -->
	<div class="board-buttons">
	    <a href="/boards/free/freeBoardList.do">목록</a>
	    <a href="/boards/free/freeBoardEdit.do?boardIdx=${board.boardIdx}">수정</a>
	    <a href="/boards/free/freeBoardDelete.do?boardIdx=${board.boardIdx}"
	    	onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
	</div>
	
	<!-- 댓글 작성 폼 -->
	<form action="/boards/free/freeBoardCommentWriteProc.do" method="post">
	
		<h2>@@@@@ 댓글 영역 @@@@@</h2>
		
		<p>board.boardIdx</p>
	    <input type="hidden" name="boardIdx" value="${board.boardIdx}" />
	    <p>member.memberIdx</p>
	    <input type="hidden" name="memberIdx" value="${member.memberIdx}" />
	    <textarea name="content" placeholder="댓글을 작성해주세요."></textarea>
	    <button type="submit">댓글 등록</button>
	    
	</form>
	
	<!-- 댓글 목록 출력  -->
  	<div id="comment-container" class="comment-container">
	
		<c:forEach items="${comment}" var="c" varStatus="vs">
			<div class="comment-card">
				<p>c.commentIdx</p>
				<!-- 이 input은 댓글 수정 폼 내부에만 필요하므로 여기서는 제거 -->
				
				<p>c.member.memberIdx</p>
		      	<span>${c.member.memberIdx}</span>
		      	<p>c.board.boardIdx</p>
		    	<div class="comment-idx">${c.board.boardIdx}</div>
			    <div class="comment-content">${c.content}</div>

				<div class="comment-footer">
					<span>${c.likes}</span>

					<!-- 수정 버튼 (폼 토글) -->
					<!-- onclick에 commentIdx를 숫자로 전달합니다. -->
					<button type="button" onclick="toggleEditForm(${c.commentIdx})">수정</button>
					
					<!-- 댓글 수정 폼 (기본 숨김) -->
					<!-- id 속성을 JavaScript 함수에서 참조할 수 있도록 정확히 설정합니다. -->
					<form id="editForm-${c.commentIdx}"
						action="/boards/free/freeBoardCommentEditProc.do" method="post"
						style="display: none; margin-top: 5px;">
						
						<!-- 댓글 수정에 필요한 hidden 필드들 -->
						<input type="hidden" name="commentIdx" value="${c.commentIdx}" />
						<input type="hidden" name="boardIdx" value="${board.boardIdx}" />
						<!-- memberIdx도 필요하다면 추가 -->
						<input type="hidden" name="memberIdx" value="${c.member.memberIdx}" /> 
						
						<textarea name="content" rows="3" cols="50">${c.content}</textarea>
						<button type="submit">수정완료</button>
						<button type="button" onclick="toggleEditForm(${c.commentIdx})">취소</button>
					</form>

					<!-- 삭제 -->
					<a href="/boards/free/freeBoardCommentDelete.do?commentIdx=${c.commentIdx}"
						onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
				</div>
			</div>
		</c:forEach> 
	  
	</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
