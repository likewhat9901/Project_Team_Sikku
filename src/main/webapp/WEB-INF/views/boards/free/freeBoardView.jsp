<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자유게시판 상세보기</title>

<link rel="stylesheet" href="/css/free.css">

<!-- JS import -->
<script src="/js/freeBoardView.js"></script>

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
	        <span>${board.userId}</span>
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
	    
	    <button></button>
	    
	</main>

		<!-- 댓글 작성 폼 -->
	<div class="comment-write-form">
		<h3>댓글 작성</h3>
		<form action="/boards/free/freeBoardCommentWriteProc.do" method="post" onsubmit="return validateCommentForm()">
		    <input type="hidden" name="boardIdx" value="${board.boardIdx}" />
		    <input type="hidden" name="userId" value="dada" /> <!-- 실제로는 로그인된 사용자 ID -->
		    <textarea name="content" class="comment-write-textarea" placeholder="댓글을 작성해주세요."></textarea>
		    <div class="form-actions">
		    	<button type="submit" class="btn btn-edit">댓글 등록</button>
		    </div>
		</form>
	</div>
	
	<!-- 댓글 목록 출력  -->
  	<div id="comment-container" class="comment-container">
  		<h3>댓글 (${comment.size()}개)</h3>
		
		<c:forEach items="${comment}" var="c" varStatus="vs">
			<div class="comment-card">
				<div class="comment-header">
					<div class="comment-author">
						작성자: ${c.member.userId}
					</div>
					<div class="comment-date">
						${c.postDate}
					</div>
				</div>
				
				<!-- 댓글 내용 (일반 보기 모드) -->
				<div id="content-${c.commentIdx}" class="comment-content">
					${c.content}
				</div>

				<!-- 댓글 수정 폼 (기본 숨김) -->
				<form id="editForm-${c.commentIdx}"
					class="comment-edit-form"
					action="/boards/free/freeBoardCommentEditProc.do" 
					method="post"
					style="display: none;"
					onsubmit="return validateEditForm('${c.commentIdx}')">
					
					<!-- 댓글 수정에 필요한 hidden 필드들 -->
					<input type="hidden" name="commentIdx" value="${c.commentIdx}" />
					<input type="hidden" name="boardIdx" value="${board.boardIdx}" />
					<input type="hidden" name="userId" value="${c.member.userId}" /> 
					
					<textarea name="content" class="comment-edit-textarea" rows="4">${c.content}</textarea>
					<div class="form-actions">
						<button type="submit" class="btn btn-edit">수정완료</button>
						<button type="button" class="btn btn-cancel" onclick="toggleEditForm('${c.commentIdx}')">취소</button>
					</div>
				</form>

				<div class="comment-footer">
					<span class="likes-count">좋아요 ${c.likes}</span>
					
					<div class="comment-actions">
						<!-- 수정 버튼 (폼 토글) -->
						<button type="button" 
								id="editBtn-${c.commentIdx}"
								class="btn btn-edit" 
								onclick="toggleEditForm('${c.commentIdx}')">수정</button>
						
						<!-- 삭제 버튼 -->
						<a href="/boards/free/freeBoardCommentDelete.do?commentIdx=${c.commentIdx}&boardIdx=${board.boardIdx}" 
							class="btn btn-delete"
							onclick="return confirmDelete()">삭제</a>
					</div>
				</div>
			</div>
		</c:forEach> 
	  
	</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
