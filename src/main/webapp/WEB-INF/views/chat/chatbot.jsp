<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Chat with AI</title>
<!-- Bootstrap / 기타 CSS -->
<link rel=stylesheet href="/css/chatbot.css">
<link rel="stylesheet" href="/css/common/layout.css" />
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
<style>
</style>
</head>
<body>
	<div class="chat-body">
	<h4 class="mb-3">🍀 식꾸 AI 챗봇</h4>
	<h6 class="mb-3">모르는 것을 질문해 보세요!</h6>
		<div class="">
			<!-- 
			<label for="username">Username:</label> 			
			 -->
			<input type="hidden"
				id="username" readonly class="chat-username"
				value="<sec:authentication property='name'/>" />
			<!-- 
			연결하기
			<button id="connectBtn" class="btn btn-secondary">Connect</button>
			 -->
		</div>

		<div id="chatArea" class="chat-window">
		<!-- 메시지 스크롤 되는 영역 -->
		<div id="chatList" class="chat-scroll"></div>
		<!-- 입력 영역 -->
		<div class="chat-inputarea">
			<textarea id="message" class="chat-input"></textarea>
			<button id="sendBtn" class="send-button">Send</button>
		</div>
		</div>
		<br />

	</div>	
</body>
<!-- JS 라이브러리 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.1.4/sockjs.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script>
var stompClient = null;

  // 컨텍스트 경로
  const ctx = '${pageContext.request.contextPath}';
	
  //연결
  function connect() {
	var socket = new SockJS(ctx + '/myChatServer');
	stompClient = Stomp.over(socket);
	stompClient.connect({}, function(frame) {
	  console.log('Connected: ' + frame);
	  stompClient.subscribe('/topic/messages', function(response) {
		showMessage(JSON.parse(response.body));
	  });
	});
  }
	
  //사용자가 메시지 보내기
  function sendMessage() {
	var messageContent = $('#message').val();
	var username = $('#username').val();
	var chatMessage = {
	  content : messageContent,
	  sender : username
	};
	stompClient.send('/app/chat.sendMessage', {}, JSON
		.stringify(chatMessage));
	$('#message').val('');
	showUserMessage(chatMessage); // 사용자의 메시지를 바로 표시
  }
  
  function escapeHtml(s){
	  return String(s)
	    .replace(/&/g,"&amp;").replace(/</g,"&lt;")
	    .replace(/>/g,"&gt;").replace(/"/g,"&quot;")
	    .replace(/'/g,"&#39;");
	}
  function nl2br(s){ 
	return escapeHtml(s).replace(/\n/g,"<br>"); 
  }
  // 사용자, ai 공통 템플릿
  function bubbleHtml(sender, text, role){
    const isUser = role === 'user';
    const name = isUser ? sender : (sender || 'AI');
    return (
    		'<div class="message-row ' + (isUser ? 'user' : 'ai') + '">' +
    	      (isUser ? '' : '<div class="avatar">🍀</div>') +
    	      '<div class="bubble">' +
    	        '<div class="meta">' + escapeHtml(name) + '</div>' +
    	        '<div class="text">' + nl2br(text) + '</div>' +
    	      '</div>' +
    	      (isUser ? '<div class="avatar me">🙂</div>' : '') +
    	    '</div>');
  }
  //메시지 띄우기
  function showMessage(message){
    $('#chatList').append(bubbleHtml(message.sender, message.content, 'ai'));
    $('#chatList').scrollTop($('#chatList')[0].scrollHeight);
  }

  function showUserMessage(message){
    $('#chatList').append(bubbleHtml(message.sender, message.content, 'user'));
    $('#chatList').scrollTop($('#chatList')[0].scrollHeight);
  }
	
  $(function() {
	// 새창 열리면 자동 연결
	connect();
	
	$('#connectBtn').click(connect);
	$('#sendBtn').click(sendMessage);
	// Enter로 전송
	$('#message').on('keydown', function(e) {
		if (e.key === 'Enter' && !e.shiftKey) {
			e.preventDefault();
			sendMessage();
		}
	});
  });
</script>
</html>
