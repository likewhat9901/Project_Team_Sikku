

/**
 무한 스크롤 구현을 위한 JS
 */
 

 let currentPage = 0;
 let loading = false;
 
 /*
 << 스크롤 감지기 >>
 window.scrollY: 현재 스크롤 위치
 window.innerHeight: 브라우저 화면 높이
 document.body.offsetHeight: 문서 전체 높이
 */
 window.addEventListener('scroll', async function(){
	if((window.innerHeight + window.scrollY) >= document.body.offsetHeight - 10 ) {
		if (!loading) {
			loading = true;
			await loadMorePost();
			loading = false;
		}
	}
 });
 
 async function loadMorePost() {
	try {
		console.log("loadMorePosts함수 호출");
		currentPage++;
		// fetch함수를 사용해서 서버에 비동기 요청 보내기
		// pageNum이 0부터 시작하는 Spring Data JPA Pageable에 맞게 수정됨
		const response = await fetch(`freeBoardListMore.do?pageNum=${currentPage}`);
		// fetch가 끝나면, 서버로부터 응답(response) 객체가 오고 그걸 JSON 형식 객체로 변환
		const data = await response.json();
		console.log("서버 응답:", data);
		
		// 서버에서 받은 게시물 리스트를 HTML영역을 만들어 붙임
		const container = document.getElementById('board-container');
		if (!container) {
			console.error("❗ board-container가 존재하지 않습니다. id를 확인해주세요.");
			return;
		}
		
		
		data.content.forEach(row => {
			const card = document.createElement('div');
			card.className = 'board-card';
			card.style.cursor = 'pointer';
			card.onclick = () => location.href = `/freeBoardView.do?boardIdx=${row.boardIdx}`
			card.innerHTML = `
				<div class="board-idx">${row.boardIdx}추가</div>
				<div class="board-title">${row.title}</div>
				<div class="board-content">${row.content}</div>
				<div class="board-footer">
				  <span>${row.memberIdx}</span>
				  <span>${row.likes} · ${row.visitcount}</span>
				</div>
			`;
			container.appendChild(card);
		});
		
		if(data.last) {
			console.log("🛑 마지막 페이지이므로 스크롤 이벤트 제거");
			window.removeEventListener('scroll', arguments.callee);
		}
		
	}
	catch(err) {
		console.error("게시글 추가 로딩 실패", err);
	}
 }