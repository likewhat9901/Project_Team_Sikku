<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>SpringBoot</title>
	<link rel="stylesheet" href="/css/common/layout.css" />
	<link rel="stylesheet" href="/css/nonMember.css">
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%@ include file="/WEB-INF/views/common/features/weather.jsp" %>
    
    <!-- Ranking -->
	<div class="ranking-container">
		<div class="category-select-container">
			<select id="category-select" onchange="fetchRanking(this.value);">
		        <option value="farm">텃밭식물</option>
		        <option value="foliage">관엽식물</option>
		    </select>
	    </div>
		<div class="ranking">
			<%@ include file="/WEB-INF/views/common/features/loading.jsp" %>
	    </div>
	</div>

<!-- Hero Section -->
	<div class="hero-section">
		<div class="banner-container">
			<!-- 이전 버튼 -->
			<button class="nav-buttons prev" onclick="changeSlideLeft();">❮</button>
			
			<div class="banner">
				<img class="banner-img" src="/images/banner/mbti_banner.jpg" alt="Banner1" onclick="location.href='/mbti/list.do'"/>
				<img class="banner-img" src="/images/banner/about_banner.jpg" alt="Banner2" onclick="location.href='/about/identity.do'"/>
				<img class="banner-img" src="/images/banner/diary_banner.jpg" alt="Banner2" onclick="location.href='/mydiary/list.do'"/>
			</div>
			
			<!-- 다음 버튼 -->
			<button class="nav-buttons next" onclick="changeSlideRight();">❯</button>
		</div>
		
		<div class="popular-board">
			<h2>자유게시판 인기 Top10</h2>
			<select onchange="fetchPopularBoards(this.value);">
		        <option value="1">자유게시판</option>
		        <option value="2">갤러리게시판</option>
		    </select>
			<!-- 인기게시물 테이블이 들어갈 공간 -->
			<div class="board-container">
				<%@ include file="/WEB-INF/views/common/features/loading.jsp" %>
			</div>
		</div>
		
	</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>

<!-- 랭킹 시상대 불러오기 -->
<script>
function fetchRanking(category) {
	console.log("식물랭킹 category: "+category);
	const rankingContainer = document.querySelector('.ranking');
	rankingContainer.innerHTML = 
		`<%@ include file="/WEB-INF/views/common/features/loading.jsp" %>`;
	
    fetch('/api/ranking?category='+category)
        .then(response => response.json())
        .then(data => {
        	rankingContainer.innerHTML = ''; // 기존 시상대 초기화

            if (data.error) {
            	rankingContainer.innerHTML = `<p style="color:red;">\${data.error}</p>`;
                return;
            }
			
            const topN = data.top10.slice(0, 10);
            
            topN.forEach((item, index) => {
            	const height = 180 - index * 10;
            	const html = `
            		<div class="step-container">
	                    <img src="\${item.image}" alt="\${item.name}" />
	                    <div class="step" style="height:\${height}px; background-color: #5cb85c;">
	                        <div class="rank">\${index + 1}위</div>
	                        <div class="name">\${item.name}</div>
	                        <div class="volume">(\${item.volume.toFixed(2)})</div>
	                    </div>
                    </div>
                `;
                rankingContainer.innerHTML += html;
            });
        })
        .catch(err => {
            console.error("API 호출 에러:", err);
        });
}

// 페이지 로드 시 기본 'farm' 카테고리로 데이터 로드
fetchRanking('farm');
    
</script>

<!-- 슬라이드 배너 기능 -->
<script type="text/javascript">

//슬라이드 배너
const slider = document.querySelector('.banner');
const banners = document.querySelectorAll('.banner-img'); // 모든 배너 이미지
let index = 0;

function changeSlideLeft() {
    index = (index - 1 + banners.length) % banners.length; // 이미지 인덱스를 순차적으로 변경
    slider.style.transform = `translateX(-\${index * 100}%)`; // 슬라이드를 오른쪽으로 이동
    
    console.log("changeSlideLeft 호출");
}

function changeSlideRight() {
    index = (index + 1) % banners.length; // 이미지 인덱스를 순차적으로 변경
    slider.style.transform = `translateX(-\${index * 100}%)`; // 슬라이드를 왼쪽으로 이동

    console.log("changeSlideRight 호출");
}

// 5초마다 자동으로 이미지 변경
setInterval(changeSlideRight, 5000);

</script>

<!-- 인기 게시물 Top10 -->
<script type="text/javascript">
function fetchPopularBoards(category) {
	console.log("인기게시물 category: "+category);
	const boardContainer = document.querySelector('.board-container');
	const board_header = document.querySelector('.popular-board h2');
	
	// 로딩 표시
	boardContainer.innerHTML = 
		`<%@ include file="/WEB-INF/views/common/features/loading.jsp" %>`;
	
    fetch('/api/top10boards?category='+category+'&page=0&size=10')
        .then(response => response.json())
        .then(data => {
        	boardContainer.innerHTML = ''; // 초기화
        	
            if (data.error) {
            	boardContainer.innerHTML = `<p style="color:red;">\${data.error}</p>`;
                return;
            }
			
            const top10 = data.top10Boards.content;
            const category_name = (category == "1") ? "자유게시판" : "갤러리게시판";
            board_header.innerHTML = category_name+ ' 인기 Top10';
            
         	// 테이블 헤더 만들기
            let tableHTML = `
                <table border="1" style="width:100%; ">
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th>제목</th>
                            <th>날짜</th>
                        </tr>
                    </thead>
                    <tbody>
            `;
            
            top10.forEach((item, index) => {
            	const postDate = item.postdate ? item.postdate.split("T")[0] : '';
            	
                tableHTML += `
                    <tr>
                        <td style="width:10%; text-align:center;">\${index + 1}</td>
                        <td><a href="/boards/free/freeBoardView.do?boardIdx=\${item.boardIdx}">\${item.title || '제목 없음'}</a></td>
                        <td style="width:20%; text-align:center;">\${postDate}</td>
                    </tr>
                `;
            });
            
            tableHTML += '</tbody></table>';

            boardContainer.innerHTML = tableHTML;
        })
        .catch(err => {
            console.error("API 호출 에러:", err);
            boardContainer.innerHTML = '<p style="color:red;">인기게시물을 불러오는 중 오류가 발생했습니다.</p>';
        });
}

fetchPopularBoards(1);
</script>
</html>