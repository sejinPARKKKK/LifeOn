<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>LifeOn</title>

<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/forms.css" type="text/css">

<style type="text/css">
.body-title {
	margin-top: 70px;
}

.tab {
	margin-top: 20px;
	font-size: 18px;
}

.tab a{
	display: inline-block;
	padding-left: 5px;
}

.tab a.active {
        font-weight: bold;
        color: #007bff;  
}

.chat-msg-container { display: flex; flex-direction:column; height: 310px; overflow-y: scroll; }
.chat-connection-list { height: 355px; overflow-y: scroll; }
.chat-connection-list span { display: block; cursor: pointer; margin-bottom: 3px; }
.chat-connection-list span:hover { color: #0d6efd }

.msg-right {
    align-self: flex-end;         /* 오른쪽 정렬 */
    text-align: right;            /* 텍스트 오른쪽 정렬 */
    background-color: #DCF8C6;    /* 배경 색상 (예시: WhatsApp 스타일) */
    padding: 8px;                 
    border-radius: 10px;          
    margin: 5px 0;                
    max-width: 70%;               /* 너무 넓게 표시되지 않도록 제한 */
}
.msg-left {
    align-self: flex-start;
    text-align: left;
    background-color: #FFF8DC;
    padding: 8px;
    border-radius: 10px;
    margin: 5px 0;
    max-width: 70%;
    box-shadow: 0 1px 2px rgba(0,0,0,0.1);
}

.sender-name {
    font-size: 0.8em;
    color: #666;
    margin-bottom: 4px;
}

.message-content {
    word-break: break-word;
}


</style>


</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>
	
<main class="d-flex flex-column min-vh-100 align-items-center" style="padding-top: 66px;">
    <div class="container">
		<div class="body-title">
			<h3>
				<i class="bi bi-app"></i> 고객센터
			</h3>	
		</div>
		
		<div class="body-head">
			<div class="tab">
				<a href="${pageContext.request.contextPath}/help">자주묻는질문</a>
				<a class="active" href="${pageContext.request.contextPath}/chat">1:1채팅상담</a>
			</div>
		</div>
			
		<div class="body-main content-frame">
			<div class="row">
				<div class="col-8">
					<p class="form-control-plaintext fs-6"><i class="bi bi-chevron-double-right"></i> 채팅 메시지</p>
					<div class="border p-3 chat-msg-container"></div>
					<div class="mt-2">
						<input type="text" id="chatMsg" class="form-control"
							placeholder="채팅 메세지를 입력하세요..">
					</div>
				</div>
				<div class="col-4">
					<p class="form-control-plaintext fs-6"><i class="bi bi-chevron-double-right"></i> 접속자 리스트 </p>
					<div class="border p-3 chat-connection-list"></div> 
				</div>
			</div>		
		</div>
			
    </div>
</main>

<!-- 귓속말 Modal -->
<div class="modal fade" id="myDialogModal" tabindex="-1" aria-labelledby="myDialogModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="myDialogModalLabel">귓속말</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body pt-1">
				<input type="text" id="chatOneMsg" class="form-control" 
							placeholder="귓속말을 입력 하세요...">
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
$(function() {
	var socket = null;
	var host = '${wsURL}';
	
	if('WebSocket' in window) {
		socket = new WebSocket(host);
	} else if('MozWebSocket' in window) {
		socket = new MozWebSocket(host);
	} else {
		showMessage('<div class="chat-info"> 사용하신 브라우저는 채팅이 불가능합니다.</div>');
		return false;
	}
	
	socket.onopen = function(evt) { onOpen(evt); };
	socket.onmessage = function(evt) { onMessage(evt); };
	socket.onclose = function(evt) { onClose(evt); };
	socket.onerror = function(evt) { onError(evt); };
	
	function onOpen(evt) {
		// 서버에 접속이 성공한 경우
		let uid = '${sessionScope.member.num}';
		let nickName = '${sessionScope.member.nickName}';
		if(! uid ) {
			location.href = '${pageContext.request.contextPath}/member/login';
			return;
		}
		
		showMessage('<div class="msg-right">채팅방에 입장했습니다.<br> 1:1상담은 귓속말로 진행됩니다.</br></div>');
		// 서버 접속이 성공하면 아이디와 이름을 JSON 으로 서버에 전송
		let obj = {};
		obj.type = 'connect';
		obj.uid = uid;
		obj.nickName = nickName;
		
		let jsonStr = JSON.stringify(obj);
		socket.send(jsonStr);
		
		// 채팅입력창에 엔터를 누르면 메세지를 전송하기 위해 #chatMsg에 keydown 이벤트 등록 
		$('#chatMsg').on('keydown', function(evt) {
			
			let key = evt.key || evt.keyCode;
			if(key == 'Enter' || key == 13) {
				sendMessage();
			}
		});
	}
	
	function onClose(evt) {
		
	}
	
	//메시지 전송
	function sendMessage() {
		let msg = $('#chatMsg').val().trim();
		if(! msg) {
			$('#chatMsg').focus();
			return;
		}
		
		let obj = {};
		obj.type = 'message';
		obj.chatMsg = msg;
		
		let jsonStr = JSON.stringify(obj);
		socket.send(jsonStr);
		
		$('#chatMsg').val('');
		
		let out = '<div class="msg-right">' + msg + '</div>';
		showMessage(out);
		
	}
	
	// 귓속말
	$('.chat-connection-list').on('click', 'span', function(){
		let uid = $(this).attr('data-uid');
		let nickName = $(this).text().trim();
		
		$('#chatOneMsg').attr('data-uid', uid);
		$('#chatOneMsg').attr('data-nickName', nickName);
		
		$('#myDialogModalLabel').html('귓속말-' + nickName);
		$('#myDialogModal').modal('show');
	});
	
	const modalEl = document.getElementById('myDialogModal');
	modalEl.addEventListener('show.bs.modal', function(){
		$('#chatOneMsg').on('keydown', function(evt){
			let key = evt.key || evt.keyCode;
			
			if(key === 'Enter' || key === 13) {
				sendOneMessage();
			}
		});
	});
	
	modalEl.addEventListener('hidden.bs.modal', function(){
		$('#chatOneMsg').off('keydown');
		$('#chatOneMsg').val('');
	});
	
	
	
	function onMessage(evt) {
		let data = JSON.parse(evt.data);
		let cmd = data.type;
		
		if(cmd === 'userList') {
			//처음 접속할때 접속자 리스트 받기
			let users = data.users;
			for(let i = 0; i < users.length; i++) {
				let uid = users[i][0];
				let nickName = users[i][1];
				
				let out = '<span id="user-' + uid + '"data-uid="' + uid + '"><i class="bi bi-person-square"></i>'
				+ nickName + '</span>';
				$('.chat-connection-list').append(out);
			}
		} else if(cmd === 'userConnect') {
			//다른 접속자가 접속했을 때 
			let uid = data.uid;
			let nickName = data.nickName;
			
			let out = '<div class="chat-info">' + nickName + '님이 입장하였습니다.</div>';
			showMessage(out);
			
			out = '<span id="user-' + uid + '" data-uid="' + uid + '"><i class="bi bi-person-square"></i>'
			+ nickName + '</span>';
			$('.chat-connection-list').append(out);
		} else if (cmd === 'userDisconnect') {
			//접속자가 나갔을 때 
			let uid = data.uid;
			let nickName = data.nickName;
			
			let out = '<div class="chat-info">' + nickName + '님이 나갔습니다.</div>';
			showMessage(out);
			
			$('#user-' + uid).remove();
			
		} else if(cmd === 'message') {
			let uid = data.uid;
			let nickName = data.nickName;
			let msg = data.chatMsg;
			
			let out = '<div class="msg-left">';
			out += '<div class="sender-name">' + nickName + '</div>';
			out += '<div class="message-content">' + msg + '</div>';
			out += '</div>';
			    
			showMessage(out);
			
		} else if(cmd === 'whisper') {
			let uid = data.uid;
			let nickName = data.nickName;
			let msg = data.chatMsg;
			
			let out = '<div class="user-left">' + nickName + '(귓속)</div>';
			out += '<div class="msg-left">' + msg + '</div>';
			
			showMessage(out);
			
		}  else if(cmd === 'time') {
			console.log(data);
		}
	}
	
	function onError(evt) {
		showMessage('<div class="chat-info">채팅이 불가능합니다.</div>');		
	}
	
	
	function sendOneMessage() {
		// 귓속말 전송
		let msg = $('#chatOneMsg').val().trim();
		if(! msg) {
			$('#chatOneMsg').focus();
			return;
		}
		
		let uid = $('#chatOneMsg').attr('data-uid');
		let nickName = $('#chatOneMsg').attr('data-nickName').trim();
		
		let obj = {};
		obj.type = 'whisper';
		obj.chatMsg = msg;
		obj.receiver = uid;
		
		let jsonStr = JSON.stringify(obj);
		socket.send(jsonStr);
		
		let out = '<div class="msg-right">' + msg + '(' + nickName + ')</div>';
		showMessage(out);
		
		$('#chatOneMsg').val('');
		$('#myDialogModal').modal('hide');
	}
	
});

function showMessage(message) {
	const $EL = $('.chat-msg-container');
	$EL.append(message);
	
	// 스크롤바를 최하단으로 이동
	$EL.scrollTop($EL.prop('scrollHeight'));
}

$(function(){
	$('#myDialogModal').on('hide.bs.modal', function() {
		$('button, input, select, textarea').each(function(){
			$(this).blur();
		});
	});
});

</script>

<footer class="mt-auto py-2 text-center w-100" style="left: 0px; bottom: 0px; background: #F7F9FA;">
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
</body>
</html>