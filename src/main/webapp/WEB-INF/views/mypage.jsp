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
                <span class="role-badge" id="userRole">관리자 계정</span>
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

<script>
    function triggerProfileUpload() {
        document.getElementById('profileFileInput').click();
    }

    document.getElementById('profileFileInput').addEventListener('change', function(e) {
        var file = e.target.files[0];
        if (!file) return;

        var formData = new FormData();
        formData.append('profile_img', file);

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
                document.getElementById('userRole').textContent = data.isAdmin === 1 ? "관리자 계정" : "일반 회원";

                document.getElementById('infoName').textContent = data.name || "-";
                document.getElementById('infoUsername').textContent = data.username || "-";
                document.getElementById('infoEmail').textContent = data.email || "-";
                document.getElementById('infoPhone').textContent = data.phoneNumber || "-";

                var genderStr = data.gender === "MALE" ? "남성" : (data.gender === "FEMALE" ? "여성" : "미지정");
                var ageStr = data.age ? data.age + "세" : "-";
                document.getElementById('infoGenderAge').textContent = genderStr + " · " + ageStr;

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

    document.addEventListener("DOMContentLoaded", fetchMyProfile);

    function openUserSearchModal() {
        var modal = document.getElementById('userSearchModal');
        if (modal) {
            modal.style.display = 'flex';
            var input = document.getElementById('userSearchInput');
            if (input) input.focus();
        }
    }

    function closeUserSearchModal() {
        var modal = document.getElementById('userSearchModal');
        if (modal) modal.style.display = 'none';
    }

    function handleUserSearchOverlayClick(e) {
        if (e.target.id === 'userSearchModal') {
            closeUserSearchModal();
        }
    }
</script>

<!-- 유저 검색 모달 -->
<div class="search-modal-overlay" id="userSearchModal" onclick="handleUserSearchOverlayClick(event)" style="display: none; position: fixed; z-index: 100; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.4); backdrop-filter: blur(4px); align-items: center; justify-content: center;">
    <div class="search-modal-card" onclick="event.stopPropagation()" style="width: min(90%, 480px); background: #fff; border-radius: 20px; padding: 24px; box-shadow: 0 10px 30px rgba(0,0,0,0.15);">
        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px;">
            <h3 style="margin: 0; font-size: 18px; font-weight: 800; color: var(--ink);">👤 유저 검색</h3>
            <button type="button" onclick="closeUserSearchModal()" style="border: 0; background: transparent; font-size: 20px; cursor: pointer; color: #94a3b8;">✕</button>
        </div>
        <form action="/mypage" method="GET" style="display: flex; gap: 8px;">
            <input type="text" name="user" id="userSearchInput" value="${userKeyword}" placeholder="아이디, 이름, 이메일로 검색" style="flex: 1; height: 48px; padding: 0 16px; border: 1px solid var(--line); border-radius: 12px; font-size: 14px; outline: none; background: #f8fafc;">
            <button type="submit" style="padding: 0 20px; height: 48px; background: var(--blue); color: #fff; border: 0; border-radius: 12px; font-weight: 700; font-size: 14px; cursor: pointer;">검색</button>
        </form>
    </div>
</div>
</body>
</html>
