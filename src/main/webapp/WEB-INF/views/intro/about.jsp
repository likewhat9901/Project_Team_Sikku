<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>About</title>
	<link rel="stylesheet" href="/css/common/layout.css" />
	<link rel="stylesheet" href="/css/About.css">
</head>
<body>

<div class="animated-gradient">
    <div class="blobs">
        <div class="blob blob1"></div>
        <div class="blob blob2"></div>
        <div class="blob blob3"></div>
    </div>

    <h1 id="text1" class="main-text1 slide-in">환영합니다</h1>
    <h1 id="text2" class="main-text2 fade-in-up" style="display:none;">식꾸에 오신걸 환영합니다</h1>
    <h1 id="text3" class="main-text2 fade-in-up" style="display:none;">식꾸의 가족이신가요?</h1>

    <div id="buttons" class="button-container fade-in-up" style="display:none;">
        <button class="custom-button" onclick="location.href='myLogin.do'">YES</button>
        <button class="custom-button" onclick="location.href='main/nonMember.do'">NO</button>
    </div>

</div>
<script>
    // 2초 후: 첫 텍스트 사라지기
    setTimeout(() => {
        document.getElementById('text1').classList.add('fade-out');
    }, 2000);

    // 3초 후: text1 숨기고 text2 표시
    setTimeout(() => {
        document.getElementById('text1').style.display = 'none';
        document.getElementById('text2').style.display = 'block';
    }, 3000);

    // 4.5초 후: text2 숨기고 text3 표시
    setTimeout(() => {
        document.getElementById('text2').style.display = 'none';
        document.getElementById('text3').style.display = 'block';
    }, 5000);

    // 6초 후: 버튼과 링크 표시
    setTimeout(() => {
        document.getElementById('buttons').style.display = 'flex';
        document.getElementById('footer-text').style.display = 'block';
    }, 6000);
</script>

</body>
</html>
