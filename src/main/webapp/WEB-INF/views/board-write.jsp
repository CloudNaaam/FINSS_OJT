<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finlab - 게시글 작성</title>
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

        .form-area {
            padding: 28px 24px 110px;
        }

        .form-head {
            margin-bottom: 24px;
        }

        .form-head h1 {
            margin: 0 0 7px;
            font-size: 24px;
            letter-spacing: -1px;
        }

        .form-head p {
            margin: 0;
            color: var(--muted);
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 700;
            color: #333;
        }

        .form-control {
            width: 100%;
            padding: 13px 16px;
            border: 1px solid #dfe2e7;
            border-radius: 10px;
            background: #fff;
            color: var(--ink);
            font-size: 15px;
            outline: 0;
            transition: border-color 0.2s;
        }

        .form-control:focus {
            border-color: var(--blue);
        }

        textarea.form-control {
            min-height: 200px;
            resize: vertical;
            line-height: 1.5;
        }

        .file-upload-box {
            position: relative;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 16px;
            border: 1px dashed #cbd0d8;
            border-radius: 10px;
            background: #f8fafc;
            cursor: pointer;
        }

        .file-upload-box:hover {
            border-color: var(--blue);
            background: var(--blue-soft);
        }

        .file-info {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #64748b;
            font-size: 14px;
        }

        .file-info span.icon {
            font-size: 18px;
        }

        .file-name {
            font-weight: 600;
            color: var(--ink);
            word-break: break-all;
        }

        .file-input {
            display: none;
        }

        .btn-submit {
            width: 100%;
            padding: 15px;
            border: 0;
            border-radius: 12px;
            background: var(--blue);
            color: #fff;
            font-size: 16px;
            font-weight: 700;
            box-shadow: 0 6px 16px rgba(21, 112, 255, .25);
            margin-top: 10px;
        }

        .btn-submit:hover {
            background: var(--blue-dark);
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
            .form-area { padding: 24px 18px 100px; }
            .bottom-nav { display: flex; }
        }

        /* 💡 URL OG Link Preview Card Styles */
        .og-preview-card {
            display: flex;
            gap: 14px;
            padding: 14px;
            margin-top: 12px;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            background: #f8fafc;
            position: relative;
            text-decoration: none;
            color: inherit;
            box-shadow: 0 2px 8px rgba(0,0,0,0.03);
            transition: all 0.2s ease;
        }
        .og-preview-card:hover {
            background: #f1f5f9;
            border-color: var(--blue);
        }
        .og-preview-img {
            width: 90px;
            height: 90px;
            object-fit: cover;
            border-radius: 8px;
            flex-shrink: 0;
            background: #e2e8f0;
        }
        .og-preview-info {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            overflow: hidden;
        }
        .og-preview-site {
            font-size: 11px;
            font-weight: 700;
            color: var(--blue);
            margin-bottom: 4px;
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .og-preview-title {
            font-size: 14px;
            font-weight: 700;
            color: var(--ink);
            margin: 0 0 4px 0;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .og-preview-desc {
            font-size: 12px;
            color: #64748b;
            margin: 0;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .og-close-btn {
            position: absolute;
            top: 8px;
            right: 8px;
            width: 22px;
            height: 22px;
            border: 0;
            border-radius: 50%;
            background: rgba(0,0,0,0.06);
            color: #64748b;
            font-size: 12px;
            line-height: 1;
            cursor: pointer;
            display: grid;
            place-items: center;
        }
        .og-close-btn:hover {
            background: #ef4444;
            color: #fff;
        }

        /* 💡 카카오/티스토리 스타일 OpenGraph figure 카드 CSS */
        figure[data-ke-type="opengraph"] {
            margin: 14px 0;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            overflow: hidden;
            background: #fff;
            text-align: left;
            display: block;
            position: relative;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        figure[data-ke-type="opengraph"]:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(0,0,0,0.08);
        }
        figure[data-ke-type="opengraph"] a {
            display: flex;
            text-decoration: none;
            color: inherit;
            min-height: 96px;
        }
        figure[data-ke-type="opengraph"] .og-image {
            width: 128px;
            min-width: 128px;
            background-size: cover;
            background-position: center;
            background-color: #f1f5f9;
            flex-shrink: 0;
        }
        figure[data-ke-type="opengraph"] .og-text {
            padding: 12px 16px;
            flex: 1;
            min-width: 0;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        figure[data-ke-type="opengraph"] .og-title {
            font-size: 14px;
            font-weight: 700;
            color: #1e293b;
            margin: 0 0 4px 0;
            line-height: 1.35;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        figure[data-ke-type="opengraph"] .og-desc {
            font-size: 12px;
            color: #64748b;
            margin: 0 0 6px 0;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        figure[data-ke-type="opengraph"] .og-host {
            font-size: 11px;
            color: #94a3b8;
            margin: 0;
            font-weight: 600;
        }

        /* 💡 리치 텍스트 에디터 스타일 */
        .rich-editor {
            min-height: 240px;
            max-height: 500px;
            overflow-y: auto;
            background: #fff;
            padding: 14px 16px;
            line-height: 1.6;
            outline: none;
            cursor: text;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
        }
        .rich-editor:focus {
            border-color: var(--blue);
            box-shadow: 0 0 0 3px rgba(21,112,255,0.1);
        }
        .rich-editor[contenteditable="true"]:empty:before {
            content: attr(placeholder);
            color: #94a3b8;
            pointer-events: none;
            display: block;
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

    <main class="form-area">
        <div class="form-head">
            <h1>게시글 작성</h1>
            <p>자유롭게 게시글을 작성해보세요.</p>
        </div>

        <form id="writeForm">
            <!-- 💡 세션 CSRF 토큰 직접 주입 -->
            <input type="hidden" name="csrfToken" id="csrfToken" value="${sessionScope.CSRF_TOKEN}">

            <div class="form-group">
                <label for="title">제목</label>
                <input type="text" id="title" class="form-control" placeholder="제목을 입력하세요" required>
            </div>

            <div class="form-group">
                <label for="content">내용</label>
                <!-- 💡 실시간 카드 렌더링을 위한 contenteditable 리치 에디터 -->
                <div id="content" class="rich-editor" contenteditable="true" placeholder="내용을 작성해보세요..."></div>
                <div id="ogCardContainer"></div>
            </div>

            <div class="form-group">
                <label>첨부파일 (선택 · 1개만 가능)</label>
                <label class="file-upload-box" for="fileInput">
                    <div class="file-info">
                        <span class="icon">📎</span>
                        <span id="fileNameText" class="file-name">이미지 및 문서 파일 선택 (.png, .jpg, .pdf, .docx 등)</span>
                    </div>
                </label>
                <input type="file" id="fileInput" class="file-input" accept="image/*,.pdf,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.txt">
            </div>

            <button type="submit" class="btn-submit" id="submitBtn">게시글 등록하기</button>
        </form>
    </main>

    <nav class="bottom-nav" aria-label="하단 메뉴">
        <a href="/"><span>⚽</span>매치</a>
        <a class="active" href="/board"><span>📋</span>게시판</a>
        <a href="/notice"><span>📢</span>공지</a>
        <a href="/mypage"><span>●</span>MY</a>
    </nav>
</div>

<script>
    document.getElementById('fileInput').addEventListener('change', function(e) {
        var file = e.target.files[0];
        if (file) {
            document.getElementById('fileNameText').innerText = '✓ ' + file.name;
        } else {
            document.getElementById('fileNameText').innerText = '이미지 및 문서 파일 선택 (.png, .jpg, .pdf, .docx 등)';
        }
    });

    document.getElementById('writeForm').addEventListener('submit', function(e) {
        e.preventDefault();

        var title = document.getElementById('title').value.trim();
        var contentElem = document.getElementById('content');
        var content = contentElem ? contentElem.innerHTML.trim() : '';
        var fileInput = document.getElementById('fileInput');
        var file = fileInput.files[0];

        if (!title) {
            alert('제목을 입력해주세요.');
            return;
        }
        if (!content || content === '<br>') {
            alert('내용을 입력해주세요.');
            return;
        }

        var submitBtn = document.getElementById('submitBtn');
        submitBtn.disabled = true;
        submitBtn.innerText = '등록 중...';

        // 1단계: 파일이 선택되어 있으면 /api/file/upload 먼저 실행
        var uploadPromise = Promise.resolve(null);

        if (file) {
            submitBtn.innerText = '파일 업로드 중...';
            var formData = new FormData();
            formData.append('file', file);

            uploadPromise = fetch('/api/file/upload', {
                method: 'POST',
                body: formData
            })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                if (data && (data.file_uuid || data.uuid)) {
                    return data.file_uuid || data.uuid;
                } else {
                    throw new Error('파일 업로드에 실패했습니다.');
                }
            });
        }

        // 2단계: 파일 업로드 완료 후 /api/board/write 게시글 등록 수행
        uploadPromise
            .then(function(fileUuid) {
                submitBtn.innerText = '게시글 저장 중...';

                var finalContent = content;

                var csrfVal = document.getElementById('csrfToken') ? document.getElementById('csrfToken').value : '';
                var payload = {
                    title: title,
                    content: finalContent,
                    file: fileUuid,
                    csrfToken: csrfVal
                };

                var writeUrl = '/api/board/write';
                if (csrfVal) {
                    writeUrl += '?csrfToken=' + encodeURIComponent(csrfVal);
                }

                return fetch(writeUrl, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(payload)
                });
            })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                if (data && data.success) {
                    alert('게시글이 성공적으로 등록되었습니다.');
                    location.href = '/board';
                } else {
                    alert('게시글 등록에 실패했습니다.');
                    submitBtn.disabled = false;
                    submitBtn.innerText = '게시글 등록하기';
                }
            })
            .catch(function(err) {
                console.error('등록 처리 중 오류:', err);
                alert(err.message || '게시글 등록 중 오류가 발생했습니다.');
                submitBtn.disabled = false;
                submitBtn.innerText = '게시글 등록하기';
            });
    });



    // 💡 실시간 URL 감지 및 /api/scrap/og 스크랩 링크 카드 미리보기 기능
    var currentOgData = null;
    var scrapTimer = null;
    var lastScrappedUrl = '';

    var contentInput = document.getElementById('content');
    if (contentInput) {
        contentInput.addEventListener('keyup', function() {
            clearTimeout(scrapTimer);
            scrapTimer = setTimeout(detectAndScrapUrl, 300);
        });
    }

    function detectAndScrapUrl() {
        var text = contentInput.innerText || contentInput.textContent || '';
        // 💡 URL 입력 후 엔터(\n|\r)나 공백이 뒤따라올 때만 URL 감지
        var urlRegex = /(https?:\/\/[^\s\r\n]+)(?:[\r\n\s]+)/i;
        var match = text.match(urlRegex);

        if (!match) return;

        var detectedUrl = match[1].trim();
        if (detectedUrl === lastScrappedUrl) return;

        lastScrappedUrl = detectedUrl;
        var container = document.getElementById('ogCardContainer');

        // 💡 HTML 전문 반환 API (/api/scrap) 호출
        fetch('/api/scrap?url=' + encodeURIComponent(detectedUrl))
            .then(function(res) { return res.text(); })
            .then(function(htmlText) {
                if (!htmlText || htmlText.startsWith('Error:')) {
                    if (container) container.innerHTML = '';
                    return;
                }

                // 💡 수신한 HTML 전문 텍스트를 자바스크립트 DOMParser로 직접 파싱
                var parser = new DOMParser();
                var doc = parser.parseFromString(htmlText, 'text/html');

                // 1. 도메인 추출
                var domain = '';
                try {
                    domain = new URL(detectedUrl).hostname;
                } catch(e) { domain = detectedUrl; }

                // 2. 제목 (og:title -> <title> 태그)
                var titleMeta = doc.querySelector('meta[property="og:title"]') || doc.querySelector('meta[name="og:title"]');
                var title = titleMeta ? titleMeta.getAttribute('content') : (doc.title || domain);

                // 3. 설명 (og:description -> <meta name="description">)
                var descMeta = doc.querySelector('meta[property="og:description"]') || doc.querySelector('meta[name="description"]');
                var description = descMeta ? descMeta.getAttribute('content') : '';

                // 4. 썸네일 이미지 (og:image)
                var imgMeta = doc.querySelector('meta[property="og:image"]') || doc.querySelector('meta[name="og:image"]');
                var image = imgMeta ? imgMeta.getAttribute('content') : '';

                // 상대 경로 이미지 주소를 절대 경로로 전환
                if (image && !image.startsWith('http://') && !image.startsWith('https://')) {
                    try {
                        var baseUrl = new URL(detectedUrl);
                        if (image.startsWith('/')) {
                            image = baseUrl.origin + image;
                        } else {
                            image = baseUrl.origin + '/' + image;
                        }
                    } catch(e) {}
                }

                // 5. 사이트 이름 (og:site_name -> domain)
                var siteMeta = doc.querySelector('meta[property="og:site_name"]');
                var siteName = siteMeta ? siteMeta.getAttribute('content') : domain;

                var ogData = {
                    url: detectedUrl,
                    domain: domain,
                    title: title ? title.trim() : domain,
                    description: description ? description.trim() : '',
                    image: image ? image.trim() : '',
                    site_name: siteName ? siteName.trim() : domain
                };

                currentOgData = ogData;
                insertOgCardDirectlyIntoContent(ogData);
                renderOgCard(ogData);
            })
            .catch(function(err) {
                console.error('HTML 스크랩 및 메타데이터 파싱 실패:', err);
                if (container) container.innerHTML = '';
            });
    }

    // 💡 작성 중인 리치 에디터(contenteditable) 내부의 URL 바로 아래에 시각적 <figure> 카드 UI 노드를 즉시 삽입하는 함수
    function insertOgCardDirectlyIntoContent(og) {
        if (!contentInput) return;

        // 이미 생성된 동종 링크 카드가 존재하는지 확인
        if (contentInput.querySelector('figure[data-og-source-url="' + CSS.escape(og.url) + '"]') ||
            contentInput.innerHTML.indexOf(og.url) === -1) {
            return;
        }

        var figId = "og_" + new Date().getTime();
        var figureCardHtml = '<figure contenteditable="false" id="' + figId + '" data-ke-type="opengraph" data-ke-align="alignCenter" data-og-type="website" data-og-title="' + escapeHtml(og.title) + '" data-og-description="' + escapeHtml(og.description) + '" data-og-host="' + escapeHtml(og.domain) + '" data-og-source-url="' + escapeHtml(og.url) + '" data-og-url="' + escapeHtml(og.url) + '" data-og-image="' + escapeHtml(og.image) + '">' +
                '<a href="' + escapeHtml(og.url) + '" target="_blank" data-source-url="' + escapeHtml(og.url) + '">' +
                    '<div class="og-image" style="background-image:url(\'' + escapeHtml(og.image) + '\')"></div>' +
                    '<div class="og-text">' +
                        '<p class="og-title">' + escapeHtml(og.title || og.domain) + '</p>' +
                        '<p class="og-desc">' + escapeHtml(og.description) + '</p>' +
                        '<p class="og-host">' + escapeHtml(og.domain) + '</p>' +
                    '</div>' +
                '</a>' +
            '</figure><div><br></div>';

        // HTML 에디터 내부에서 URL 위치 바로 뒤에 시각적 카드를 삽입
        var currentHtml = contentInput.innerHTML;
        if (currentHtml.indexOf(og.url) !== -1) {
            contentInput.innerHTML = currentHtml.replace(og.url, og.url + '<br>' + figureCardHtml);
        }
    }

    function renderOgCard(og) {
        var container = document.getElementById('ogCardContainer');
        if (!container) return;

        var figId = "og_" + new Date().getTime();
        var cardHtml = 
            '<div style="position:relative;">' +
                '<button type="button" class="og-close-btn" onclick="removeOgCard(event)" title="링크 카드 닫기" style="z-index:10; top:4px; right:4px;">✕</button>' +
                '<figure contenteditable="false" id="' + figId + '" data-ke-type="opengraph" data-ke-align="alignCenter" data-og-type="website" data-og-title="' + escapeHtml(og.title) + '" data-og-description="' + escapeHtml(og.description) + '" data-og-host="' + escapeHtml(og.domain) + '" data-og-source-url="' + escapeHtml(og.url) + '" data-og-url="' + escapeHtml(og.url) + '" data-og-image="' + escapeHtml(og.image) + '">' +
                    '<a href="' + escapeHtml(og.url) + '" target="_blank" data-source-url="' + escapeHtml(og.url) + '">' +
                        '<div class="og-image" style="background-image:url(\'' + escapeHtml(og.image) + '\')"></div>' +
                        '<div class="og-text">' +
                            '<p class="og-title">' + escapeHtml(og.title || og.domain) + '</p>' +
                            '<p class="og-desc">' + escapeHtml(og.description) + '</p>' +
                            '<p class="og-host">' + escapeHtml(og.domain) + '</p>' +
                        '</div>' +
                    '</a>' +
                '</figure>' +
            '</div>';

        container.innerHTML = cardHtml;
    }

    function removeOgCard(e) {
        if (e) e.preventDefault();
        currentOgData = null;
        var container = document.getElementById('ogCardContainer');
        if (container) container.innerHTML = '';
    }

    function escapeHtml(str) {
        if (!str) return '';
        return String(str)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }
</script>
</body>
</html>
