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
            text-decoration: none;
            transition: background 0.15s ease;
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
            border-color: var(--blue) !important;
            background: var(--blue) !important;
            color: #fff !important;
            font-weight: 700;
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

        /* 검색 모달 스타일 */
        .search-modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            z-index: 1000;
            display: none;
            align-items: flex-start;
            justify-content: center;
            padding-top: 60px;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(8px);
            animation: fadeIn 0.2s ease-out;
        }

        .search-modal-card {
            width: min(90%, 540px);
            max-height: 80vh;
            display: flex;
            flex-direction: column;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            animation: slideDown 0.25s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .search-tab-bar {
            display: flex;
            padding: 16px 20px 0;
            gap: 10px;
            border-bottom: 1px solid #f1f5f9;
            background: #f8fafc;
        }

        .search-tab {
            flex: 1;
            padding: 12px 16px;
            border: 0;
            border-radius: 10px 10px 0 0;
            background: transparent;
            color: #64748b;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        .search-tab.active {
            background: #ffffff;
            color: var(--blue);
            box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.03);
            border-bottom: 2px solid var(--blue);
        }

        .search-input-box {
            position: relative;
            padding: 16px 20px;
            display: flex;
            align-items: center;
            border-bottom: 1px solid #e2e8f0;
        }

        .search-input-box span.search-icon {
            font-size: 18px;
            color: #94a3b8;
            margin-right: 10px;
        }

        .search-input {
            width: 100%;
            border: 0;
            outline: 0;
            font-size: 16px;
            font-weight: 500;
            color: #1e293b;
        }

        .search-input::placeholder {
            color: #94a3b8;
        }

        .btn-clear-search {
            border: 0;
            background: #e2e8f0;
            color: #64748b;
            width: 22px;
            height: 22px;
            border-radius: 50%;
            display: none;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            cursor: pointer;
            margin-left: 8px;
        }

        .btn-close-search {
            border: 0;
            background: transparent;
            color: #64748b;
            font-size: 20px;
            cursor: pointer;
            padding: 4px;
            margin-left: 8px;
        }

        .search-results-area {
            flex: 1;
            overflow-y: auto;
            padding: 16px 20px;
            min-height: 200px;
            max-height: 450px;
        }

        .search-result-item {
            padding: 12px 14px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            cursor: pointer;
            transition: background 0.15s ease;
            margin-bottom: 8px;
            border: 1px solid #f1f5f9;
        }

        .search-result-item:hover {
            background: #f8fafc;
            border-color: #cbd5e1;
        }

        .search-item-title {
            font-size: 15px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 4px;
        }

        .search-item-sub {
            font-size: 13px;
            color: #64748b;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

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
                <button class="icon-button" type="button" aria-label="검색" onclick="openSearchModal()">⌕</button>
                <a class="icon-button" href="/gm" aria-label="구장 관리자 페이지">🏟️</a>
                <a class="icon-button" href="/mypage" aria-label="마이페이지">👤</a>
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
                    String dateStr = date.toString(); // YYYY-MM-DD
                %>
                <button class="date-card <%= i == 0 ? "active" : dayClass %>" type="button" data-date="<%= dateStr %>">
                    <span><%= i == 0 ? "오늘" : dayNames[dayIndex] %></span>
                    <strong><%= date.getDayOfMonth() %></strong>
                </button>
                <% } %>
            </div>
        </section>

        <section class="filter-area" aria-label="매치 필터" style="display: flex; gap: 6px; align-items: center; overflow-x: auto;">
            <button class="filter" id="filterHideEnd" type="button" onclick="toggleMatchFilter('is_end')">마감 가리기</button>
            <button class="filter" id="filterEvening" type="button" onclick="toggleMatchFilter('evening')">☾ 저녁 매치</button>
            
            <select class="filter" id="filterGender" style="padding: 0 10px; height: 36px; cursor: pointer; outline: none;" onchange="changeMatchFilter('is_gender', this.value)">
                <option value="">성별 전체 ▾</option>
                <option value="ANY">남녀 모두 (ANY)</option>
                <option value="MALE">남성 (MALE)</option>
                <option value="FEMALE">여성 (FEMALE)</option>
            </select>

            <select class="filter" id="filterLevel" style="padding: 0 10px; height: 36px; cursor: pointer; outline: none;" onchange="changeMatchFilter('level', this.value)">
                <option value="">레벨 전체 ▾</option>
                <option value="1">레벨 1</option>
                <option value="2">레벨 2</option>
                <option value="3">레벨 3</option>
                <option value="4">레벨 4</option>
                <option value="5">레벨 5</option>
                <option value="6">레벨 6</option>
                <option value="7">레벨 7</option>
                <option value="8">레벨 8</option>
                <option value="9">레벨 9</option>
                <option value="10">레벨 10</option>
            </select>
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

<!-- 검색 모달 (Match / Ground) -->
<div class="search-modal-overlay" id="searchModal" onclick="handleSearchOverlayClick(event)">
    <div class="search-modal-card" onclick="event.stopPropagation()">
        <div class="search-tab-bar">
            <button class="search-tab active" id="tabMatch" onclick="switchSearchTab('match')">
                <span>⚽</span> 매치 검색
            </button>
            <button class="search-tab" id="tabGround" onclick="switchSearchTab('ground')">
                <span>🏟️</span> 구장 검색
            </button>
        </div>
        <div class="search-input-box">
            <span class="search-icon">🔍</span>
            <input type="text" id="searchInput" class="search-input" placeholder="구장명, 지역으로 매치 검색 (예: 강남, 서초)" oninput="handleSearchInput()">
            <button class="btn-clear-search" id="btnSearchClear" onclick="clearSearchInput()">✕</button>
            <button class="btn-close-search" onclick="closeSearchModal()">✕</button>
        </div>
        <div class="search-results-area" id="searchResultsArea">
            <div style="padding: 40px 0; text-align: center; color: #94a3b8; font-size: 14px;">
                검색어를 입력하시면 관련 매치 및 구장을 찾아드립니다.
            </div>
        </div>
    </div>
</div>

<script>
    var currentFilter = {
        is_end: 0,
        evening: null,
        is_gender: null,
        level: null,
        date: null
    };

    var allMatchesData = [];
    var allGroundsData = null;
    var currentSearchTab = 'match';

    function fetchMatches() {
        var params = new URLSearchParams();
        if (currentFilter.is_end === 1) params.append('is_end', '1');
        if (currentFilter.evening) params.append('evening', currentFilter.evening);
        if (currentFilter.is_gender) params.append('is_gender', currentFilter.is_gender);
        if (currentFilter.level) params.append('level', currentFilter.level);
        if (currentFilter.date) params.append('date', currentFilter.date);

        var queryString = params.toString();
        var url = '/api/matches' + (queryString ? '?' + queryString : '');
        console.log('[fetchMatches] API 호출:', url, '필터상태:', currentFilter);

        fetch(url)
            .then(function(res) { return res.json(); })
            .then(function(data) {
                allMatchesData = data || [];
                console.log('[fetchMatches] 수신 데이터 건수:', allMatchesData.length);
                var container = document.getElementById('match-list-container');
                if (!container) return;
                if (!data || data.length === 0) {
                    container.innerHTML = '<p style="padding: 30px 0; color: #888; text-align: center;">조건에 맞는 등록된 매치가 없습니다.</p>';
                    return;
                }
                var html = '';
                data.forEach(function(m) {
                    var matchId = m.matchId || m.match_id || 1;
                    var fieldName = m.fieldName || m.field_name || '경기장';
                    var matchAt = m.matchAt || m.match_at || '';
                    var timeStr = matchAt ? matchAt.substring(11, 16) : '19:00';
                    var gender = m.gender || 'ANY';
                    var genderStr = gender === 'ANY' ? '남녀 모두' : (gender === 'MALE' ? '남성' : '여성');
                    var matchLevel = m.matchLevel || m.match_level || 5;
                    var numMembers = m.numMembers || m.num_members || 12;
                    var statusStr = (m.status === 'CLOSED') ? '마감됨' : '신청 가능';
                    var statusClass = (m.status === 'CLOSED') ? 'status closed' : 'status';
                    var photoUrl = 'https://i.namu.wiki/i/lQIGadGVZtfkSOOba-BOK0J0NpytK5Ur9E3phQeFThfpxuDNKv0c0-rdFmNw5F6fOehk0-kFKCGrDFOeD51S9A.webp';

                    html += '<article class="match-card" style="cursor: pointer;" onclick="location.href=\'/matches/' + matchId + '\'">' +
                                '<div class="time">' + timeStr + '<small>120분</small></div>' +
                                '<div style="flex: 1;">' +
                                    '<h3 class="match-title">' + fieldName + '</h3>' +
                                    '<p class="match-meta">' + genderStr + ' · 레벨 ' + matchLevel + ' · 모집 ' + numMembers + '명</p>' +
                                    '<div class="tags">' +
                                        '<span class="tag beginner">모든 레벨</span>' +
                                        '<span class="tag">풋살화</span>' +
                                    '</div>' +
                                '</div>' +
                                '<img src="' + photoUrl + '" alt="경기장" style="width: 76px; height: 56px; object-fit: cover; border-radius: 8px; margin: 0 10px;">' +
                                '<button class="' + statusClass + '" type="button" onclick="event.stopPropagation(); location.href=\'/matches/' + matchId + '\'">' + statusStr + '</button>' +
                            '</article>';
                });
                container.innerHTML = html;
            })
            .catch(function(err) {
                console.error('매치 목록 로드 실패:', err);
            });
    }

    function toggleMatchFilter(type) {
        if (type === 'is_end') {
            var btn = document.getElementById("filterHideEnd");
            if (btn) {
                btn.classList.toggle("active");
                currentFilter.is_end = btn.classList.contains("active") ? 1 : 0;
            }
        } else if (type === 'evening') {
            var btn = document.getElementById("filterEvening");
            if (btn) {
                btn.classList.toggle("active");
                currentFilter.evening = btn.classList.contains("active") ? 'true' : null;
            }
        }
        fetchMatches();
    }

    function changeMatchFilter(type, value) {
        var selectElem = document.getElementById(type === 'is_gender' ? 'filterGender' : 'filterLevel');
        if (selectElem) {
            if (value) {
                selectElem.classList.add("active");
            } else {
                selectElem.classList.remove("active");
            }
        }

        if (type === 'is_gender') {
            currentFilter.is_gender = value || null;
        } else if (type === 'level') {
            currentFilter.level = value || null;
        }
        fetchMatches();
    }

    function openSearchModal() {
        document.getElementById('searchModal').style.display = 'flex';
        document.getElementById('searchInput').focus();
        if (allGroundsData === null) {
            fetchMyGroundsForSearch();
        }
    }

    function closeSearchModal() {
        document.getElementById('searchModal').style.display = 'none';
    }

    function handleSearchOverlayClick(e) {
        if (e.target.id === 'searchModal') {
            closeSearchModal();
        }
    }

    function switchSearchTab(tab) {
        currentSearchTab = tab;
        var tabMatch = document.getElementById('tabMatch');
        var tabGround = document.getElementById('tabGround');
        var input = document.getElementById('searchInput');

        if (tab === 'match') {
            tabMatch.classList.add('active');
            tabGround.classList.remove('active');
            input.placeholder = "구장명, 지역으로 매치 검색 (예: 강남, 서초)";
        } else {
            tabGround.classList.add('active');
            tabMatch.classList.remove('active');
            input.placeholder = "구장 이름, 주소로 구장 검색 (예: 핀랩 풋살 파크)";
        }
        handleSearchInput();
    }

    function clearSearchInput() {
        var input = document.getElementById('searchInput');
        input.value = '';
        document.getElementById('btnSearchClear').style.display = 'none';
        handleSearchInput();
        input.focus();
    }

    function fetchMyGroundsForSearch() {
        fetch('/api/ground/my')
            .then(function(res) {
                if (!res.ok) return [];
                return res.json();
            })
            .then(function(data) {
                allGroundsData = data || [];
            })
            .catch(function(err) {
                console.error('구장 목록 검색용 로드 오류:', err);
                allGroundsData = [];
            });
    }

    function handleSearchInput() {
        var keyword = document.getElementById('searchInput').value.trim().toLowerCase();
        var clearBtn = document.getElementById('btnSearchClear');
        clearBtn.style.display = keyword.length > 0 ? 'inline-flex' : 'none';

        var resultsArea = document.getElementById('searchResultsArea');

        if (!keyword) {
            resultsArea.innerHTML = 
                '<div style="padding: 40px 0; text-align: center; color: #94a3b8; font-size: 14px;">' +
                    (currentSearchTab === 'match' ? '⚽ 검색어를 입력하시면 관련 소셜 매치를 찾아드립니다.' : '🏟️ 검색어를 입력하시면 구장을 찾아드립니다.') +
                '</div>';
            return;
        }

        if (currentSearchTab === 'match') {
            var filteredMatches = allMatchesData.filter(function(m) {
                var name = (m.field_name || '').toLowerCase();
                return name.includes(keyword);
            });

            if (filteredMatches.length === 0) {
                resultsArea.innerHTML = '<div style="padding: 40px 0; text-align: center; color: #94a3b8; font-size: 14px;">"<b>' + keyword + '</b>" 검색어와 일치하는 매치가 없습니다.</div>';
                return;
            }

            var html = '';
            filteredMatches.forEach(function(m) {
                var timeStr = m.match_at ? m.match_at.substring(11, 16) : '19:00';
                var genderStr = m.gender === 'ANY' ? '남녀 모두' : (m.gender === 'MALE' ? '남성' : '여성');

                html += '<div class="search-result-item" onclick="location.href=\'/matches/' + (m.match_id || 1) + '\'">' +
                            '<div>' +
                                '<div class="search-item-title">⚽ ' + (m.field_name || '경기장') + '</div>' +
                                '<div class="search-item-sub">⏰ ' + timeStr + ' · ' + genderStr + ' · 레벨 ' + (m.match_level || 5) + '</div>' +
                            '</div>' +
                            '<span style="font-size: 13px; font-weight: 700; color: var(--blue);">매치 보기 ›</span>' +
                        '</div>';
            });
            resultsArea.innerHTML = html;

        } else {
            resultsArea.innerHTML = '<div style="padding: 30px 0; text-align: center; color: #64748b; font-size: 14px;">🔍 XPath 로 구장 및 일정 데이터를 검색 중입니다...</div>';

            var xmlPayload = '<?xml version="1.0" encoding="UTF-8"?><search><ground_name>' + keyword + '</ground_name></search>';

            fetch('/api/search/ground', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/xml; charset=UTF-8'
                },
                body: xmlPayload
            })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                if (!data.success || !data.grounds || data.grounds.length === 0) {
                    resultsArea.innerHTML = '<div style="padding: 40px 0; text-align: center; color: #94a3b8; font-size: 14px;">"<b>' + keyword + '</b>" 검색어와 일치하는 구장이 없습니다.</div>';
                    return;
                }

                var htmlG = '';
                data.grounds.forEach(function(g) {
                    var managerInfo = g.managerName ? ' (담당: ' + g.managerName + ')' : '';
                    var scheduleInfo = g.scheduleCount ? ' · 9월 예약가능 ' + g.scheduleCount + '개 슬롯' : '';

                    htmlG += '<div class="search-result-item" style="cursor: default;">' +
                                '<div>' +
                                    '<div class="search-item-title">🏟️ ' + (g.name || '구장') + ' <small style="color:#64748b; font-weight: normal;">[' + g.key + ']</small></div>' +
                                    '<div class="search-item-sub">👤 관리자: ' + (g.managerName || '매니저') + scheduleInfo + '</div>' +
                                '</div>' +
                            '</div>';
                });
                resultsArea.innerHTML = htmlG;
            })
            .catch(function(err) {
                console.error('XPath 구장 검색 실패:', err);
                resultsArea.innerHTML = '<div style="padding: 40px 0; text-align: center; color: #ef4444; font-size: 14px;">구장 검색 중 오류가 발생했습니다.</div>';
            });
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        // 날짜 카드 이벤트 바인딩
        var dateCards = document.querySelectorAll(".date-card");
        if (dateCards.length > 0) {
            currentFilter.date = dateCards[0].getAttribute("data-date") || null;
            dateCards.forEach(function (button) {
                button.addEventListener("click", function () {
                    dateCards.forEach(function (item) { item.classList.remove("active"); });
                    button.classList.add("active");
                    currentFilter.date = button.getAttribute("data-date") || null;
                    fetchMatches();
                });
            });
        }

        // 초기 매치 목록 조회
        fetchMatches();

        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeSearchModal();
            }
        });
    });
</script>
</body>
</html>
