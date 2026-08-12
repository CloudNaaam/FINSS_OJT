<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finlab - 게시글 상세</title>
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

        button, input, textarea { font: inherit; }
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

        .detail-area {
            padding: 28px 24px 110px;
        }

        .detail-header {
            padding-bottom: 18px;
            border-bottom: 1px solid var(--line);
        }

        .title-group {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 12px;
        }

        .post-id-tag {
            padding: 4px 8px;
            border-radius: 6px;
            background: var(--blue-soft);
            color: var(--blue);
            font-size: 12px;
            font-weight: 700;
        }

        .post-title {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            line-height: 1.35;
            letter-spacing: -.5px;
        }

        .post-meta {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #8a8f99;
            font-size: 13px;
        }

        .post-meta span + span::before {
            margin-right: 10px;
            content: "·";
        }

        .post-content {
            padding: 28px 0;
            color: #2d3139;
            font-size: 16px;
            line-height: 1.7;
            white-space: pre-wrap;
            min-height: 150px;
        }

        .file-box {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px 20px;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            background: #f8fafc;
            margin-top: 10px;
        }

        .file-box-info {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
        }

        .file-box-info span.icon {
            font-size: 20px;
        }

        .btn-download {
            padding: 8px 16px;
            border: 0;
            border-radius: 8px;
            background: var(--blue);
            color: #fff;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            display: inline-block;
        }

        .btn-download:hover {
            background: var(--blue-dark);
        }

        .action-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 28px;
            padding-top: 20px;
            border-top: 1px solid var(--line);
        }

        .btn-back {
            padding: 10px 18px;
            border: 1px solid #dcdfe4;
            border-radius: 10px;
            background: #fff;
            color: #555b64;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
        }

        .btn-back:hover {
            background: #f4f6f8;
        }

        .btn-group-right {
            display: flex;
            gap: 8px;
        }

        .btn-edit {
            padding: 10px 18px;
            border: 1px solid var(--blue);
            border-radius: 10px;
            background: #fff;
            color: var(--blue);
            font-size: 14px;
            font-weight: 700;
        }

        .btn-edit:hover {
            background: var(--blue-soft);
        }

        .btn-delete {
            padding: 10px 18px;
            border: 1px solid #ff4d4f;
            border-radius: 10px;
            background: #fff;
            color: #ff4d4f;
            font-size: 14px;
            font-weight: 700;
        }

        .btn-delete:hover {
            background: #fff1f0;
        }

        /* 댓글 영역 스타일 */
        .comment-section {
            margin-top: 36px;
            padding-top: 28px;
            border-top: 8px solid #f5f6f8;
        }

        .comment-head {
            font-size: 17px;
            font-weight: 800;
            margin: 0 0 16px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .comment-head span {
            color: var(--blue);
        }

        .comment-write-box {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-bottom: 24px;
        }

        .comment-input {
            width: 100%;
            min-height: 80px;
            padding: 12px 16px;
            border: 1px solid #dfe2e7;
            border-radius: 10px;
            background: #fff;
            color: var(--ink);
            font-size: 14px;
            outline: 0;
            resize: vertical;
        }

        .comment-input:focus {
            border-color: var(--blue);
        }

        .comment-submit-wrapper {
            display: flex;
            justify-content: flex-end;
        }

        .btn-comment-submit {
            padding: 10px 20px;
            border: 0;
            border-radius: 8px;
            background: var(--blue);
            color: #fff;
            font-size: 14px;
            font-weight: 700;
        }

        .btn-comment-submit:hover {
            background: var(--blue-dark);
        }

        .comment-list {
            margin: 0;
            padding: 0;
            list-style: none;
        }

        .comment-item {
            padding: 16px 0;
            border-bottom: 1px solid var(--line);
        }

        .comment-item-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 6px;
        }

        .comment-user {
            font-size: 13px;
            font-weight: 700;
            color: #333;
        }

        .comment-date {
            font-size: 11px;
            color: #999;
        }

        .comment-text {
            font-size: 14px;
            color: #444;
            line-height: 1.5;
            white-space: pre-wrap;
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
            .detail-area { padding: 24px 18px 100px; }
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
                <button class="icon-button" type="button" aria-label="검색">⌕</button>
                <a class="icon-button" href="/mypage" aria-label="마이페이지" style="text-decoration:none;">●</a>
            </div>
        </div>
        <nav class="service-nav" aria-label="서비스 메뉴">
            <a href="/">소셜 매치</a>
            <a class="active" href="/board">게시판</a>
            <a href="/notice">공지사항</a>
        </nav>
    </header>

    <main class="detail-area" id="detailContainer">
        <div style="padding: 40px 0; text-align: center; color: #888;">게시글을 불러오는 중...</div>
    </main>

    <nav class="bottom-nav" aria-label="하단 메뉴">
        <a href="/"><span>⚽</span>매치</a>
        <a class="active" href="/board"><span>📋</span>게시판</a>
        <a href="/notice"><span>📢</span>공지</a>
        <a href="/mypage"><span>●</span>MY</a>
    </nav>
</div>

<script>
    var currentComments = [];

    function getBoardIdFromPath() {
        var pathParts = window.location.pathname.split('/');
        return pathParts[pathParts.length - 1];
    }

    function fetchBoardDetail() {
        var boardId = getBoardIdFromPath();
        if (!boardId || isNaN(boardId)) {
            renderError('유효하지 않은 게시글 번호입니다.');
            return;
        }

        fetch('/api/board/' + boardId)
            .then(function(res) {
                if (!res.ok) {
                    throw new Error('게시글을 찾을 수 없습니다.');
                }
                return res.json();
            })
            .then(function(data) {
                renderDetail(boardId, data);
            })
            .catch(function(err) {
                console.error('게시글 상세 조회 실패:', err);
                renderError(err.message || '게시글 정보를 가져오지 못했습니다.');
            });
    }

    function renderDetail(boardId, data) {
        var container = document.getElementById('detailContainer');
        if (!container) return;

        var title = data.title || '제목 없음';
        var content = data.content || '';
        var writer = data.writer || '익명';
        var updatedAt = data.updated_at || '';
        var fileUuid = data.file_uuid || null;
        var originalFilename = data.original_filename || fileUuid;

        var fileBoxHtml = '';
        if (fileUuid && fileUuid.trim() !== '') {
            fileBoxHtml = 
                '<div class="file-box">' +
                    '<div class="file-box-info">' +
                        '<span class="icon">📎</span>' +
                        '<span>첨부파일: <strong>' + escapeHtml(originalFilename) + '</strong></span>' +
                    '</div>' +
                    '<a href="/api/file/download?file=' + encodeURIComponent(fileUuid) + '" class="btn-download" download>다운로드</a>' +
                '</div>';
        }

        var html = 
            '<div class="detail-header">' +
                '<div class="title-group">' +
                    '<span class="post-id-tag">#' + boardId + '</span>' +
                    '<h1 class="post-title">' + escapeHtml(title) + '</h1>' +
                '</div>' +
                '<div class="post-meta">' +
                    '<span>작성자: <strong>' + escapeHtml(writer) + '</strong></span>' +
                    '<span>' + updatedAt + '</span>' +
                '</div>' +
            '</div>' +

            '<div class="post-content">' + content + '</div>' +

            fileBoxHtml +

            '<div class="action-bar">' +
                '<a href="/board" class="btn-back">← 목록으로</a>' +
                '<div class="btn-group-right">' +
                    '<button type="button" class="btn-edit" onclick="handleEdit(' + boardId + ')">수정</button>' +
                    '<button type="button" class="btn-delete" onclick="handleDelete(' + boardId + ')">삭제</button>' +
                '</div>' +
            '</div>' +

            '<section class="comment-section">' +
                '<h2 class="comment-head">댓글 <span id="commentCount">0</span></h2>' +
                '<div class="comment-write-box">' +
                    '<textarea id="commentInput" class="comment-input" placeholder="따뜻한 댓글을 남겨보세요."></textarea>' +
                    '<div class="comment-submit-wrapper">' +
                        '<button type="button" class="btn-comment-submit" onclick="addComment()">댓글 등록</button>' +
                    '</div>' +
                '</div>' +
                '<ul class="comment-list" id="commentList">' +
                    '<li style="padding: 20px 0; text-align: center; color: #999; font-size: 14px;">등록된 댓글이 없습니다.</li>' +
                '</ul>' +
            '</section>';

        container.innerHTML = html;
        renderComments();
    }

    function handleEdit(boardId) {
        alert('게시글 수정 기능 준비 중입니다.');
    }

    function handleDelete(boardId) {
        if (!confirm('정말로 이 게시글을 삭제하시겠습니까?')) return;

        fetch('/api/board/delete', {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ board_id: boardId })
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data && data.success) {
                alert('게시글이 삭제되었습니다.');
                location.href = '/board';
            } else {
                alert('게시글 삭제 처리에 실패했습니다.');
            }
        })
        .catch(function(err) {
            console.error('게시글 삭제 오류:', err);
            alert('게시글 삭제 처리 중 오류가 발생했습니다.');
        });
    }

    function addComment() {
        var input = document.getElementById('commentInput');
        if (!input) return;
        var text = input.value.trim();
        if (!text) {
            alert('댓글 내용을 입력하세요.');
            return;
        }

        var now = new Date();
        var dateStr = now.getFullYear() + '-' +
            String(now.getMonth() + 1).padStart(2, '0') + '-' +
            String(now.getDate()).padStart(2, '0') + ' ' +
            String(now.getHours()).padStart(2, '0') + ':' +
            String(now.getMinutes()).padStart(2, '0');

        currentComments.unshift({
            user: '현재 사용자',
            text: text,
            date: dateStr
        });

        input.value = '';
        renderComments();
    }

    function renderComments() {
        var listContainer = document.getElementById('commentList');
        var countSpan = document.getElementById('commentCount');
        if (!listContainer) return;

        if (countSpan) {
            countSpan.innerText = currentComments.length;
        }

        if (currentComments.length === 0) {
            listContainer.innerHTML = '<li style="padding: 30px 0; text-align: center; color: #999; font-size: 14px;">등록된 댓글이 없습니다. 첫 댓글을 작성해보세요!</li>';
            return;
        }

        var html = '';
        currentComments.forEach(function(item) {
            html += 
                '<li class="comment-item">' +
                    '<div class="comment-item-top">' +
                        '<span class="comment-user">' + escapeHtml(item.user) + '</span>' +
                        '<span class="comment-date">' + item.date + '</span>' +
                    '</div>' +
                    '<div class="comment-text">' + escapeHtml(item.text) + '</div>' +
                '</li>';
        });
        listContainer.innerHTML = html;
    }

    function renderError(msg) {
        var container = document.getElementById('detailContainer');
        if (container) {
            container.innerHTML = 
                '<div style="padding: 60px 0; text-align: center; color: #e53e3e;">' +
                    '<p style="font-size: 18px; font-weight: 700; margin-bottom: 20px;">' + msg + '</p>' +
                    '<a href="/board" class="btn-back">← 목록으로 돌아가기</a>' +
                '</div>';
        }
    }

    function escapeHtml(str) {
        if (!str) return '';
        return str.replace(/&/g, '&amp;')
                  .replace(/</g, '&lt;')
                  .replace(/>/g, '&gt;')
                  .replace(/"/g, '&quot;')
                  .replace(/'/g, '&#039;');
    }

    document.addEventListener('DOMContentLoaded', fetchBoardDetail);
</script>
</body>
</html>
