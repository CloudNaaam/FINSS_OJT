<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.TextStyle" %>
<%@ page import="java.util.Locale" %>
<%
    LocalDate today = LocalDate.now();
    String[] dayNames = {"월", "화", "수", "목", "금", "토", "일"};
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>핀랩풋볼 - 소셜 풋살 매치</title>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap");

        * { box-sizing: border-box; }

        :root {
            --blue: #1570ff;
            --blue-dark: #0758d7;
            --blue-soft: #eaf3ff;
            --ink: #22252b;
            --muted: #80858f;
            --line: #eceef2;
            --bg: #f3f5f7;
            --green: #11ad69;
            --orange: #ff7534;
        }

        html { scroll-behavior: smooth; }

        body {
            margin: 0;
            background: var(--bg);
            color: var(--ink);
            font-family: "Noto Sans KR", sans-serif;
            word-break: keep-all;
        }

        button, input { font: inherit; }
        button { cursor: pointer; }

        .page {
            width: min(100%, 768px);
            min-height: 100vh;
            margin: 0 auto;
            background: #fff;
            box-shadow: 0 0 30px rgba(20, 26, 36, .05);
        }

        /* 상단 */
        .header {
            position: sticky;
            z-index: 20;
            top: 0;
            background: rgba(255, 255, 255, .96);
            border-bottom: 1px solid var(--line);
            backdrop-filter: blur(10px);
        }

        .header-main {
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 64px;
            padding: 0 24px;
        }

        .brand {
            color: var(--blue);
            font-size: 24px;
            font-weight: 900;
            letter-spacing: -1.5px;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .icon-button {
            display: grid;
            width: 40px;
            height: 40px;
            place-items: center;
            border: 0;
            border-radius: 50%;
            background: transparent;
            color: #333;
            font-size: 20px;
        }

        .icon-button:hover { background: #f4f6f8; }

        .service-nav {
            display: flex;
            height: 50px;
            padding: 0 18px;
            overflow-x: auto;
            scrollbar-width: none;
        }

        .service-nav::-webkit-scrollbar { display: none; }

        .service-nav a {
            position: relative;
            display: flex;
            align-items: center;
            flex: 0 0 auto;
            padding: 0 15px;
            color: #777c84;
            font-size: 15px;
            font-weight: 600;
            text-decoration: none;
        }

        .service-nav a.active { color: var(--ink); font-weight: 800; }

        .service-nav a.active::after {
            position: absolute;
            right: 14px;
            bottom: 0;
            left: 14px;
            height: 3px;
            border-radius: 3px 3px 0 0;
            background: var(--blue);
            content: "";
        }

        /* 안내 배너 */
        .hero {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin: 22px 24px 18px;
            padding: 22px 24px;
            overflow: hidden;
            border-radius: 16px;
            background: linear-gradient(135deg, #176fff, #4797ff);
            color: #fff;
        }

        .hero small {
            display: block;
            margin-bottom: 5px;
            color: rgba(255, 255, 255, .75);
            font-size: 12px;
            font-weight: 700;
        }

        .hero h1 {
            margin: 0 0 5px;
            font-size: 20px;
            line-height: 1.4;
            letter-spacing: -.6px;
        }

        .hero p {
            margin: 0;
            color: rgba(255, 255, 255, .82);
            font-size: 13px;
        }

        .hero-ball {
            display: grid;
            width: 74px;
            height: 74px;
            flex: 0 0 auto;
            margin-right: -4px;
            place-items: center;
            transform: rotate(-12deg);
            border: 8px solid rgba(255, 255, 255, .2);
            border-radius: 50%;
            background: #fff;
            box-shadow: 0 10px 24px rgba(0, 43, 124, .2);
            color: #20252d;
            font-size: 42px;
        }

        /* 날짜 */
        .date-area {
            border-bottom: 8px solid #f5f6f8;
        }

        .date-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 4px 24px 12px;
        }

        .date-head h2 {
            margin: 0;
            font-size: 18px;
            letter-spacing: -.5px;
        }

        .calendar-button {
            border: 0;
            background: transparent;
            color: #5f6570;
            font-size: 13px;
            font-weight: 600;
        }

        .dates {
            display: flex;
            gap: 6px;
            padding: 0 18px 18px;
            overflow-x: auto;
            scrollbar-width: none;
        }

        .dates::-webkit-scrollbar { display: none; }

        .date-card {
            min-width: 55px;
            padding: 9px 5px;
            border: 0;
            border-radius: 11px;
            background: transparent;
            color: #60656e;
            text-align: center;
        }

        .date-card span {
            display: block;
            margin-bottom: 4px;
            font-size: 11px;
        }

        .date-card strong { font-size: 17px; }
        .date-card.saturday { color: #3978dc; }
        .date-card.sunday { color: #ed5664; }

        .date-card.active {
            background: var(--blue);
            box-shadow: 0 6px 15px rgba(21, 112, 255, .25);
            color: #fff;
        }

        /* 필터 */
        .filter-area {
            position: sticky;
            z-index: 15;
            top: 114px;
            padding: 15px 18px;
            overflow-x: auto;
            background: #fff;
            border-bottom: 1px solid var(--line);
            scrollbar-width: none;
            white-space: nowrap;
        }

        .filter-area::-webkit-scrollbar { display: none; }

        .filter {
            margin-right: 5px;
            padding: 9px 13px;
            border: 1px solid #dfe2e7;
            border-radius: 20px;
            background: #fff;
            color: #555b64;
            font-size: 13px;
            font-weight: 600;
        }

        .filter.primary {
            border-color: var(--blue);
            background: var(--blue-soft);
            color: var(--blue);
        }

        .filter.active {
            border-color: #24272d;
            background: #24272d;
            color: #fff;
        }

        /* 매치 목록 */
        .matches { padding: 2px 24px 110px; }

        .match-group-title {
            margin: 27px 0 6px;
            font-size: 20px;
            letter-spacing: -.6px;
        }

        .match-card {
            display: grid;
            grid-template-columns: 76px minmax(0, 1fr) auto;
            gap: 14px;
            align-items: start;
            padding: 21px 0;
            border-bottom: 1px solid var(--line);
        }

        .time {
            padding-top: 1px;
            font-size: 18px;
            font-weight: 800;
        }

        .time small {
            display: block;
            margin-top: 3px;
            color: #979ba3;
            font-size: 11px;
            font-weight: 500;
        }

        .match-title {
            margin: 0 0 7px;
            font-size: 15px;
            font-weight: 700;
            line-height: 1.45;
        }

        .match-meta {
            margin: 0 0 9px;
            color: #7e838d;
            font-size: 12px;
        }

        .tags {
            display: flex;
            flex-wrap: wrap;
            gap: 5px;
        }

        .tag {
            padding: 4px 7px;
            border-radius: 5px;
            background: #f1f3f5;
            color: #696e77;
            font-size: 10px;
            font-weight: 600;
        }

        .tag.women { background: #fff0f3; color: #e4516d; }
        .tag.beginner { background: #eef7ff; color: #2c76c9; }
        .tag.sale { background: #fff2e9; color: var(--orange); }

        .status {
            min-width: 69px;
            padding: 9px 11px;
            border: 1px solid var(--blue);
            border-radius: 8px;
            background: #fff;
            color: var(--blue);
            font-size: 12px;
            font-weight: 700;
        }

        .status:hover {
            background: var(--blue);
            color: #fff;
        }

        .status.soon {
            border-color: #cdd1d8;
            color: #777c85;
        }

        .status.closed {
            border-color: #eceef1;
            background: #f4f5f6;
            color: #aaaeb5;
            cursor: default;
        }

        .empty-divider {
            height: 8px;
            margin: 5px -24px 0;
            background: #f5f6f8;
        }

        /* 하단 모바일 메뉴 */
        .bottom-nav {
            position: fixed;
            z-index: 30;
            right: 0;
            bottom: 0;
            left: 0;
            display: none;
            width: min(100%, 768px);
            height: 72px;
            margin: auto;
            padding: 8px 12px max(8px, env(safe-area-inset-bottom));
            background: rgba(255, 255, 255, .97);
            border-top: 1px solid var(--line);
        }

        .bottom-nav a {
            display: flex;
            align-items: center;
            flex: 1;
            flex-direction: column;
            gap: 3px;
            color: #9a9ea6;
            font-size: 10px;
            text-decoration: none;
        }

        .bottom-nav span { font-size: 22px; line-height: 1.1; }
        .bottom-nav a.active { color: var(--blue); font-weight: 700; }

        @media (max-width: 600px) {
            body { background: #fff; }
            .page { box-shadow: none; }
            .header-main { height: 58px; padding: 0 18px; }
            .service-nav { height: 46px; padding: 0 8px; }
            .filter-area { top: 104px; }
            .hero { margin: 16px; padding: 20px; }
            .hero-ball { width: 60px; height: 60px; font-size: 33px; }
            .date-head { padding-right: 18px; padding-left: 18px; }
            .matches { padding-right: 18px; padding-left: 18px; }
            .match-card { grid-template-columns: 60px minmax(0, 1fr) auto; gap: 10px; }
            .status { min-width: 58px; padding: 8px 7px; }
            .bottom-nav { display: flex; }
        }
    </style>
</head>
<body>
<div class="page">
    <header class="header">
        <div class="header-main">
            <div class="brand">Finlab</div>
            <div class="header-actions">
                <button class="icon-button" type="button" aria-label="검색">⌕</button>
                <a class="icon-button" href="/mypage" aria-label="마이페이지" style="text-decoration:none;">●</a>
            </div>
        </div>
        <nav class="service-nav" aria-label="서비스 메뉴">
            <a class="active" href="/">소셜 매치</a>
            <a href="/board">게시판</a>
            <a href="/notice">공지사항</a>
        </nav>
    </header>

    <main>
        <section class="hero">
            <div>
                <small>혼자 와도 즐거운 풋살</small>
                <h1>오늘 저녁,<br>가볍게 한 게임 어때요?</h1>
                <p>실력에 맞는 가까운 매치를 찾아보세요</p>
            </div>
            <div class="hero-ball" aria-hidden="true">⚽</div>
        </section>

        <section class="date-area">
            <div class="date-head">
                <h2><%= today.getMonthValue() %>월 매치</h2>
                <button class="calendar-button" type="button">달력 보기 ▾</button>
            </div>
            <div class="dates">
                <% for (int i = 0; i < 10; i++) {
                    LocalDate date = today.plusDays(i);
                    int dayIndex = date.getDayOfWeek().getValue() - 1;
                    String dayClass = dayIndex == 5 ? "saturday" : dayIndex == 6 ? "sunday" : "";
                %>
                <button class="date-card <%= i == 0 ? "active" : dayClass %>" type="button">
                    <span><%= i == 0 ? "오늘" : dayNames[dayIndex] %></span>
                    <strong><%= date.getDayOfMonth() %></strong>
                </button>
                <% } %>
            </div>
        </section>

        <section class="filter-area" aria-label="매치 필터">
            <button class="filter" type="button">마감 가리기</button>
            <button class="filter active" type="button">☾ 저녁 매치</button>
            <button class="filter" type="button">혜택</button>
            <button class="filter" type="button">성별 ▾</button>
            <button class="filter" type="button">레벨 ▾</button>
            <button class="filter" type="button">실내·그늘막</button>
        </section>

        <section class="matches">
            <h2 class="match-group-title">전체 매치 목록</h2>
            <div id="match-list-container">
                <!-- 동적 매치 데이터가 삽입됩니다 -->
            </div>
        </section>
    </main>

    <nav class="bottom-nav" aria-label="하단 메뉴">
        <a class="active" href="/"><span>⚽</span>매치</a>
        <a href="/board"><span>📋</span>게시판</a>
        <a href="/notice"><span>📢</span>공지</a>
        <a href="/mypage"><span>●</span>MY</a>
    </nav>
</div>

<script>
    document.querySelectorAll(".date-card").forEach(function (button) {
        button.addEventListener("click", function () {
            document.querySelectorAll(".date-card").forEach(function (item) {
                item.classList.remove("active");
            });
            button.classList.add("active");
        });
    });

    document.querySelectorAll(".filter").forEach(function (button) {
        button.addEventListener("click", function () {
            if (!button.classList.contains("primary")) {
                button.classList.toggle("active");
            }
        });
    });

    function fetchMatches() {
        fetch('/api/matches')
            .then(function(res) { return res.json(); })
            .then(function(data) {
                var container = document.getElementById('match-list-container');
                if (!container) return;
                if (!data || data.length === 0) {
                    container.innerHTML = '<p style="padding: 20px 0; color: #888; text-align: center;">등록된 매치가 없습니다.</p>';
                    return;
                }
                var html = '';
                data.forEach(function(m) {
                    var timeStr = m.match_at ? m.match_at.substring(11, 16) : '19:00';
                    var genderStr = m.gender === 'ANY' ? '남녀 모두' : (m.gender === 'MALE' ? '남성' : '여성');
                    html += '<article class="match-card">' +
                                '<div class="time">' + timeStr + '<small>120분</small></div>' +
                                '<div>' +
                                    '<h3 class="match-title">' + (m.field_name || '경기장') + '</h3>' +
                                    '<p class="match-meta">' + genderStr + ' · 레벨 ' + (m.match_level || 5) + ' · 모집 ' + (m.num_members || 12) + '명</p>' +
                                    '<div class="tags">' +
                                        '<span class="tag beginner">모든 레벨</span>' +
                                        '<span class="tag">풋살화</span>' +
                                    '</div>' +
                                '</div>' +
                                '<button class="status" type="button">신청 가능</button>' +
                            '</article>';
                });
                container.innerHTML = html;
            })
            .catch(function(err) {
                console.error('매치 목록 로드 실패:', err);
            });
    }

    document.addEventListener('DOMContentLoaded', fetchMatches);
</script>
</body>
</html>
