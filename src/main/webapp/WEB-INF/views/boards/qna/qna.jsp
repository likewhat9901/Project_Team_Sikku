<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Q&A</title>
  <link rel="stylesheet" href="/css/common/layout.css" />
  <style>
    body {
      font-family: 'Noto Sans KR', sans-serif;
      background-color: #fff;
      margin: 0;
      padding: 0;
    }
    h1 {
      text-align: center;
      padding: 40px 0 10px;
      font-size: 32px;
      font-weight: bold;
    }
    .nav {
      text-align: center;
      margin-bottom: 30px;
    }
    .nav a {
      margin: 0 15px;
      text-decoration: none;
      color: #555;
      font-weight: 600;
    }
    .nav .active {
      border-bottom: 2px solid #000;
    }
    table {
      width: 80%;
      margin: 0 auto;
      border-collapse: collapse;
    }
    th, td {
      padding: 14px 8px;
      text-align: center;
      border-bottom: 1px solid #ddd;
    }
    th {
      background: #f7f7f7;
    }
    tr.notice-row {
      background-color: #f9f9f9;
      font-weight: bold;
    }
    .search-box {
      width: 80%;
      margin: 30px auto;
      text-align: center;
    }
    .search-box input {
      width: 250px;
      padding: 8px;
    }
    .search-box button {
      padding: 8px 15px;
    }
  </style>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

  <h1>Q&A</h1>
  <table>
    <tr>
      <th>No</th>
      <th>제목</th>
      <th>글쓴이</th>
      <th>작성시간</th>
    </tr>
    <tr class="notice-row">
      <td>📌</td>
      <td style="text-align:left">2021년 입고정보게시판 신설</td>
      <td>PLIPOP</td>
      <td>2021-01-26</td>
    </tr>
    <tr><td>16</td><td style="text-align:left">신상입고 기대합니다!</td><td>PLIPOP</td><td>2021-01-26</td></tr>
    <tr><td>15</td><td style="text-align:left">무통장입금 가능한가요??</td><td>PLIPOP</td><td>2021-01-26</td></tr>
    <tr><td>14</td><td style="text-align:left">신상입고 언제 되요? ㅠㅠㅠㅠ</td><td>PLIPOP</td><td>2021-01-26</td></tr>
    <tr><td>13</td><td style="text-align:left">친절한 응대 감사합니다 ^^</td><td>PLIPOP</td><td>2021-01-26</td></tr>
    <tr><td>12</td><td style="text-align:left">프로모션으로 상품을 구매했는데요.</td><td>PLIPOP</td><td>2021-01-26</td></tr>
    <tr><td>11</td><td style="text-align:left">배송 언제 되나요?</td><td>PLIPOP</td><td>2021-01-26</td></tr>
    <tr><td>10</td><td style="text-align:left">새상품 입고 언제 되나요?</td><td>PLIPOP</td><td>2021-01-26</td></tr>
    <tr><td>9</td><td style="text-align:left">스키니진 블루블랙 언제 입고되나요?</td><td>PLIPOP</td><td>2021-01-26</td></tr>
    <tr><td>8</td><td style="text-align:left">[문의] 문의드립니다</td><td>익명</td><td>2019-09-24</td></tr>
    <tr><td>7</td><td style="text-align:left">여기 이름을 모르겠는데 재입고 언제 되나요?</td><td>익명</td><td>2019-09-24</td></tr>
  </table>

  <div class="search-box">
    <input type="text" placeholder="Search" />
    <button>검색</button>
  </div>

</body>
</html>
