/**
무한 스크롤 구현을 위한 JS
*/

let currentPage = 0;
let loading = false;
let currentSearchWord = ''; // 현재 검색어 저장용

// 페이지 로드시 검색어 확인
document.addEventListener('DOMContentLoaded', function() {
    const urlParams = new URLSearchParams(window.location.search);
    currentSearchWord = urlParams.get('searchWord') || '';
    console.log('현재 검색어:', currentSearchWord);
});

/*
<< 스크롤 감지기 >>
window.scrollY: 현재 스크롤 위치
window.innerHeight: 브라우저 화면 높이
document.body.offsetHeight: 문서 전체 높이
*/
window.addEventListener('scroll', function() {
    if (window.innerHeight + window.scrollY >= document.body.offsetHeight - 200) {
        if (!loading) {
            loadMoreBoards();
        }
    }
});

function loadMoreBoards() {
    loading = true;
    currentPage++;

    console.log('페이지 요청:', currentPage);
    console.log('검색어:', currentSearchWord);

    // 검색어가 있으면 파라미터에 추가
    let url = `/boards/gallery/galleryBoardListMore.do?page=${currentPage}`;
    if (currentSearchWord && currentSearchWord !== '') {
        url += `&searchWord=${encodeURIComponent(currentSearchWord)}`;
    }

    fetch(url)
        .then(response => response.json())
        .then(boards => {
            console.log('받은 데이터:', boards);

            const container = document.getElementById('board-container');

            boards.forEach(board => {
                const div = document.createElement('div');
                div.className = 'board-card';
                div.onclick = () => location.href = `/boards/gallery/galleryBoardView.do?boardIdx=${board.boardIdx}`;
                div.innerHTML = `
                    <input type="hidden" class="board-idx" value="${board.boardIdx}">
                    <div class="board-title">${board.title}</div>
                    <div class="board-content-text">
                        ${board.content.length > 20 ? board.content.substring(0, 20) + '...' : board.content}
                    </div>
                    <div class="board-footer">
                        <span>작성자 : ${board.userId}</span>
                        <span>조회수 : ${board.visitcount} 좋아요 : ${board.likes}</span>
                    </div>
                `;
                container.appendChild(div);
            });

            loading = false;
        })
        .catch(error => {
            console.log('에러:', error);
            loading = false;
        });
}