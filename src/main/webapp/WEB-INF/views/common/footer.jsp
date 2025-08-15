<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link rel="stylesheet" href="/css/common/footer.css">

</div>
<div class="floating-nav">
  <button onclick="location.href='#'">Top ↑</button>
  <button onclick="location.href='/chat/chatstart.do'">AI채팅</button>
  <button onclick="window.open('/checkout', 'checkoutPopup', 'width=600,height=700,resizable=yes,scrollbars=yes')">구독하기</button>
  <button onclick="location.href='/qna/qnaBoard.do'">QnA</button>
</div>
<footer class="oopy-my-footer">
    <div class="oopy-my-footer-mobile-toggle" id="footer-toggle">
        <h3>(주)Oopy</h3>
        <span class="oopy-my-footer-mobile-toggle-button">▼</span>
    </div>
    
    <div class="oopy-my-footer-container" id="footer-content">
        <div class="oopy-my-footer-column">
            <h3>(주)Oopy</h3>
            <p>대표이사: 홍길동</p>
            <p>사업자등록번호: 123-45-67890</p>
            <p>주소: 서울특별시 강남구 테헤란로 123</p>
        </div>
        
        <div class="oopy-my-footer-column">
            <h3>바로가기</h3>
            <ul>
                <li><a href="/about">회사소개</a></li>
                <li><a href="/terms">이용약관</a></li>
                <li><a href="/privacy">개인정보처리방침</a></li>
            </ul>
        </div>
        
        <div class="oopy-my-footer-column">
            <h3>소셜</h3>
            <div class="oopy-my-footer-social-links">
                <a href="https://instagram.com" target="_blank" rel="noopener noreferrer" aria-label="Instagram">
                    <svg role="img" viewbox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><title>Instagram</title><path d="M12 0C8.74 0 8.333.015 7.053.072 5.775.132 4.905.333 4.14.63c-.789.306-1.459.717-2.126 1.384S.935 3.35.63 4.14C.333 4.905.131 5.775.072 7.053.012 8.333 0 8.74 0 12s.015 3.667.072 4.947c.06 1.277.261 2.148.558 2.913.306.788.717 1.459 1.384 2.126.667.666 1.336 1.079 2.126 1.384.765.297 1.636.499 2.913.558C8.333 23.988 8.74 24 12 24s3.667-.015 4.947-.072c1.277-.06 2.148-.262 2.913-.558.788-.306 1.459-.718 2.126-1.384.666-.667 1.079-1.335 1.384-2.126.297-.765.499-1.636.558-2.913.06-1.28.072-1.687.072-4.947s-.015-3.667-.072-4.947c-.06-1.277-.262-2.148-.558-2.913-.306-.789-.718-1.459-1.384-2.126C21.314.935 20.644.523 19.86.22c-.765-.297-1.636-.499-2.913-.558C15.667.012 15.26 0 12 0zm0 2.16c3.203 0 3.585.016 4.85.071 1.17.055 1.805.249 2.227.415.562.217.96.477 1.382.896.419.42.679.82.896 1.383.164.421.36 1.057.413 2.227.057 1.266.07 1.646.07 4.85s-.015 3.585-.074 4.85c-.056 1.17-.249 1.805-.413 2.227-.217.562-.477.96-.896 1.382-.42.419-.82.679-1.383.896-.421.164-1.057.36-2.227.413-1.266.057-1.646.07-4.85.07s-3.585-.015-4.85-.07c-1.17-.056-1.805-.249-2.227-.413-.562-.217-.96-.477-1.382-.896-.419-.42-.679-.82-.896-1.383-.164-.421-.36-1.057-.413-2.227-.057-1.266-.07-1.646-.07-4.85s.015-3.585.07-4.85c.055-1.17.249-1.805.413-2.227.217-.562.477-.96.896-1.382.42-.419.82-.679 1.383-.896.421-.164 1.057-.36 2.227-.413C8.415 2.172 8.797 2.16 12 2.16zm0 5.48c-2.49 0-4.5 2.01-4.5 4.5s2.01 4.5 4.5 4.5 4.5-2.01 4.5-4.5-2.01-4.5-4.5-4.5zm0 7.16c-1.468 0-2.66-1.192-2.66-2.66s1.192-2.66 2.66-2.66 2.66 1.192 2.66 2.66-1.192 2.66-2.66 2.66zm6.336-7.74c-.777 0-1.405-.628-1.405-1.405s.628-1.405 1.405-1.405 1.405.628 1.405 1.405-.628 1.405-1.405 1.405z"/></svg>
                </a>
                <a href="https://facebook.com" target="_blank" rel="noopener noreferrer" aria-label="Facebook">
                    <svg role="img" viewbox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><title>Facebook</title><path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/></svg>
                </a>
                </div>
        </div>
    </div>
    
    <div class="oopy-my-footer-copyright">
        <p>&copy; 2025 Oopy Inc. All Rights Reserved.</p>
    </div>
</footer>

<script>
function openCheckoutPopup() {
    const width = 600;
    const height = 700;
    const left = (window.screen.width - width) / 2;
    const top = (window.screen.height - height) / 2;

    window.open(
        '/checkout',
        'checkoutPopup',
        `width=${width},height=${height},top=${top},left=${left},resizable=yes,scrollbars=yes`
    );
}
</script>

<script>
    // 모바일 푸터 토글 기능을 위한 스크립트
    // 데스크톱에서는 이 스크립트가 영향을 주지 않습니다.
    const footerToggle = document.getElementById('footer-toggle');
    const footerContent = document.getElementById('footer-content');

    if (footerToggle && footerContent) {
        footerToggle.addEventListener('click', () => {
            // is-open 클래스를 컨테이너와 버튼 자체에 토글합니다.
            footerContent.classList.toggle('is-open');
            footerToggle.classList.toggle('is-open');
        });

        // 초기 상태 설정 (데스크톱에서는 항상 열려 있도록)
        function checkFooterView() {
            if (window.innerWidth > 768) {
                footerContent.classList.add('is-open');
                // 데스크톱 뷰에서는 토글 버튼에 is-open 클래스를 제거하여 화살표 방향을 초기화합니다.
                footerToggle.classList.remove('is-open');
            } else {
                 // 모바일 뷰로 전환될 때 기본적으로 닫힌 상태로 만듭니다.
                 footerContent.classList.remove('is-open');
                 footerToggle.classList.remove('is-open');
            }
        }
        
        // 페이지 로드 시 및 창 크기 변경 시 뷰 체크
        checkFooterView();
        window.addEventListener('resize', checkFooterView);
    }
</script>
