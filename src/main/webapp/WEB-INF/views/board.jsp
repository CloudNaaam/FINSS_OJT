<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finlab - 게시판</title>
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

        .board-head {
            padding: 28px 24px 16px;
        }

        .board-head h1 {
            margin: 0 0 7px;
            font-size: 24px;
            letter-spacing: -1px;
        }

        .board-head p {
            margin: 0;
            color: var(--muted);
            font-size: 14px;
        }

        .toolbar {
            padding: 0 24px 16px;
            border-bottom: 8px solid #f5f6f8;
        }

        .search {
            display: flex;
            align-items: center;
            gap: 9px;
            padding: 12px 14px;
            border-radius: 10px;
            background: #f4f6f8;
        }

        .search input {
            width: 100%;
            border: 0;
            outline: 0;
            background: transparent;
            color: var(--ink);
            font-size: 14px;
        }

        .list-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 22px 24px 8px;
        }

        .list-head strong { font-size: 16px; }

        .sort {
            border: 0;
            background: transparent;
            color: var(--muted);
            font-size: 12px;
        }

        .post-list {
            margin: 0;
            padding: 0 24px 110px;
            list-style: none;
        }

        .post {
            padding: 18px 0;
            border-bottom: 1px solid var(--line);
        }

        .post a {
            color: inherit;
            text-decoration: none;
        }

        .post-top {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 7px;
        }

        .post-category {
            flex: 0 0 auto;
            padding: 3px 7px;
            border-radius: 5px;
            background: var(--blue-soft);
            color: var(--blue);
            font-size: 10px;
            font-weight: 700;
        }

        .post-title {
            margin: 0;
            overflow: hidden;
            font-size: 15px;
            font-weight: 600;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .post-info {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #989ca4;
            font-size: 11px;
        }

        .post-info span + span::before {
            margin-right: 8px;
            content: "·";
        }

        .write-button {
            position: fixed;
            z-index: 25;
            right: max(calc((100vw - 768px) / 2 + 24px), 24px);
            bottom: 28px;
            padding: 13px 19px;
            border: 0;
            border-radius: 24px;
            background: var(--blue);
            box-shadow: 0 8px 20px rgba(21, 112, 255, .3);
            color: #fff;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
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
            .board-head { padding: 24px 18px 14px; }
            .toolbar, .post-list { padding-right: 18px; padding-left: 18px; }
            .list-head { padding-right: 18px; padding-left: 18px; }
            .bottom-nav { display: flex; }
            .write-button {
                right: 18px;
                bottom: 86px;
            }
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

    <main>
        <section class="board-head">
            <h1>게시판</h1>
        </section>

        <section class="toolbar" style="display: flex; gap: 8px; align-items: center;">
            <select id="searchType" style="padding: 0 12px; height: 48px; border: 1px solid var(--line); border-radius: 12px; background: #f8fafc; font-weight: 600; color: #334155; cursor: pointer; font-size: 14px; outline: none;">
                <option value="title" selected>제목</option>
                <option value="writer">작성자</option>
                <option value="contents">내용</option>
            </select>
            <label class="search" style="flex: 1;">
                <span>⌕</span>
                <input id="postSearch" type="search" placeholder="검색어를 입력해보세요">
            </label>
        </section>

        <section>
            <div class="list-head">
                <strong>전체 게시글</strong>
                <select id="sortType" style="border: 0; background: transparent; font-size: 13px; font-weight: 700; color: #475569; cursor: pointer; outline: none;">
                    <option value="DESC" selected>최신순 ▾</option>
                    <option value="ASC">오래된순 ▾</option>
                </select>
            </div>

            <ul class="post-list" id="postList">
                <!-- 동적 게시글 데이터가 삽입됩니다 -->
            </ul>
        </section>
    </main>

    <button class="write-button" type="button" onclick="location.href='/board/write'">＋ 글쓰기</button>

    <nav class="bottom-nav" aria-label="하단 메뉴">
        <a href="/"><span>⚽</span>매치</a>
        <a class="active" href="/board"><span>📋</span>게시판</a>
        <a href="/notice"><span>📢</span>공지사항</a>
        <a href="/mypage"><span>👤</span>마이페이지</a>
    </nav>
</div>

<script>
    var allPostsData = [];

    function fetchBoardPosts() {
        var searchTypeSelect = document.getElementById('searchType');
        var searchInput = document.getElementById('postSearch');
        var sortSelect = document.getElementById('sortType');

        var type = searchTypeSelect ? searchTypeSelect.value : 'title';
        var keyword = searchInput ? searchInput.value.trim() : '';
        var sortVal = sortSelect ? sortSelect.value : 'DESC';

        var url = '/api/board?sort=' + encodeURIComponent(sortVal);
        if (keyword) {
            if (type === 'writer') {
                url += '&writer=' + encodeURIComponent(keyword);
            } else if (type === 'contents' || type === 'content') {
                url += '&contents=' + encodeURIComponent(keyword);
            } else {
                url += '&title=' + encodeURIComponent(keyword);
            }
        }

        fetch(url)
            .then(function(res) { return res.json(); })
            .then(function(data) {
                allPostsData = data || [];
                renderPosts(allPostsData);
            })
            .catch(function(err) {
                console.error('게시글 목록 로드 실패:', err);
                var container = document.getElementById('postList');
                if (container) {
                    container.innerHTML = '<li style="padding: 30px 0; text-align: center; color: #888;">게시글을 불러오는 중 오류가 발생했습니다.</li>';
                }
            });
    }

    function renderPosts(posts) {
        var container = document.getElementById('postList');
        if (!container) return;

        if (!posts || posts.length === 0) {
            container.innerHTML = '<li style="padding: 40px 0; text-align: center; color: #888;">검색 조건에 맞는 게시글이 없습니다.</li>';
            return;
        }

        var html = '';
        posts.forEach(function(post) {
            var dateStr = post.created_at ? post.created_at.substring(0, 10) : '';
            var boardId = post.board_id || post.boardId || '';
            var fileClip = (post.file_uuid && post.file_uuid.trim() !== '') ? ' <span style="font-size: 13px; margin-left: 4px; color: #666;" title="첨부파일 있음">📎</span>' : '';
            var writerName = post.writer || ('사용자#' + (post.writer_id || 1));

            html += '<li class="post">' +
                        '<a href="/board/' + boardId + '">' +
                            '<div class="post-top">' +
                                '<span class="post-category">#' + boardId + '</span>' +
                                '<h2 class="post-title">' + (post.title || '제목 없음') + fileClip + '</h2>' +
                            '</div>' +
                            '<div class="post-info">' +
                                '<span>' + writerName + '</span>' +
                                '<span>' + dateStr + '</span>' +
                            '</div>' +
                        '</a>' +
                    '</li>';
        });
        container.innerHTML = html;
    }


    document.addEventListener('DOMContentLoaded', function() {
        fetchBoardPosts();

        var searchInput = document.getElementById('postSearch');
        var searchTypeSelect = document.getElementById('searchType');
        var sortSelect = document.getElementById('sortType');

        var searchTimer = null;
        if (searchInput) {
            searchInput.addEventListener('input', function() {
                clearTimeout(searchTimer);
                searchTimer = setTimeout(fetchBoardPosts, 300);
            });
        }

        if (searchTypeSelect) {
            searchTypeSelect.addEventListener('change', fetchBoardPosts);
        }

        if (sortSelect) {
            sortSelect.addEventListener('change', fetchBoardPosts);
        }
    });
</script>
</body>
</html>
