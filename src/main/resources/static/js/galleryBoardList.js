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

    let url = `/boards/gallery/galleryBoardListMore.do?page=${currentPage}`;
    if (currentSearchWord && currentSearchWord !== '') {
        url += `&searchWord=${encodeURIComponent(currentSearchWord)}`;
    }

    fetch(url)
        .then(response => response.json())
        .then(data => {
            console.log('받은 데이터:', data);
            
            const container = document.querySelector('.feed-container');
            
            data.rows.forEach(row => {
                const div = document.createElement('div');
                div.className = 'feed-post';
                div.style.cursor = 'pointer';
                div.onclick = () => location.href = `/boards/gallery/galleryBoardView.do?boardIdx=${row.boardIdx}`;
                
                div.innerHTML = `
                    <div class="feed-header">
                        <img src="/images/프로필.png" alt="profile" class="profile-img">
                        <span class="username">${row.userId}</span>
                    </div>
                    
                    <div class="feed-image">
                        <img src="/uploads/board/${data.imageMap[row.boardIdx]}" alt="게시물이미지">
                    </div>
                    
                    <div class="feed-actions">
                        ❤️ &nbsp ${data.likesCountMap[row.boardIdx]} &nbsp&nbsp
                        💬 &nbsp ${data.commentCountMap[row.boardIdx]}
                    </div>
                    
                    <div class="feed-content">
                        <span class="username">${row.userId}</span>
                        ${row.content && row.content.length > 50 ? row.content.substring(0, 50) + '...' : row.content || ''}
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