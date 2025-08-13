<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>식꾸 - Urban Smart Garden</title>
  <link rel="stylesheet" href="/css/common/layout.css" />
  <link rel="stylesheet" href="/css/identity.css?v=20250813" />
</head>

<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<!-- Blob 배경 -->
<div class="blobs">
  <div class="blob blob1"></div>
  <div class="blob blob2"></div>
  <div class="blob blob3"></div>
  <div class="blob blob4"></div>
</div>

<main class="identity-page">

  <!-- Hero -->
  <section class="identity-hero fade-in">
    <div class="identity-hero-inner">
      <span class="identity-badge">Urban Smart Garden • Community Diary</span>
      <h1 class="identity-hero-title">
        <span class="identity-highlight">식꾸</span><br/>
        내 손 안의 스마트 텃밭 파트너
      </h1>
      <p class="identity-hero-sub">
        도시형 소규모 재배자를 위한 커뮤니티 기반 다이어리 · 생육 데이터 분석 · 맞춤형 가이드.<br/>
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
  </section>

 <!-- Features -->
<section class="identity-section fade-in-cards">
  <h2 class="identity-section-title">왜 식꾸일까요?</h2>
  <div class="identity-grid">
    <article class="identity-card"> <!-- 카드 1 -->
      <div class="identity-card-icon">🌱</div>
      <h3 class="identity-card-title">다이어리 기반 성장 관리</h3>
      <p class="identity-card-desc">사진·메모·환경을 한곳에. 식물별 타임라인으로 성장을 한눈에 확인합니다.</p>
    </article>

    <article class="identity-card"> <!-- 카드 2 -->
      <div class="identity-card-icon">📈</div>
      <h3 class="identity-card-title">생육 데이터 인사이트</h3>
      <p class="identity-card-desc">기록을 분석해 급수·일조·시비 타이밍을 예측하고 맞춤 알림을 제공합니다.</p>
    </article>

    <article class="identity-card"> <!-- 카드 3 -->
      <div class="identity-card-icon">🤝</div>
      <h3 class="identity-card-title">커뮤니티 큐레이션</h3>
      <p class="identity-card-desc">비슷한 환경의 재배자와 연결되어 노하우를 교환하고 문제를 함께 해결합니다.</p>
    </article>

    <article class="identity-card"> <!-- 카드 4 -->
      <div class="identity-card-icon">🛰️</div>
      <h3 class="identity-card-title">스마트팜 연동</h3>
      <p class="identity-card-desc">센서·컨트롤러 데이터와 연계해 자동으로 로그를 쌓고 트렌드를 시각화합니다.</p>
    </article>
  </div>
</section>


  <!-- Steps -->
  <section class="identity-section identity-steps slide-left">
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

  <!-- Showcase -->
  <section class="identity-section identity-showcase">
    <div class="phone-frame slide-left" aria-hidden="true">
      <div class="phone-screen">
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

    <div class="identity-showcase-copy slide-right">
      <h2 class="identity-section-title">당신의 재배 여정, 보기 좋게 정리됩니다</h2>
      <p>모바일·데스크톱 어디서든 부드럽게. 히트맵·카드·타임라인으로 기록을 다시 발견해보세요.</p>
      <a href="${pageContext.request.contextPath}/mydiary/write.do" class="identity-btn identity-btn--primary">첫 기록 남기기</a>
    </div>
  </section>

  <!-- Wide CTA -->
  <section class="identity-cta-wide fade-in">
    <div class="identity-cta-wide-inner">
      <h3>오늘 씨앗을 심으면, 내일의 데이터가 됩니다</h3>
      <a href="${pageContext.request.contextPath}/signup" class="identity-btn identity-btn--light">무료로 시작</a>
    </div>
  </section>

</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
document.addEventListener("DOMContentLoaded", () => {
  const animatedEls = document.querySelectorAll(".fade-in, .slide-left, .slide-right");
  const featureCards = document.querySelectorAll(".fade-in-cards .identity-card");

  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("show");
      }
    });
  }, { threshold: 0.2 });

  // 일반 섹션 애니메이션
  animatedEls.forEach((el) => observer.observe(el));

  // 왜 식꾸일까요? 카드 순차 애니메이션
  featureCards.forEach((card, index) => {
    card.style.transitionDelay = `${index * 0.15}s`;
    observer.observe(card);
  });
});
</script>
</body>
</html>
