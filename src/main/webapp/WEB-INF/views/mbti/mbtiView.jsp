<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>그린다이어리(예명)</title>
    <link rel="stylesheet" href="/css/common/layout.css" />
    <link rel="stylesheet" href="/css/mbtiView.css">
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<form class="mbti-nav-top" action="/mbti/view.do" method="get">
	<button type="submit" name="mbti" value="INTJ">INTJ</button>
	<button type="submit" name="mbti" value="INTP">INTP</button>
	<button type="submit" name="mbti" value="ENTJ">ENTJ</button>
	<button type="submit" name="mbti" value="ENTP">ENTP</button>
	<button type="submit" name="mbti" value="INFJ">INFJ</button>
	<button type="submit" name="mbti" value="INFP">INFP</button>
	<button type="submit" name="mbti" value="ENFJ">ENFJ</button>
	<button type="submit" name="mbti" value="ENFP">ENFP</button>
	<button type="submit" name="mbti" value="ISTJ">ISTJ</button>
	<button type="submit" name="mbti" value="ISFJ">ISFJ</button>
	<button type="submit" name="mbti" value="ESTJ">ESTJ</button>
	<button type="submit" name="mbti" value="ESFJ">ESFJ</button>
	<button type="submit" name="mbti" value="ISTP">ISTP</button>
	<button type="submit" name="mbti" value="ISFP">ISFP</button>
	<button type="submit" name="mbti" value="ESTP">ESTP</button>
	<button type="submit" name="mbti" value="ESFP">ESFP</button>
</form>
    
<!-- MBTI Section -->
<div class="mbti-section">

	<div class="mbti-container">
		<!-- 왼쪽 내용 -->
		<div class="mbti-profile">
			<h2 class="title">${MBTI_indoor.name } 추천식물</h2>
		    <!-- 왼쪽 이미지 -->
		    <div class="mbti-img">
		        <img src="/images/mbti/${MBTI_indoor.imgFile}" alt="${MBTI_indoor.name}">
		    </div>
	    </div>
	
	    <!-- 오른쪽 내용 -->
	    <div class="mbti-info">
	    	<div class="plant-category">
	            <span data-value="indoor" class="active">실내식물</span>
				<span data-value="outdoor">텃밭식물</span>
	        </div>
	        
	    	<div class="plant-description panel panel-indoor active">
		        <div class="name">
		            🌱 추천 실내식물 <br>
		            ${MBTI_indoor.plants} <br>
		        </div>
		        <div class="desc">
		            ✅ 특성 <br>
		            ${MBTI_indoor.character} <br>
		            ⏳ 생육주기 <br>
		            ${MBTI_indoor.growperiod} <br>
		            🌞 생육환경 <br>
		            ${MBTI_indoor.growenv} <br>
		        	❓ 추천이유 <br>
		            ${MBTI_indoor.reason}
		        </div>
	        </div>
	        
	        <div class="plant-description panel panel-outdoor">
		        <div class="name">
		            🌱 추천 텃밭식물 <br>
		            ${MBTI_outdoor.plants} <br>
		        </div>
		        <div class="desc">
		            ✅ 특성 <br>
		            ${MBTI_outdoor.character} <br>
		            ⏳ 생육주기 <br>
		            ${MBTI_outdoor.growperiod} <br>
		            🌞 생육환경 <br>
		            ${MBTI_outdoor.growenv} <br>
		        	❓ 추천이유 <br>
		            ${MBTI_outdoor.reason}
		        </div>
	        </div>
	    </div>
	</div>
	
</div>

<div class="mbti-nav-bottom">
	<a class="prev-btn" href="/mbti/view.do?mbti=${prevMbti}">← 이전</a>
  	<a class="next-btn" href="/mbti/view.do?mbti=${nextMbti}">다음 →</a>
</div>
    
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>

<!-- plant-category 변경 -->
<script>
const tabs = document.querySelectorAll('.plant-category span');
const indoor = document.querySelector('.panel-indoor');
const outdoor = document.querySelector('.panel-outdoor');

tabs.forEach(tab => {
  tab.addEventListener('click', () => {
    const val = tab.dataset.value;           // 'indoor' | 'outdoor'
    tabs.forEach(t => t.classList.remove('active'));
    tab.classList.add('active');

    if (val === 'outdoor') {
      indoor.classList.remove('active');
      outdoor.classList.add('active');
    } else {
      outdoor.classList.remove('active');
      indoor.classList.add('active');
    }
  });
});
</script>
</html>