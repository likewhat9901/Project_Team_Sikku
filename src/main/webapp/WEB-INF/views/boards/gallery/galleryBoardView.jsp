<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>

<link rel="stylesheet" href="/css/gallery.css">

<!-- JS import -->
<script src="/js/galleryBoardView.js"></script>


</head>
<body>
	<%@ include file="/WEB-INF/views/common/header.jsp"%>
	<!-- 헤더 -->
	<header class="main-header">
		<h1> </h1>
	</header>

	<!-- 본문 -->
	<main class="board-detail">
	
	
		<!-- 게시물 이미지 -->
		<div class="Gallery-image-container">
		    <button id="prevBtn" class="carousel-btn prev-btn">‹</button>
		
		    <div class="carousel-inner">
		        <c:forEach var="image" items="${imageFiles}" varStatus="loop">
		            <div class="carousel-item ${loop.first ? 'active' : ''}">
		                <img src="/uploads/board/${image}" alt="게시물이미지">
		            </div>
		        </c:forEach>
		    </div>
		
		    <button id="nextBtn" class="carousel-btn next-btn">›</button>
		</div>


		<div class="Gallery-content-container">
			<input type="hidden" name="boardIdx" value="${board.boardIdx}">
	
			<div class="board-title">
				<h2>${board.title}</h2>
			</div>
			<div class="board-writer">
				<h4>${board.userId}</h4>
			</div>
			<br> <span>🕒 ${beFormattedDate} 👁‍🗨 ${board.visitcount}</span>
	
			<hr>
	
			<div class="board-content">
				<div>${board.content}</div>
			</div>
	
			<div class="board-view-footer">
				<div class="like-group" style="display: flex; align-items: center;">
				    <button type="button" id="board-like-btn" data-board-idx="${board.boardIdx}">
				        <span id="heart-icon">
				            <c:choose>
				                <c:when test="${isLiked}"> 🧡 </c:when>
				                <c:otherwise> 🤍 </c:otherwise>
				            </c:choose>
				        </span>
				        좋아요 <span id="likes-count">${likesCount}</span>
				    </button>
				</div>
	
				<c:if test="${board.userId == loginUserId}">
					<div class="board-actions">
						<!-- 수정 폼 -->
						<form action="/boards/gallery/galleryBoardEdit.do" method="get" >
							<input type="hidden" name="boardIdx" value="${board.boardIdx}" />
							<button type="submit">수정</button>
						</form>
	
						<!-- 삭제 폼 -->
						<form action="/boards/gallery/galleryBoardDelete.do" method="get"
							onsubmit="return confirm('삭제하시겠습니까?');">
							<input type="hidden" name="boardIdx" value="${board.boardIdx}" />
							<button type="submit">삭제</button>
						</form>
					</div>
				</c:if>
			</div>
	
	
	
	
	
		</main>
	
		<!-- 댓글 작성 폼 -->
		<div class="comment-write-form">
			<h3>댓글 작성</h3>
			<form action="/boards/gallery/galleryBoardCommentWriteProc.do" method="post"
				onsubmit="return validateCommentForm()">
				<input type="hidden" name="boardIdx" value="${board.boardIdx}" />
				<input type="hidden" name="userId" value="${loginUserId}" />
				<div class="comment-input-area">
					<textarea name="content" class="comment-write-textarea"
						placeholder="댓글을 작성해주세요."></textarea>
					<button type="submit" class="btn btn-add">댓글 등록</button>
				</div>
			</form>
		</div>
	
		<!-- 댓글 목록 출력  -->
		<div id="comment-container" class="comment-container">
			<h3>댓글 (${comment.size()}개)</h3>
	
			<c:forEach items="${comment}" var="c" varStatus="vs">
				<div class="comment-card">
					<div class="comment-header">
						<div class="comment-author">작성자: ${c.member.userId}</div>
						<div class="comment-date">${ceFormattedDate}</div>
					</div>
	
					<!-- 댓글 내용 (일반 보기 모드) -->
					<div id="content-${c.commentIdx}" class="comment-content">
						${c.content}</div>
	
					<!-- 댓글 수정 폼 (기본 숨김) -->
					<form id="editForm-${c.commentIdx}" class="comment-edit-form"
						action="/boards/gallery/galleryBoardCommentEditProc.do" method="post"
						style="display: none;"
						onsubmit="return validateEditForm('${c.commentIdx}')">
	
						<!-- 댓글 수정에 필요한 hidden 필드들 -->
						<input type="hidden" name="commentIdx" value="${c.commentIdx}" />
						<input type="hidden" name="boardIdx" value="${board.boardIdx}" />
						<input type="hidden" name="userId" value="${c.member.userId}" />
	
						<textarea name="content" class="comment-edit-textarea" rows="4">${c.content}</textarea>
						<div class="form-actions">
							<button type="submit" class="btn btn-edit">수정완료</button>
							<button type="button" class="btn btn-cancel"
								onclick="toggleEditForm('${c.commentIdx}')">취소</button>
						</div>
					</form>
	
					<div class="comment-footer">
						<span class="likes-count"> </span>
	
						<c:if test="${c.member.userId == loginUserId}">
							<div id="actions-${c.commentIdx}" class="comment-actions-btn">
								<!-- 수정 버튼 (폼 토글) -->
								<button type="button" id="editBtn-${c.commentIdx}"
									class="btn btn-edit" onclick="toggleEditForm('${c.commentIdx}')">수정</button>
	
								<!-- 삭제 버튼 -->
								<button type="button" class="btn btn-delete"
									onclick="return confirmDeleteWithLink('/boards/gallery/galleryBoardCommentDelete.do?commentIdx=${c.commentIdx}&boardIdx=${board.boardIdx}')">
									삭제</button>
							</div>
						</c:if>
					</div>
				</div>
			</c:forEach>
	
		</div>
		</div>
	<%@ include file="/WEB-INF/views/common/footer.jsp"%>
</body>
</html>