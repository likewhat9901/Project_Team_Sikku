<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<title>식꾸</title>
<link rel=stylesheet href="/css/chatbot.css">
<link rel="stylesheet" href="/css/common/layout.css" />
</head>
<body>
	<%@ include file="/WEB-INF/views/common/header.jsp"%>
	
	<h1 class="chat-h">식꾸 챗봇에게 궁금한 것을 물어보세요!</h1>
	<div class="chatstart">
		<div class="chat-box">
			<h4>회원 사용 시</h4>
			<img alt="chatbot-user" src="/images/chatimg.JPG">
		</div>
		<div class="chat-box">
			<h4>비회원 사용 시</h4>
			<img alt="chatbot-nonuser" src="/images/chatimg.JPG">
		</div>

	</div>

	<div class="chat-notice">
		<h4>유의사항</h4>
		<ul>
			<li>팝업 차단을 해제해주세요!</li>
			<li>식꾸는 정확하지 않을 수 있습니다.</li>
		</ul>
	</div>
	<!-- 새창열기로 수정 -->
	<button type="button" class="open-chat" onclick="openChatWindow();">채팅 시작</button>

	<%@ include file="/WEB-INF/views/common/footer.jsp"%>
</body>
</html>
<script>
  let chatWin = null;

  function openChatWindow() {
    const W = 480, H = 780;
    const left = window.screenX + Math.max(0, (window.outerWidth  - W) / 2);
    const top  = window.screenY + Math.max(0, (window.outerHeight - H) / 2);
    const url = '/chat/chatbot.do';

    // 이미 떠 있으면 크기/위치만 맞추고 포커스
    if (chatWin && !chatWin.closed) {
      try {
        chatWin.resizeTo(W, H);
        chatWin.moveTo(left, top);
        chatWin.focus();
      } catch(e) {}
      return;
    }

    // 새창으로 열기
    chatWin = window.open(
      url,
      'AIChatWin',
      `width=${W},height=${H},left=${left},top=${top},` +
      `menubar=no,toolbar=no,location=no,status=no,scrollbars=yes,resizable=yes`
    );
    if (!chatWin) {
      alert('팝업이 차단되었습니다. 브라우저 팝업 허용을 확인해주세요.');
      return;
    }

    try {
        chatWin.resizeTo(W, H);
        chatWin.moveTo(left, top);
      } catch(e) {}

    chatWin.focus();
  }
</script>
