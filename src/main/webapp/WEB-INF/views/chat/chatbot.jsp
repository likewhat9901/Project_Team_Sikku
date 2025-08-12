<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<title>식꾸</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.1.4/sockjs.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<style>
.open-chat {
	display: block;
	margin: 20px auto;
	background-color: #4CAF50; /* 초록색 배경 */
	color: white; /* 글자 색상 흰색 */
	padding: 12px 24px; /* 위아래 12px, 좌우 24px 여백 */
	font-size: 16px; /* 글자 크기 */
	border: none; /* 테두리 없애기 */
	border-radius: 6px; /* 둥근 모서리 */
	cursor: pointer; /* 마우스 포인터가 손가락 모양 */
	transition: background-color 0.3s ease; /* 배경색 부드럽게 전환 */
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* 살짝 그림자 */
}

.open-chat:hover {
	background-color: #45a049; /* 호버 시 조금 더 진한 초록색 */
}

.message {
	padding: 5px;
	margin: 5px;
	border-radius: 5px;
	max-width: 80%;
}

.user-message {
	background-color: #DCF8C6;
	text-align: right;
	float: right;
	clear: both;
}

.ai-message {
	background-color: #EDEDED;
	text-align: left;
	float: left;
	clear: both;
}

#chatArea {
	height: 300px;
	overflow-y: scroll;
	border: 1px solid black;
	padding: 10px;
}

/* 입력과 버튼을 한 줄에 배치하는 컨테이너 */
.chat-inputarea {
	display: flex;
	gap: 8px;
}

/* 텍스트 입력창 */
.chat-input {
	flex-grow: 1;
	padding: 8px;
	font-size: 14px;
	box-sizing: border-box;
	border: 1px solid #ccc;
	border-radius: 4px;
}

/* 전송 버튼 */
.send-button {
	background-color: #007bff;
	border: none;
	color: white;
	padding: 0 16px;
	font-size: 14px;
	border-radius: 4px;
	cursor: pointer;
	transition: background-color 0.2s ease;
}

.send-button:hover {
	background-color: #0056b3;
}

.chat-h{
	padding: 20px;
	text-align: center;	
}
.chatstart {
	display: flex;
	justify-content: center; /* 가운데 정렬 */
	gap: 30px; /* 박스 사이 간격 */
}

.chat-box {
	flex: 1; /* 동일한 비율로 공간 차지 */
	max-width: 500px; /* 최대 너비 제한 */
}

.chat-notice {
	text-align: center;
}

.chat-notice ul {
	list-style-position: inside; /* 불릿 안쪽으로 */
	padding: 0;
	margin: 0;
}
</style>

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
			<li>부적절한 사용시 제제가 있을 수 있습니다.</li>
			<li>식꾸는 정확하지 않을 수 있습니다.</li>
		</ul>
	</div>
	<button type="button" class="open-chat" data-toggle="modal"
		data-target="#chatModal">채팅 시작</button>
	<!-- Modal -->
	<div class="modal fade" id="chatModal" tabindex="-1"
		aria-labelledby="chatModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="chatModalLabel">Chat with AI</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<div class="">
						<label for="username">Username:</label> <input type="hid-den"
							id="username" readonly class="chat-username"
							value="<sec:authentication property='name'/>" />
						<!-- 
						연결하기
						<button id="connectBtn" class="btn btn-secondary">Connect</button>
						 -->
					</div>

					<br />
					<div id="chatArea"></div>
					<br />

					<div class="chat-inputarea">
						<textarea id="message" class="chat-input"></textarea>
						<button id="sendBtn" class="send-button">Send</button>
					</div>
				</div>
			</div>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/common/footer.jsp"%>
</body>
</html>
<script type="text/javascript">
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

	//메시지 띄우기
	function showMessage(message) {
		var messageElement = $('<div class="message ai-message"></div>');
		messageElement.text(message.sender + ': ' + message.content);
		$('#chatArea').append(messageElement);
		$('#chatArea').scrollTop($('#chatArea')[0].scrollHeight); // 스크롤을 아래로
	}

	function showUserMessage(message) {
		var messageElement = $('<div class="message user-message"></div>');
		messageElement.text(message.sender + ': ' + message.content);
		$('#chatArea').append(messageElement);
		$('#chatArea').scrollTop($('#chatArea')[0].scrollHeight); // 스크롤을 아래로
	}

	$(function() {
		// 모달 열리면 자동 연결
		$('#chatModal').on('shown.bs.modal', function() {
			if (!stompClient)
				connect();
		});

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