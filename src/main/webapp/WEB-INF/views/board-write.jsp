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
            <div class="form-group">
                <label for="title">제목</label>
                <input type="text" id="title" class="form-control" placeholder="제목을 입력하세요" required>
            </div>

            <div class="form-group">
                <label for="content">내용</label>
                <textarea id="content" class="form-control" placeholder="내용을 작성하세요" required></textarea>
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
        var content = document.getElementById('content').value.trim();
        var fileInput = document.getElementById('fileInput');
        var file = fileInput.files[0];

        if (!title || !content) {
            alert('제목과 내용을 모두 입력해 주세요.');
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
                var payload = {
                    title: title,
                    content: content,
                    file: fileUuid
                };

                return fetch('/api/board/write', {
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
</script>
</body>
</html>
