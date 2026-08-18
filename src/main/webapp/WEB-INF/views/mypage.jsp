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
                <span class="info-value" id="infoPhone">010-9554-4872</span>
            </div>
            <div class="info-row">
                <span class="info-label">성별 / 나이</span>
                <span class="info-value" id="infoGenderAge">남성 · 28세</span>
            </div>
            <div class="info-row" style="background: #f8fafc; border-radius: 8px; margin-top: 4px;">
                <span class="info-label" style="font-weight: 700; color: var(--blue);">💰 보유 포인트</span>
                <div style="display: flex; align-items: center; gap: 8px;">
                    <span class="info-value" id="infoPoint" style="font-size: 16px; font-weight: 800; color: #1e293b;">1,000 P</span>
                    <button type="button" class="btn-profile-act" style="background: var(--blue); color: #fff; padding: 4px 10px;" onclick="openPointModal()">🎁 선물하기</button>
                </div>
            </div>
        </div>

        <!-- 계정 설정 메뉴 -->
        <h2 class="section-title">계정 및 서비스 설정</h2>
        <ul class="menu-list">
            <li class="menu-item"><a href="#" onclick="alert('페이지 준비중입니다.')"><span>👤 내 정보 수정</span><span>›</span></a></li>
            <li class="menu-item"><a href="#" onclick="alert('페이지 준비중입니다.')"><span>🔒 비밀번호 변경</span><span>›</span></a></li>
            <li class="menu-item"><a href="#" onclick="alert('페이지 준비중입니다.')"><span>🔔 알림 설정</span><span>›</span></a></li>
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
            })
            .catch(function(err) {
                console.error('프로필 정보를 불러오는데 실패했습니다:', err);
                location.href = '/login';
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

    document.addEventListener("DOMContentLoaded", function() {
        fetchMyProfile();
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
</script>


</body>
</html>
