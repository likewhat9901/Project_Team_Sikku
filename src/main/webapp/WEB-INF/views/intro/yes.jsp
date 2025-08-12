<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="/css/common/layout.css" />
	<link rel="stylesheet" href="/css/About.css">
	<title>Insert title here</title>
</head>
<body>
	<div class="animated-gradient">
    <div class="blobs">
        <div class="blob blob1"></div>
        <div class="blob blob2"></div>
        <div class="blob blob3"></div>
    </div>
    
   <h1 id="text2" class="main-text2 fade-in-up" style="display: none;">
  🌿 어떤 식물을 기르시고 계신가요?
</h1>

</body>
<script>
setTimeout(() => {
	  const text2 = document.getElementById('text2');
	  text2.style.display = 'block';

	  // 트리거 클래스 추가
	  setTimeout(() => {
	    text2.classList.add('show');
	  }, 50); 
	}, 50);
</script>

</html>