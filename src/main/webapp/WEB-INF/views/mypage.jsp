<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finlab - 마이페이지</title>
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
        }

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
            text-decoration: none;
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

        .service-nav a.active {
            color: var(--ink);
            font-weight: 800;
        }

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

        .mypage-content {
            padding: 28px 24px 110px;
        }

        .profile-card {
            display: flex;
            align-items: center;
            gap: 18px;
            padding: 24px;
            border-radius: 16px;
            background: linear-gradient(135deg, #1570ff, #0758d7);
            color: #fff;
            margin-bottom: 24px;
            box-shadow: 0 10px 24px rgba(21, 112, 255, .25);
        }

        .avatar-box {
            position: relative;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
            flex-shrink: 0;
        }

        .avatar {
            display: grid;
            width: 72px;
            height: 72px;
            place-items: center;
            border-radius: 50%;
            background: rgba(255, 255, 255, .25);
            font-size: 36px;
            overflow: hidden;
            border: 2px solid rgba(255, 255, 255, .5);
        }

        .avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .profile-btn-group {
            display: flex;
            gap: 6px;
            margin-top: 4px;
        }

        .btn-profile-act {
            padding: 4px 8px;
            border: 0;
            border-radius: 6px;
            background: rgba(255, 255, 255, .2);
            color: #fff;
            font-size: 11px;
            font-weight: 700;
            transition: background 0.2s;
        }

        .btn-profile-act:hover {
            background: rgba(255, 255, 255, .35);
        }

        .btn-profile-del {
            background: rgba(255, 77, 79, .3);
        }

        .btn-profile-del:hover {
            background: rgba(255, 77, 79, .5);
        }

        .user-title {
            margin: 0 0 4px;
            font-size: 20px;
            font-weight: 800;
        }

        .user-username {
            margin: 0;
            font-size: 13px;
            opacity: 0.85;
        }

        .role-badge {
            display: inline-block;
            margin-top: 6px;
            padding: 3px 8px;
            border-radius: 6px;
            background: rgba(255, 255, 255, .25);
            font-size: 11px;
            font-weight: 700;
        }

        .section-title {
            font-size: 16px;
            font-weight: 800;
            margin: 0 0 14px;
            color: #22252b;
        }

        .info-card {
            border: 1px solid var(--line);
            border-radius: 14px;
            background: #fff;
            padding: 20px;
            margin-bottom: 24px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #f4f6f8;
        }

        .info-row:last-child {
            border-bottom: 0;
            padding-bottom: 0;
        }

        .info-row:first-child {
            padding-top: 0;
        }

        .info-label {
            color: #80858f;
            font-size: 14px;
            font-weight: 500;
        }

        .info-value {
            color: var(--ink);
            font-size: 14px;
            font-weight: 700;
        }

        .menu-list {
            list-style: none;
            padding: 0;
            margin: 0 0 24px;
            border: 1px solid var(--line);
            border-radius: 14px;
            overflow: hidden;
        }

        .menu-item a {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px 20px;
            background: #fff;
            color: var(--ink);
            font-size: 15px;
            font-weight: 600;
            text-decoration: none;
            border-bottom: 1px solid #f4f6f8;
        }

        .menu-item:last-child a {
            border-bottom: 0;
        }

        .menu-item a:hover {
            background: #f8fafc;
        }

        .btn-logout {
            width: 100%;
            padding: 14px;
            border: 1px solid #ff4d4f;
            border-radius: 12px;
            background: #fff;
            color: #ff4d4f;
            font-size: 15px;
            font-weight: 700;
            margin-top: 10px;
        }

        .btn-logout:hover {
            background: #fff1f0;
        }

        /* MFA Toggle Switch */
        .switch {
            position: relative;
            display: inline-block;
            width: 46px;
            height: 26px;
            margin: 0;
        }
        .switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        .slider {
            position: absolute;
            cursor: pointer;
            top: 0; left: 0; right: 0; bottom: 0;
            background-color: #cbd5e1;
            transition: .3s;
            border-radius: 26px;
        }
        .slider:before {
            position: absolute;
            content: "";
            height: 20px;
            width: 20px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: .3s;
            border-radius: 50%;
            box-shadow: 0 1px 3px rgba(0,0,0,0.2);
        }
        input:checked + .slider {
            background-color: #1570ff !important;
        }
        input:checked + .slider:before {
            transform: translateX(20px);
        }

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

        .bottom-nav span {
            font-size: 22px;
            line-height: 1.1;
        }

        .bottom-nav a.active {
            color: var(--blue);
            font-weight: 700;
        }

        @media (max-width: 600px) {
            body { background: #fff; }
            .page { box-shadow: none; }
            .header-main { height: 58px; padding: 0 18px; }
            .service-nav { height: 46px; padding: 0 8px; }
            .mypage-content { padding: 24px 18px 100px; }
            .bottom-nav { display: flex; }
        }
        /* 💡 매치/구장 검색 모달과 100% 동일한 고정 위치 팝업 스타일 */
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
        }

        .search-modal-card {
            width: min(90%, 480px);
            display: flex;
            flex-direction: column;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
            padding: 24px;
            overflow: hidden;
        }

        .user-modal-backdrop {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            z-index: 1000;
            display: none;
            align-items: center;
            justify-content: center;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(8px);
        }
    </style>
</head>
<body>
<div class="page">
    <header class="header">
        <div class="header-main">
            <a class="brand" href="/">Finlab</a>
            <div class="header-actions">
                <button class="icon-button" type="button" aria-label="검색" onclick="openUserSearchModal()">⌕</button>
                <a class="icon-button" href="/mypage" aria-label="마이페이지" style="text-decoration:none; color: var(--blue);">●</a>
            </div>
        </div>
        <nav class="service-nav" aria-label="서비스 메뉴">
            <a href="/">소셜 매치</a>
            <a href="/board">게시판</a>
            <a href="/notice">공지사항</a>
        </nav>
    </header>

    <main class="mypage-content">
        <!-- 서버 단에서 문자열 조립된 유저 검색 결과 HTML -->
        ${userSearchResultHtml}

        <!-- 프로필 카드 -->
        <div class="profile-card">
            <div class="avatar-box">
                <div class="avatar" id="avatarDisplay">👤</div>
                <div class="profile-btn-group">
                    <button type="button" class="btn-profile-act" onclick="triggerProfileUpload()">변경</button>
                    <button type="button" class="btn-profile-act btn-profile-del" onclick="deleteProfileImage()">삭제</button>
                </div>
                <input type="file" id="profileFileInput" style="display:none;" accept="image/jpeg,image/jpg,image/png">
            </div>
            <div>
                <h1 class="user-title" id="userName">남정운</h1>
                <p class="user-username" id="userUsername">@cloudnaam</p>
                <div id="userRoleContainer"><span class="role-badge" id="userRole">일반 회원</span></div>
            </div>
        </div>

        <!-- 내 계정 정보 -->
        <h2 class="section-title">내 계정 정보</h2>
        <div class="info-card">
            <div class="info-row">
                <span class="info-label">이름</span>
                <span class="info-value" id="infoName">남정운</span>
            </div>
            <div class="info-row">
                <span class="info-label">아이디 (Username)</span>
                <span class="info-value" id="infoUsername">cloudnaam</span>
            </div>
            <div class="info-row">
                <span class="info-label">이메일</span>
                <span class="info-value" id="infoEmail">cile0629@gmail.com</span>
            </div>
            <div class="info-row">
                <span class="info-label">전화번호</span>
                <span class="info-value" id="infoPhone">-</span>
            </div>
            <div class="info-row">
                <span class="info-label">성별 / 나이</span>
                <span class="info-value" id="infoGenderAge">남성 · 28세</span>
            </div>
            <div class="info-row" style="background: #f8fafc; border-radius: 8px; margin-top: 4px;">
                <span class="info-label" style="font-weight: 700; color: var(--blue);">💰 보유 포인트</span>
                <div style="display: flex; align-items: center; gap: 8px;">
                    <span class="info-value" id="infoPoint" style="font-size: 16px; font-weight: 800; color: #1e293b;">1,000 P</span>
                    <button type="button" class="btn-profile-act" style="background: #10b981; color: #fff; padding: 4px 10px;" onclick="openChargeModal()">⚡ 충전하기</button>
                    <button type="button" class="btn-profile-act" style="background: var(--blue); color: #fff; padding: 4px 10px;" onclick="openPointModal()">🎁 선물하기</button>
                </div>
            </div>
        </div>

        <!-- ⚽ 내가 신청한 매치 목록 -->
        <h2 class="section-title" style="display: flex; align-items: center; justify-content: space-between;">
            <span>⚽ 내가 신청한 매치</span>
            <span id="myMatchCountBadge" style="font-size: 12px; background: #eaf3ff; color: var(--blue); padding: 2px 8px; border-radius: 10px; font-weight: 700;">0건</span>
        </h2>
        <div id="myMatchListContainer" style="display: flex; flex-direction: column; gap: 10px; margin-bottom: 24px;">
            <p style="color: #94a3b8; font-size: 13px; text-align: center; padding: 20px 0;">신청한 매치 내역을 불러오는 중...</p>
        </div>

        <!-- 계정 설정 메뉴 -->
        <h2 class="section-title">계정 및 서비스 설정</h2>
        <ul class="menu-list">
            <li class="menu-item"><a href="/mypage/edit"><span>👤 내 정보 수정</span><span>›</span></a></li>
            <li class="menu-item"><a href="/mypage/edit"><span>🔒 비밀번호 변경</span><span>›</span></a></li>
            <li class="menu-item" style="display: flex; align-items: center; justify-content: space-between; padding: 14px 20px; background: #fff; border-bottom: 1px solid #f4f6f8;">
                <div style="display: flex; align-items: center; gap: 8px;">
                    <span style="font-size: 15px; font-weight: 600; color: var(--ink);">🔐 2단계 인증 (MFA)</span>
                    <span id="mfaBadge" style="font-size: 11px; padding: 2px 6px; border-radius: 4px; font-weight: 700; background: #f1f5f9; color: #64748b;">OFF</span>
                </div>
                <label class="switch">
                    <input type="checkbox" id="mfaToggleSwitch" onchange="handleMfaToggle(this.checked)">
                    <span class="slider"></span>
                </label>
            </li>
            <li class="menu-item"><a href="#" onclick="alert('페이지 준비중입니다.')"><span>🔔 알림 설정</span><span>›</span></a></li>
            <li class="menu-item"><a href="#" onclick="handleWithdrawAccount()" style="color: #ef4444;"><span>🚪 회원 탈퇴</span><span style="color: #ef4444;">›</span></a></li>
        </ul>

        <!-- 핀랩풋볼 카테고리 -->
        <h2 class="section-title">핀랩풋볼</h2>
        <ul class="menu-list">
            <li class="menu-item"><a href="#" onclick="alert('페이지 준비중입니다.')"><span>⚽ 핀랩풋볼 소개</span><span>›</span></a></li>
            <li class="menu-item"><a href="#" onclick="alert('페이지 준비중입니다.')"><span>📖 매거진</span><span>›</span></a></li>
            <li class="menu-item"><a href="/mypage/apply"><span>🏃 매니저지원</span><span>›</span></a></li>
            <li class="menu-item"><a href="#" onclick="alert('페이지 준비중입니다.')"><span>🏟️ 구장 제휴</span><span>›</span></a></li>
            <li class="menu-item"><a href="#" onclick="alert('페이지 준비중입니다.')"><span>💼 채용</span><span>›</span></a></li>
        </ul>

        <!-- 약관 및 정책 -->
        <ul class="menu-list">
            <li class="menu-item"><a href="#" onclick="alert('페이지 준비중입니다.')"><span>📄 이용약관</span><span>›</span></a></li>
            <li class="menu-item"><a href="#" onclick="alert('페이지 준비중입니다.')"><span>🛡️ 개인정보 처리방침</span><span>›</span></a></li>
        </ul>

        <button type="button" class="btn-logout" onclick="handleLogout()">로그아웃</button>
    </main>

    <nav class="bottom-nav" aria-label="하단 메뉴">
        <a href="/"><span>⚽</span>매치</a>
        <a href="/board"><span>📋</span>게시판</a>
        <a href="/notice"><span>📢</span>공지</a>
        <a class="active" href="/mypage"><span>●</span>MY</a>
    </nav>
</div>

<!-- 🔍 회원 검색 모달 (Match / Ground 검색 모달과 100% 동일 구조) -->
<div class="search-modal-overlay" id="userSearchModal" onclick="closeUserSearchModalOnBackdrop(event)">
    <div class="search-modal-card" onclick="event.stopPropagation()">
        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 12px;">
            <h3 style="margin: 0; font-size: 18px; font-weight: 800; color: #1e293b;">👤 회원 검색</h3>
            <button type="button" onclick="closeUserSearchModal()" style="border: 0; background: transparent; font-size: 20px; cursor: pointer; color: #94a3b8;">✕</button>
        </div>
        <p style="font-size: 13px; color: #64748b; margin-top: 0; margin-bottom: 16px;">회원 이름, 아이디 또는 이메일로 검색해 보세요.</p>
        <form action="/mypage" method="GET" style="display: flex; gap: 8px;">
            <input type="text" name="user" id="userSearchInput" value="${userKeyword}" placeholder="회원 이름 또는 아이디 입력..." style="flex: 1; height: 48px; padding: 0 16px; border: 1px solid #cbd5e1; border-radius: 12px; font-size: 14px; outline: none; background: #f8fafc;" required>
            <button type="submit" style="padding: 0 20px; height: 48px; background: var(--blue); color: #fff; border: 0; border-radius: 12px; font-weight: 700; font-size: 14px; cursor: pointer;">검색</button>
        </form>
    </div>
</div>

<!-- 🎁 포인트 선물하기 모달 -->
<div id="pointSendModal" class="user-modal-backdrop" onclick="closePointModalOnBackdrop(event)" style="display: none;">
    <div class="user-modal-content" onclick="event.stopPropagation()" style="width: min(90%, 400px); padding: 24px; border-radius: 20px; background: #fff; box-shadow: 0 20px 40px rgba(0,0,0,0.2);">
        <h3 style="margin-top:0; font-size:18px; font-weight:800; color:#1e293b;">🎁 포인트 선물하기</h3>
        <p style="font-size:13px; color:#64748b; margin-bottom:16px;">다른 회원에게 포인트를 선물하세요.</p>
        <form id="pointSendForm" onsubmit="handleSendPoint(event)">
            <!-- 💡 세션 CSRF 토큰 직접 주입 -->
            <input type="hidden" name="csrfToken" id="pointCsrfToken" value="${sessionScope.CSRF_TOKEN}">

            <div style="margin-bottom: 12px; text-align: left;">
                <label style="font-size:12px; font-weight:700; color:#475569;">받는 사람 (이름 또는 아이디)</label>
                <input type="text" id="sendToInput" name="send_to" class="user-search-input" style="width:100%; box-sizing:border-box; margin-top:4px;" placeholder="예: 홍길동 또는 user01" required>
            </div>
            <div style="margin-bottom: 16px; text-align: left;">
                <label style="font-size:12px; font-weight:700; color:#475569;">선물할 포인트 (P)</label>
                <input type="number" id="sendPointInput" name="send_point" class="user-search-input" style="width:100%; box-sizing:border-box; margin-top:4px;" placeholder="예: 1000" min="1" required>
            </div>
            <div style="display: flex; gap: 8px; justify-content: flex-end;">
                <button type="button" class="btn-profile-act" style="background:#e2e8f0; color:#334155; padding:8px 16px;" onclick="closePointModal()">취소</button>
                <button type="submit" id="pointSubmitBtn" class="btn-profile-act" style="background:var(--blue); color:#fff; padding:8px 16px;">선물하기</button>
            </div>
        </form>
    </div>
</div>

<!-- ⚡ 포인트 충전하기 모달 -->
<div id="pointChargeModal" class="user-modal-backdrop" onclick="closeChargeModalOnBackdrop(event)" style="display: none;">
    <div class="user-modal-content" onclick="event.stopPropagation()" style="width: min(90%, 400px); padding: 24px; border-radius: 20px; background: #fff; box-shadow: 0 20px 40px rgba(0,0,0,0.2);">
        <h3 style="margin-top:0; font-size:18px; font-weight:800; color:#1e293b;">⚡ 포인트 충전</h3>
        <p style="font-size:13px; color:#64748b; margin-bottom:16px;">충전할 금액을 선택하거나 직접 입력하세요.</p>
        <form id="pointChargeForm" onsubmit="handleRequestCharge(event)">
            <div style="margin-bottom: 12px; text-align: left;">
                <label style="font-size:12px; font-weight:700; color:#475569;">충전 금액 선택</label>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 8px; margin-top: 6px;">
                    <button type="button" class="btn-profile-act" style="background:#f1f5f9; color:#1e293b; padding:10px; font-weight:700;" onclick="setChargeAmount(5000)">5,000원</button>
                    <button type="button" class="btn-profile-act" style="background:#f1f5f9; color:#1e293b; padding:10px; font-weight:700;" onclick="setChargeAmount(10000)">10,000원</button>
                    <button type="button" class="btn-profile-act" style="background:#f1f5f9; color:#1e293b; padding:10px; font-weight:700;" onclick="setChargeAmount(30000)">30,000원</button>
                    <button type="button" class="btn-profile-act" style="background:#f1f5f9; color:#1e293b; padding:10px; font-weight:700;" onclick="setChargeAmount(50000)">50,000원</button>
                </div>
            </div>
            <div style="margin-bottom: 16px; text-align: left;">
                <label style="font-size:12px; font-weight:700; color:#475569;">충전할 금액 (원)</label>
                <input type="number" id="chargeAmountInput" name="amount" class="user-search-input" style="width:100%; box-sizing:border-box; margin-top:4px;" value="10000" min="1000" step="1000" required>
            </div>
            <div style="display: flex; gap: 8px; justify-content: flex-end;">
                <button type="button" class="btn-profile-act" style="background:#e2e8f0; color:#334155; padding:8px 16px;" onclick="closeChargeModal()">취소</button>
                <button type="submit" id="chargeSubmitBtn" class="btn-profile-act" style="background:#10b981; color:#fff; padding:8px 16px;">결제 진행하기</button>
            </div>
        </form>
    </div>
</div>

<script>
    function triggerProfileUpload() {
        document.getElementById('profileFileInput').click();
    }

    document.getElementById('profileFileInput').addEventListener('change', function(e) {
        var file = e.target.files[0];
        if (!file) return;

        var formData = new FormData();
        formData.append('profile_img', file);

        var csrfVal = document.getElementById('pointCsrfToken') ? document.getElementById('pointCsrfToken').value : (window.sessionCsrfToken || '');
        if (csrfVal) formData.append('csrfToken', csrfVal);

        fetch('/api/profile/imgup', {
            method: 'POST',
            body: formData
        })
        .then(function(res) {
            if (!res.ok) {
                throw new Error('프로필 사진은 jpg, png 이미지 파일만 업로드할 수 있습니다.');
            }
            return res.json();
        })
        .then(function(data) {
            if (data && data.success && data.profile_img) {
                var avatarDisplay = document.getElementById('avatarDisplay');
                avatarDisplay.innerHTML = '<img src="' + data.profile_img + '?t=' + new Date().getTime() + '" alt="프로필 사진">';
                alert('프로필 사진이 성공적으로 변경되었습니다.');
            } else {
                alert('프로필 사진 업로드에 실패했습니다.');
            }
        })
        .catch(function(err) {
            console.error('프로필 업로드 오류:', err);
            alert(err.message || '프로필 업로드 중 오류가 발생했습니다.');
        });
    });

    function deleteProfileImage() {
        if (!confirm('프로필 사진을 삭제하시겠습니까?')) return;

        fetch('/api/profile/imagedel', {
            method: 'DELETE'
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data && data.success) {
                var avatarDisplay = document.getElementById('avatarDisplay');
                avatarDisplay.innerHTML = '👤';
                alert('프로필 사진이 삭제되었습니다.');
            } else {
                alert('삭제할 프로필 사진이 없거나 삭제 처리에 실패했습니다.');
            }
        })
        .catch(function(err) {
            console.error('프로필 사진 삭제 오류:', err);
            alert('프로필 사진 삭제 중 오류가 발생했습니다.');
        });
    }

    function fetchMyProfile() {
        fetch('/api/profile/me')
            .then(function(res) {
                if (!res.ok) {
                    location.href = '/login';
                    return null;
                }
                return res.json();
            })
            .then(function(data) {
                if (!data) return;
                window.currentUser = data;
                window.currentUserId = data.userId;

                document.getElementById('userName').textContent = data.name || "사용자";
                document.getElementById('userUsername').textContent = "@" + (data.username || "user");

                var roleElem = document.getElementById('userRoleContainer');
                if (roleElem) {
                    if (data.isAdmin === 1) {
                        roleElem.innerHTML = '<a href="http://192.168.21.218:8080" target="_blank" class="role-badge" title="192.168.21.218:8080" style="text-decoration:none; cursor:pointer; background:rgba(21,112,255,0.15); color:var(--blue); font-weight:700;">🛡️ 관리자 계정 (Backoffice ↗)</a>';
                    } else if (data.isManager === 1) {
                        roleElem.innerHTML = '<span class="role-badge" style="background:#e0f2fe; color:#0369a1; font-weight:700;">🏟️ 구장 매니저</span>';
                    } else {
                        roleElem.innerHTML = '<span class="role-badge">일반 회원</span>';
                    }
                }

                document.getElementById('infoName').textContent = data.name || "-";
                document.getElementById('infoUsername').textContent = data.username || "-";
                document.getElementById('infoEmail').textContent = data.email || "-";
                document.getElementById('infoPhone').textContent = data.phoneNumber || "-";

                var genderStr = data.gender === "MALE" ? "남성" : (data.gender === "FEMALE" ? "여성" : "미지정");
                var ageStr = data.age ? data.age + "세" : "-";
                document.getElementById('infoGenderAge').textContent = genderStr + " · " + ageStr;
                document.getElementById('infoPoint').textContent = (data.point != null ? data.point.toLocaleString() : '0') + ' P';

                var avatarDisplay = document.getElementById('avatarDisplay');
                if (data.profileImg && data.profileImg.trim() !== '') {
                    var imgPath = data.profileImg.startsWith('/') ? data.profileImg : '/uploads/profile/' + data.profileImg;
                    avatarDisplay.innerHTML = '<img src="' + imgPath + '?t=' + new Date().getTime() + '" alt="프로필 사진">';
                } else {
                    avatarDisplay.innerHTML = '👤';
                }

                // 🔐 2단계 인증(MFA) 상태 스위치 초기화
                var isMfaOn = (data.mfa_enabled === 1 || data.mfaEnabled === 1);
                var toggleSwitch = document.getElementById('mfaToggleSwitch');
                var mfaBadge = document.getElementById('mfaBadge');
                if (toggleSwitch && mfaBadge) {
                    toggleSwitch.checked = isMfaOn;
                    if (isMfaOn) {
                        mfaBadge.textContent = 'ON';
                        mfaBadge.style.background = '#e0f2fe';
                        mfaBadge.style.color = '#0284c7';
                    } else {
                        mfaBadge.textContent = 'OFF';
                        mfaBadge.style.background = '#f1f5f9';
                        mfaBadge.style.color = '#64748b';
                    }
                }
            })
            .catch(function(err) {
                console.error('프로필 정보를 불러오는데 실패했습니다:', err);
                location.href = '/login';
            });
    }

    function handleMfaToggle(checked) {
        var mfaEnabled = checked ? 1 : 0;
        var csrfVal = document.getElementById('pointCsrfToken') ? document.getElementById('pointCsrfToken').value : (window.sessionCsrfToken || '');

        fetch('/api/profile/mfa', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                mfa_enabled: mfaEnabled,
                csrfToken: csrfVal
            })
        })
        .then(function(res) { return res.json(); })
        .then(function(resData) {
            if (resData.success) {
                var badge = document.getElementById('mfaBadge');
                if (mfaEnabled === 1) {
                    badge.textContent = 'ON';
                    badge.style.background = '#e0f2fe';
                    badge.style.color = '#0284c7';
                    alert('🔐 2단계 인증(MFA)이 활성화되었습니다!\n다음 로그인부터 회원님의 이메일로 4자리 인증 코드가 발송됩니다.');
                } else {
                    badge.textContent = 'OFF';
                    badge.style.background = '#f1f5f9';
                    badge.style.color = '#64748b';
                    alert('2단계 인증(MFA)이 해제되었습니다.');
                }
            } else {
                alert(resData.message || '2단계 인증 설정에 실패했습니다.');
                document.getElementById('mfaToggleSwitch').checked = !checked;
            }
        })
        .catch(function(err) {
            alert('네트워크 오류가 발생했습니다.');
            document.getElementById('mfaToggleSwitch').checked = !checked;
        });
    }

    function handleLogout() {
        if (confirm('로그아웃 하시겠습니까?')) {
            fetch('/api/auth/logout', { method: 'POST' })
                .then(function() {
                    document.cookie = "user_id=; path=/; max-age=0;";
                    alert('로그아웃 되었습니다.');
                    location.href = '/login';
                })
                .catch(function() {
                    document.cookie = "user_id=; path=/; max-age=0;";
                    location.href = '/login';
                });
        }
    }

    function fetchMyAppliedMatches() {
        fetch('/api/matches/my')
            .then(function(res) {
                if (!res.ok) return [];
                return res.json();
            })
            .then(function(matches) {
                var container = document.getElementById('myMatchListContainer');
                var countBadge = document.getElementById('myMatchCountBadge');
                if (!container) return;

                if (!matches || matches.length === 0) {
                    if (countBadge) countBadge.innerText = '0건';
                    container.innerHTML = '<div style="background: #f8fafc; border: 1px dashed #cbd5e1; border-radius: 14px; padding: 24px 16px; text-align: center; color: #94a3b8; font-size: 13px;">아직 신청한 매치가 없습니다.<br/><a href="/" style="color: var(--blue); font-weight: 700; text-decoration: none; margin-top: 8px; display: inline-block;">⚽ 매치 둘러보기 ›</a></div>';
                    return;
                }

                if (countBadge) countBadge.innerText = matches.length + '건';

                var html = '';
                matches.forEach(function(m) {
                    var matchId = m.match_id || m.matchId;
                    var fieldName = m.field_name || m.fieldName || '구장';
                    var matchAt = m.match_at || m.matchAt || '';
                    var matchTimeStr = matchAt ? matchAt.replace('T', ' ') : '일시 미정';
                    var region = m.region || '지역 미정';

                    html += '<div style="background: #fff; border: 1px solid #e2e8f0; border-radius: 14px; padding: 14px 16px; display: flex; align-items: center; justify-content: space-between; cursor: pointer; transition: all 0.15s ease;" onclick="location.href=\'/matches/' + matchId + '\'">' +
                                '<div>' +
                                    '<div style="display: flex; align-items: center; gap: 6px; margin-bottom: 4px;">' +
                                        '<span style="background: #ecfdf5; color: #059669; font-size: 11px; font-weight: 800; padding: 2px 6px; border-radius: 6px;">참가 확정</span>' +
                                        '<strong style="font-size: 15px; color: #1e293b;">' + fieldName + '</strong>' +
                                    '</div>' +
                                    '<div style="font-size: 12px; color: #64748b;">📅 ' + matchTimeStr + ' · 📍 ' + region + '</div>' +
                                '</div>' +
                                '<div style="display: flex; align-items: center; gap: 8px;">' +
                                    '<button type="button" style="background: #fee2e2; color: #dc2626; border: 1px solid #fca5a5; padding: 6px 12px; font-size: 12px; font-weight: 700; border-radius: 8px; cursor: pointer;" onclick="handleCancelMyMatch(' + matchId + ', event)">신청취소(환불)</button>' +
                                    '<span style="font-size: 18px; color: #94a3b8;">›</span>' +
                                '</div>' +
                            '</div>';
                });
                container.innerHTML = html;
            })
            .catch(function(err) {
                console.error('내 신청 매치 목록 로드 실패:', err);
            });
    }

    function handleCancelMyMatch(matchId, event) {
        if (event) event.stopPropagation();
        if (!confirm("매치 신청을 취소하고 포인트를 환불받으시겠습니까?")) return;

        fetch('/api/matches/cancel', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ match_id: String(matchId) })
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data && data.success) {
                alert(data.message || "매치 신청이 취소되었으며 환불이 완료되었습니다.");
                fetchMyAppliedMatches();
                fetchMyProfile();
            } else {
                alert("취소 실패: " + (data.message || "오류가 발생했습니다."));
            }
        })
        .catch(function(err) {
            alert("취소 요청 중 오류가 발생했습니다: " + err.message);
        });
    }

    document.addEventListener("DOMContentLoaded", function() {
        fetchMyProfile();
        fetchMyAppliedMatches();
        window.sessionCsrfToken = '${sessionScope.CSRF_TOKEN}';
    });

    function openUserSearchModal() {
        var modal = document.getElementById('userSearchModal');
        if (modal) modal.style.display = 'flex';
        var input = document.getElementById('userSearchInput');
        if (input) setTimeout(function(){ input.focus(); }, 100);
    }

    function closeUserSearchModal() {
        var modal = document.getElementById('userSearchModal');
        if (modal) modal.style.display = 'none';
    }

    function closeUserSearchModalOnBackdrop(e) {
        if (e.target && e.target.id === 'userSearchModal') {
            closeUserSearchModal();
        }
    }

    function openPointModal() {
        var modal = document.getElementById('pointSendModal');
        if (modal) modal.style.display = 'flex';
        var input = document.getElementById('sendToInput');
        if (input) setTimeout(function(){ input.focus(); }, 100);
    }

    function closePointModal() {
        var modal = document.getElementById('pointSendModal');
        if (modal) modal.style.display = 'none';
    }

    function closePointModalOnBackdrop(e) {
        if (e.target && e.target.id === 'pointSendModal') {
            closePointModal();
        }
    }

    function handleSendPoint(e) {
        e.preventDefault();

        var sendTo = document.getElementById('sendToInput').value.trim();
        var sendPointVal = parseInt(document.getElementById('sendPointInput').value.trim(), 10);
        var csrfVal = document.getElementById('pointCsrfToken').value;

        if (!sendTo || isNaN(sendPointVal) || sendPointVal <= 0) {
            alert('받는 사람과 유효한 포인트를 입력해주세요.');
            return;
        }

        var submitBtn = document.getElementById('pointSubmitBtn');
        submitBtn.disabled = true;
        submitBtn.innerText = '전송 중...';

        var payload = {
            send_to: sendTo,
            send_point: sendPointVal,
            csrfToken: csrfVal
        };

        fetch('/api/point/send', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(payload)
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            submitBtn.disabled = false;
            submitBtn.innerText = '선물하기';

            if (data && data.success) {
                alert('포인트를 성공적으로 전달했습니다!');
                closePointModal();
                fetchMyProfile();
            } else {
                alert('포인트 전달 실패: ' + (data.message || '오류가 발생했습니다.'));
            }
        })
        .catch(function(err) {
            submitBtn.disabled = false;
            submitBtn.innerText = '선물하기';
            alert('요청 처리 중 오류가 발생했습니다.');
        });
    }

    function openChargeModal() {
        var modal = document.getElementById('pointChargeModal');
        if (modal) modal.style.display = 'flex';
        var input = document.getElementById('chargeAmountInput');
        if (input) setTimeout(function(){ input.focus(); }, 100);
    }

    function closeChargeModal() {
        var modal = document.getElementById('pointChargeModal');
        if (modal) modal.style.display = 'none';
    }

    function closeChargeModalOnBackdrop(e) {
        if (e.target && e.target.id === 'pointChargeModal') {
            closeChargeModal();
        }
    }

    function setChargeAmount(val) {
        var input = document.getElementById('chargeAmountInput');
        if (input) input.value = val;
    }

    function handleRequestCharge(e) {
        e.preventDefault();

        var amountVal = parseInt(document.getElementById('chargeAmountInput').value.trim(), 10);
        if (isNaN(amountVal) || amountVal <= 0) {
            alert('유효한 충전 금액을 입력해주세요.');
            return;
        }

        var submitBtn = document.getElementById('chargeSubmitBtn');
        submitBtn.disabled = true;
        submitBtn.innerText = '주문 생성 중...';

        fetch('/api/point/charge/request', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                amount: amountVal
            })
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            submitBtn.disabled = false;
            submitBtn.innerText = '결제 진행하기';

            if (data && data.success && data.payment_url) {
                closeChargeModal();
                // Mock PG 결제 화면으로 이동
                window.location.href = data.payment_url;
            } else {
                alert('충전 주문 생성 실패: ' + (data.message || '오류가 발생했습니다.'));
            }
        })
        .catch(function(err) {
            submitBtn.disabled = false;
            submitBtn.innerText = '결제 진행하기';
            alert('요청 처리 중 오류가 발생했습니다.');
        });
    }

    // 회원 탈퇴 처리
    function handleWithdrawAccount() {
        if (!confirm("정말로 회원 탈퇴를 진행하시겠습니까?\n탈퇴 시 모든 정보(매치 내역, 포인트 등)가 삭제되며 복구할 수 없습니다.")) {
            return;
        }
        if (!confirm("마지막 확인: 정말로 계정을 삭제하시겠습니까?")) {
            return;
        }

        var inputPassword = prompt("본인 확인을 위해 현재 비밀번호를 입력해주세요:");
        if (inputPassword === null) {
            return; // 취소
        }
        if (!inputPassword || inputPassword.trim() === "") {
            alert("비밀번호를 입력해야 회원 탈퇴가 가능합니다.");
            return;
        }

        var csrfVal = document.getElementById('pointCsrfToken') ? document.getElementById('pointCsrfToken').value : (window.sessionCsrfToken || '');
        var uid = window.currentUserId || (window.currentUser ? window.currentUser.userId : null);

        fetch('/api/profile/withdraw', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                password: inputPassword.trim(),
                user_id: uid,
                csrfToken: csrfVal
            })
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data && data.success) {
                localStorage.removeItem('access_token');
                alert(data.message || "회원 탈퇴가 완료되었습니다.");
                location.href = data.redirect_url || "/login";
            } else {
                alert(data.message || "회원 탈퇴 처리에 실패했습니다.");
            }
        })
        .catch(function(err) {
            console.error("탈퇴 오류:", err);
            alert("회원 탈퇴 처리 중 오류가 발생했습니다.");
        });
    }
</script>


</body>
</html>
