<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>식꾸</title>
	<link rel="stylesheet" href="/css/common/layout.css" />
	<link rel="stylesheet" href="/css/identity.css" />
</head>

<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<main class="identity-page">

  <!-- Hero -->
  <section class="identity-hero">
    <div class="identity-hero-inner">
      <span class="identity-badge">Urban Smart Garden • Community Diary</span>
      <h1 class="identity-hero-title">
        <span class="identity-highlight">식꾸</span> — 내 손 안의 <br class="identity-mobile-break"/>스마트 텃밭 파트너
      </h1>
      <p class="identity-hero-sub">
        도시형 소규모 재배자를 위한 커뮤니티 기반 다이어리 · 생육 데이터 분석 · 맞춤형 가이드.
        기록하고, 공유하고, 함께 가꿔요.
      </p>
      <div class="identity-cta">
        <a href="${pageContext.request.contextPath}/signup" class="identity-btn identity-btn--primary">지금 시작하기</a>
        <a href="${pageContext.request.contextPath}/mydiary/list.do" class="identity-btn identity-btn--ghost">다이어리 구경</a>
      </div>

      <ul class="identity-hero-stats">
        <li><strong>3k+</strong><span>성장 로그</span></li>
        <li><strong>98%</strong><span>추천 정확도</span></li>
        <li><strong>24/7</strong><span>커뮤니티</span></li>
      </ul>
    </div>
    <div class="identity-hero-art" aria-hidden="true"></div>
  </section>

  <!-- Features grid -->
  <section class="identity-section">
    <h2 class="identity-section-title">왜 식꾸일까요?</h2>
    <div class="identity-grid">
      <article class="identity-card">
        <div class="identity-card-icon">🌱</div>
        <h3 class="identity-card-title">다이어리 기반 성장 관리</h3>
        <p class="identity-card-desc">사진·메모·환경을 한곳에. 식물별 타임라인으로 성장을 한눈에 확인합니다.</p>
      </article>

      <article class="identity-card">
        <div class="identity-card-icon">📈</div>
        <h3 class="identity-card-title">생육 데이터 인사이트</h3>
        <p class="identity-card-desc">기록을 분석해 급수·일조·시비 타이밍을 예측하고 맞춤 알림을 제공합니다.</p>
      </article>

      <article class="identity-card">
        <div class="identity-card-icon">🤝</div>
        <h3 class="identity-card-title">커뮤니티 큐레이션</h3>
        <p class="identity-card-desc">비슷한 환경의 재배자와 연결되어 노하우를 교환하고 문제를 함께 해결합니다.</p>
      </article>

      <article class="identity-card">
        <div class="identity-card-icon">🛰️</div>
        <h3 class="identity-card-title">스마트팜 연동</h3>
        <p class="identity-card-desc">센서·컨트롤러 데이터와 연계해 자동으로 로그를 쌓고 트렌드를 시각화합니다.</p>
      </article>
    </div>
  </section>

  <!-- How it works -->
  <section class="identity-section identity-steps">
    <h2 class="identity-section-title">시작은 이렇게 간단해요</h2>
    <ol class="identity-steps-list">
      <li class="identity-step">
        <span class="identity-step-index">1</span>
        <h3>식물을 등록</h3>
        <p>품종·환경·목표를 선택하면 기본 템플릿이 생성됩니다.</p>
      </li>
      <li class="identity-step">
        <span class="identity-step-index">2</span>
        <h3>기록하고 분석</h3>
        <p>사진·메모·센서값을 기록하면 자동으로 차트와 추천이 생성됩니다.</p>
      </li>
      <li class="identity-step">
        <span class="identity-step-index">3</span>
        <h3>공유하고 성장</h3>
        <p>커뮤니티와 교류하며 문제를 빠르게 진단하고 해결하세요.</p>
      </li>
    </ol>
  </section>

  <!-- Showcase (device mock) -->
  <section class="identity-section identity-showcase">
    <div class="identity-phone" aria-hidden="true">
      <div class="identity-phone-notch"></div>
      <div class="identity-phone-screen">
        <div class="identity-screen-widget identity-widget-heatmap">Growth Heatmap</div>
        <div class="identity-screen-row">
          <div class="identity-screen-card">Diary</div>
          <div class="identity-screen-card">Community</div>
        </div>
        <div class="identity-screen-row">
          <div class="identity-screen-card">Tips</div>
          <div class="identity-screen-card">Sensors</div>
        </div>
      </div>
    </div>
    <div class="identity-showcase-copy">
      <h2 class="identity-section-title">당신의 재배 여정, 보기 좋게 정리됩니다</h2>
      <p>모바일·데스크톱 어디서든 부드럽게. 히트맵·카드·타임라인으로 기록을 다시 발견해보세요.</p>
      <a href="${pageContext.request.contextPath}/mydiary/write.do" class="identity-btn identity-btn--primary">첫 기록 남기기</a>
    </div>
  </section>

  <!-- Wide CTA -->
  <section class="identity-cta-wide">
    <div class="identity-cta-wide-inner">
      <h3>오늘 씨앗을 심으면, 내일의 데이터가 됩니다</h3>
      <a href="${pageContext.request.contextPath}/signup" class="identity-btn identity-btn--light">무료로 시작</a>
    </div>
  </section>

</main>
<!-- 
<div class=identity-intro>
	<h2>내 손 안의 작물 관리, 똑똑하게 함께 가꾸는</h2>
	<h2>나만의 식물 꾸미기 식꾸</h2>
</div>
<p>
	도시형 소규모 재배자에게 커뮤니티 기반 다이어리 기록을 통한 빅데이터 중심 스마트팜 텃밭 플랫폼입니다. <br/>
	사용자의 재배 활동을 마치 '식물 육아일기'처럼 기록하고, 생육 데이터를 분석해 맞춤형 정보를 제공하며, <br /> 
	커뮤니티 중심의 지속적인 교류와 참여를 유도하는 서비스입니다.
</p>

<<<<<<< HEAD
=======
 -->

>>>>>>> ee744f9 (backup2)
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>