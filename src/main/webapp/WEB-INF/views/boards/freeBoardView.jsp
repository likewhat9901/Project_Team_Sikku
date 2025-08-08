
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<<<<<<< HEAD
	<meta charset="UTF-8">
	<title>freeBoardList</title>
=======
<meta charset="UTF-8">
<title>freeBoardList</title>
>>>>>>> 2693aab (backup: 최초 상태)

<style>
<!-- CSS - Header  -->
.main_container {
    width: 100%;
    min-height: 100vh;
}

.main_header {
    background: white;
    padding: 15px 30px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.main_logo {
    font-size: 18px;
    font-weight: 600;
    color: #333;
}

.main_nav {
    display: flex;
    gap: 30px;
}

.main_nav a {
    text-decoration: none;
    color: #666;
    font-weight: 500;
    padding: 8px 16px;
    border-radius: 6px;
    transition: background-color 0.3s;
}

.main_nav a:hover {
    background-color: #f0f0f0;
    color: #333;
}

.main_nav .active {
    background-color: #333;
    color: white;
}
<!--------------------------------------------------------------------- -->

<!-- CSS - Body  -->
<style>
    body {
      font-family: 'sans-serif';
      background: #f9f9f9;
      margin: 0;
      padding: 1rem;
    }

    .post-container {
      max-width: 800px;
      margin: 2rem auto;
      background: white;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      padding: 2rem;
    }

    .post-header {
      border-bottom: 1px solid #eee;
      padding-bottom: 1rem;
      margin-bottom: 1rem;
    }

    .post-title {
      font-size: 1.6rem;
      font-weight: bold;
    }

    .post-meta {
      color: #888;
      font-size: 0.9rem;
      margin-top: 0.5rem;
    }

    .post-content {
      font-size: 1rem;
      line-height: 1.6;
      margin: 1.5rem 0;
    }

    .post-actions {
      display: flex;
      justify-content: flex-end;
      gap: 10px;
      margin-bottom: 2rem;
    }

    .post-actions button {
      padding: 6px 12px;
      border: none;
      border-radius: 4px;
      background-color: #eee;
      cursor: pointer;
      transition: background-color 0.3s;
    }

    .post-actions button:hover {
      background-color: #ccc;
    }

    .comment-section {
      border-top: 1px solid #eee;
      padding-top: 1.5rem;
    }

    .comment {
      margin-bottom: 1rem;
      padding-bottom: 0.5rem;
      border-bottom: 1px solid #f0f0f0;
    }

    .comment-author {
      font-weight: bold;
      margin-bottom: 0.3rem;
    }

    .comment-text {
      color: #444;
    }

    .comment-form {
      margin-top: 2rem;
      display: flex;
      flex-direction: column;
      gap: 0.5rem;
    }

    .comment-form textarea {
      width: 100%;
      height: 80px;
      padding: 0.5rem;
      font-size: 1rem;
      border: 1px solid #ccc;
      border-radius: 6px;
      resize: none;
    }

    .comment-form button {
      align-self: flex-end;
      padding: 8px 16px;
      background-color: #333;
      color: white;
      border: none;
      border-radius: 6px;
      cursor: pointer;
    }
  </style>

</style>

<!-- 
<script>
  window.addEventListener('scroll', function() {
    if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight) {
      // 여기에 Ajax 호출 혹은 게시물 추가 함수 넣기
    }
  });
</script>
 -->
</head>

<!-- 헤더 -->
<header class="main_header">
    <div class="main_logo">Site name</div>
    <nav class="main_nav">
        <a href="/">메인</a>
        <a href="/freeBoardList.do" class="active">커뮤니티</a>
        <a href="#">다이어리</a>
        <a href="/info.do">식물도감</a>
    </nav>
</header>
	      
	      
<body>
	
<div class="post-container">
  <div class="post-header">
    <div class="post-title">게시물 제목</div>
    <div class="post-meta">
      작성자: 가나디 · 날짜: 11:11 · 조회수: 24 · 좋아요: 10
    </div>
  </div>

  <div class="post-content">
    글 내용 블라블라블라
  </div>

  <div class="post-actions">
    <form action="/freeboardEdit" method="get">
      <input type="hidden" name="idx" value="#" />
      <button type="submit">수정</button>
    </form>
    <form action="/freeboardDelete" method="post">
      <input type="hidden" name="idx" value="#" />
      <button type="submit" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
    </form>
    <form action="/freeboardLike" method="post">
      <input type="hidden" name="idx" value="#" />
      <button type="submit">좋아요</button>
    </form>
    <form action="/freeboardReport" method="post">
      <input type="hidden" name="idx" value="#" />
      <button type="submit">신고</button>
    </form>
  </div>

  <div class="comment-section">
    <h4>댓글</h4>
    <c:forEach items="#" var="comment">
      <div class="comment">
        <div class="comment-author">헬로키티</div>
        <div class="comment-text">어쩌궁 저쩌궁</div>
      </div>
    </c:forEach>

    <form action="/freeboardComment" method="post" class="comment-form">
      <textarea name="commentContent" placeholder="댓글을 입력하세요..."></textarea>
      <input type="hidden" name="boardIdx" value="#" />
      <button type="submit">댓글 작성</button>
    </form>
  </div>
</div>
	

</body>
</html>