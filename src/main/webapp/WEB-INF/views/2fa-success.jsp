<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finlab - 2단계 인증 완료</title>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap");

        * { box-sizing: border-box; }

        :root {
            --blue: #1570ff;
            --blue-dark: #0758d7;
            --blue-soft: #eaf3ff;
            --green: #10b981;
            --green-soft: #ecfdf5;
            --ink: #22252b;
            --muted: #80858f;
            --line: #eceef2;
            --bg: #f3f5f7;
        }

        body {
            margin: 0;
            background: var(--bg);
            color: var(--ink);
            font-family: Noto Sans KR, sans-serif;
            word-break: keep-all;
        }

        button, input { font: inherit; }
        button, a { cursor: pointer; }

        .page {
            width: min(100%, 768px);
            min-height: 100vh;
            margin: 0 auto;
            background: #fff;
            box-shadow: 0 0 30px rgba(20, 26, 36, .05);
            display: flex;
            flex-direction: column;
        }

        .header {
            position: sticky;
            z-index: 20;
            top: 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 64px;
            padding: 0 18px;
            background: rgba(255, 255, 255, .96);
            border-bottom: 1px solid var(--line);
            backdrop-filter: blur(10px);
        }

        .brand {
            color: var(--blue);
            font-size: 24px;
            font-weight: 900;
            letter-spacing: -1.5px;
            text-decoration: none;
        }

        .content {
            width: min(100%, 480px);
            margin: auto;
            padding: 48px 24px 70px;
            text-align: center;
        }

        .success-icon-wrap {
            width: 84px;
            height: 84px;
            margin: 0 auto 24px;
            border-radius: 50%;
            background: var(--green-soft);
            display: grid;
            place-items: center;
            font-size: 42px;
            box-shadow: 0 8px 20px rgba(16, 185, 129, .15);
            animation: popIn .4s cubic-bezier(.175, .885, .32, 1.275);
        }

        @keyframes popIn {
            0% { transform: scale(0.5); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }

        .intro h1 {
            margin: 0 0 10px;
            font-size: 26px;
            font-weight: 800;
            letter-spacing: -1px;
            color: var(--ink);
        }

        .intro p {
            margin: 0 0 28px;
            color: var(--muted);
            font-size: 15px;
            line-height: 1.6;
        }

        .user-badge {
            display: inline-block;
            padding: 8px 16px;
            background: var(--blue-soft);
            color: var(--blue-dark);
            border-radius: 20px;
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 24px;
        }

        .action-button {
            display: block;
            width: 100%;
            height: 54px;
            line-height: 54px;
            border: 0;
            border-radius: 12px;
            background: var(--blue);
            color: #fff;
            font-size: 16px;
            font-weight: 800;
            text-decoration: none;
            box-shadow: 0 6px 16px rgba(21, 112, 255, .25);
            transition: background .2s;
        }

        .action-button:hover { background: var(--blue-dark); }

        .countdown-text {
            margin-top: 18px;
            font-size: 13px;
            color: #94a3b8;
        }
    </style>
</head>
<body>
<div class="page">
    <header class="header">
        <div></div>
        <a class="brand" href="/">Finlab</a>
        <div></div>
    </header>

    <main class="content">
        <div class="success-icon-wrap">✅</div>

        <section class="intro">
            <h1>2단계 인증 완료</h1>
            <p>본인 확인 및 2단계 인증이 성공적으로 완료되었습니다.<br/>안전하게 로그인 세션이 생성되었습니다.</p>
            
            <% if (request.getAttribute("user") != null) { %>
                <div class="user-badge">
                    환영합니다, <strong><%= ((coms.fins.ojt.domain.UserVO) request.getAttribute("user")).getUsername() %></strong> 님!
                </div>
            <% } %>
        </section>

        <a class="action-button" href="/mypage">마이페이지로 이동하기</a>
        <p class="countdown-text"><span id="countdown">2</span>초 후 마이페이지로 자동 이동합니다...</p>
    </main>
</div>

<script>
    var seconds = 2;
    var countEl = document.getElementById("countdown");
    var timer = setInterval(function() {
        seconds--;
        if (countEl) countEl.innerText = seconds;
        if (seconds <= 0) {
            clearInterval(timer);
            location.href = "/mypage";
        }
    }, 1000);
</script>
</body>
</html>
