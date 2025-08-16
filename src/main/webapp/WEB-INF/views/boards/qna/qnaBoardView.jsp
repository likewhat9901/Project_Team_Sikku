<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Q&A 상세보기</title>
  <link rel="stylesheet" href="/css/common/layout.css">
  <link rel="stylesheet" href="/css/qnaBoardView.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

	<div class="qna-view-container">
		<div class="qna-view-header">
			<h1 class="title">${ qna.title }</h1>
			<c:if test="${userRole == 'ROLE_ADMIN'}">
				<button type="button" onclick="toggleAnswerForm()">관리자 답변</button>
			</c:if>
		</div>
		
		<div class="qna-post-info">
			<div class="left-info">
				<span class="writer">작성자: ${ qna.writer }</span>
				<span class="date post">
				작성일: ${ qna.formattedPostdate }
				</span>
				<span class="date update">
				수정일: ${ qna.formattedUpdatedate }
				</span>
				<span class="views">조회수: ${ qna.views }</span>
			</div>
			
			<span class="likes" onclick="likePost(${qna.idx})">
			    <c:choose>
			        <c:when test="${alreadyLiked}">
			            <i id="heartIcon" class="fa-solid fa-heart" style="color:#e91e63;"></i>
			        </c:when>
			        <c:otherwise>
			            <i id="heartIcon" class="fa-regular fa-heart" style="color:#999;"></i>
			        </c:otherwise>
			    </c:choose>
				<span id="likeCount">${qna.likes}</span>
			</span>
		</div>
		
		<div class="qna-view-content">
			<pre>${ qna.content }</pre>
		</div>
		
		<div id="answer-box" class="qna-view-answer">
			<h3>📌 답변</h3>
		
		<c:if test="${ not empty qna.answercontent }">
			<pre id="answer-pre">${qna.answercontent}</pre>
		</c:if>
		
			<!-- 2. 버튼 누르면 이 textarea/form이 보여짐 -->
			<form id="answer-form" action="/qnaBoardAnswer.do" method="post" style="display:none;">
				<input type="hidden" name="idx" value="${qna.idx}" />
				<textarea name="answercontent" rows="6" cols="80">${qna.answercontent}</textarea><br>
				<button type="submit">답변 등록</button>
			</form>
		</div>
	
		
		<div class="qna-view-buttons">
			<button onclick="location.href='/qnaBoardList.do'">목록</button>
			<c:if test="${ qna.writerid == userId }">
				<button onclick="location.href='/qnaBoardEdit.do?idx=${ qna.idx }'">수정</button>
				<button onclick="if(confirm('정말 삭제할까요?')) location.href='/qnaBoardDelete.do?idx=${ qna.idx }'">삭제</button>
			</c:if>
			
		</div>
	</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>

<!-- 관리자 답변등록 버튼 토글 -->
<script>
function toggleAnswerForm() {
    const pre = document.getElementById('answer-pre');
    const form = document.getElementById('answer-form');

    if (form.style.display === 'block') {
        form.style.display = 'none';
        if (pre) pre.style.display = 'block';
    } else {
        form.style.display = 'block';
        if (pre) pre.style.display = 'none';
    }
}
</script>

<!-- 좋아요 버튼 -->
<script>
function likePost(idx) {
    fetch('/qnaBoardLike.do', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json' // JSON 형식으로 보낼 거라는 뜻
        },
        body: JSON.stringify({ idx: idx }) // idx 값을 JSON 형태({ "idx": 123 })로 바꿔서 보내는 것
    })
    .then(response => response.json()) // 서버가 응답한 결과를 JSON 형식으로 파싱. 예: { "success": true, "likes": 42 }
    .then(data => {
        if (data.success) { // success가 true일때
            const countSpan = document.getElementById('likeCount');
            countSpan.textContent = data.likes; // 서버가 보내준 최신 좋아요 수로 업데이트
            
         	// 하트 아이콘 변경
            const heartIcon = document.getElementById('heartIcon');
            if (data.liked) {
                heartIcon.classList.remove('fa-regular');
                heartIcon.classList.add('fa-solid');
                heartIcon.style.color = '#e91e63';  // 좋아요 누른 경우 색도 바꾸면 더 좋음
            } else {
                heartIcon.classList.remove('fa-solid');
                heartIcon.classList.add('fa-regular');
                heartIcon.style.color = '#999';  // 좋아요 취소한 경우 색 복원
            }
        } else {
            alert(data.message);
        }
    })
    .catch(error => {
        console.error("좋아요 에러 발생:", error);
        alert("서버 오류 발생 (좋아요)");
    });
}
</script>
</html>
