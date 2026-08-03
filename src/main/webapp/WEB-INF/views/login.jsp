<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finlab - 로그인</title>
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
            --danger: #e5485d;
        }

        body {
            margin: 0;
            background: var(--bg);
            color: var(--ink);
            font-family: "Noto Sans KR", sans-serif;
            word-break: keep-all;
        }

        button, input { font: inherit; }
        button, label { cursor: pointer; }

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

        .back {
            display: grid;
            width: 40px;
            height: 40px;
            place-items: center;
            border-radius: 50%;
            color: var(--ink);
            font-size: 24px;
            text-decoration: none;
        }

        .back:hover { background: #f4f6f8; }

        .content {
            width: min(100%, 480px);
            margin: auto;
            padding: 48px 24px 70px;
        }

        .intro { margin-bottom: 34px; }

        .intro h1 {
            margin: 0 0 8px;
            font-size: 26px;
            font-weight: 800;
            line-height: 1.35;
            letter-spacing: -1px;
        }

        .intro p {
            margin: 0;
            color: var(--muted);
            font-size: 14px;
            line-height: 1.6;
        }

        .field { margin-bottom: 20px; }

        .field-label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 700;
            color: #333;
        }

        .input {
            width: 100%;
            height: 50px;
            padding: 0 16px;
            border: 1px solid #dfe2e7;
            border-radius: 10px;
            outline: 0;
            background: #fff;
            color: var(--ink);
            font-size: 15px;
            transition: border-color .2s, box-shadow .2s;
        }

        .input:focus {
            border-color: var(--blue);
            box-shadow: 0 0 0 3px rgba(21, 112, 255, .12);
        }

        .input::placeholder { color: #b0b4bb; }

        .password-wrap { position: relative; }
        .password-wrap .input { padding-right: 56px; }

        .password-toggle {
            position: absolute;
            top: 0;
            right: 4px;
            width: 48px;
            height: 50px;
            border: 0;
            background: transparent;
            color: #8e939c;
            font-size: 12px;
            font-weight: 600;
        }

        .login-button {
            width: 100%;
            height: 54px;
            margin-top: 14px;
            border: 0;
            border-radius: 12px;
            background: var(--blue);
            color: #fff;
            font-size: 16px;
            font-weight: 800;
            box-shadow: 0 6px 16px rgba(21, 112, 255, .25);
            transition: background .2s;
        }

        .login-button:hover { background: var(--blue-dark); }

        .bottom-links {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            margin-top: 24px;
            font-size: 13px;
        }

        .bottom-links a, .bottom-links button {
            color: #666c77;
            font-weight: 600;
            text-decoration: none;
            border: 0;
            background: transparent;
            padding: 0;
            font-size: 13px;
        }

        .bottom-links a:hover, .bottom-links button:hover {
            color: var(--blue);
        }

        .bottom-links .dot {
            color: #d0d4dc;
            font-size: 12px;
        }

        .error-message {
            display: none;
            margin: -8px 0 16px;
            color: var(--danger);
            font-size: 12px;
        }

        .error-message.show { display: block; }

        @media (max-width: 600px) {
            body { background: #fff; }
            .page { box-shadow: none; }
            .header { height: 58px; padding: 0 14px; }
            .content { padding: 38px 18px 60px; }
            .intro h1 { font-size: 23px; }
        }
    </style>
</head>
<body>
<div class="page">
    <header class="header">
        <a class="back" href="/" aria-label="메인으로 이동">←</a>
        <a class="brand" href="/">Finlab</a>
    </header>

    <main class="content">
        <section class="intro">
            <h1>Finlab 로그인</h1>
            <p>서비스 이용을 위해 아이디와 비밀번호를 입력해 주세요.</p>
        </section>

        <form id="loginForm" novalidate>
            <!-- 1. 아이디 (username) -->
            <div class="field">
                <label class="field-label" for="username">아이디</label>
                <input class="input" id="username" name="username" type="text"
                       placeholder="아이디를 입력해 주세요"
                       autocomplete="username" required>
            </div>

            <!-- 2. 비밀번호 (password) -->
            <div class="field">
                <label class="field-label" for="password">비밀번호</label>
                <div class="password-wrap">
                    <input class="input" id="password" name="password" type="password"
                           placeholder="비밀번호를 입력해 주세요"
                           autocomplete="current-password" required>
                    <button class="password-toggle" id="passwordToggle" type="button">보기</button>
                </div>
            </div>

            <p class="error-message" id="errorMessage">아이디와 비밀번호를 확인해 주세요.</p>

            <button class="login-button" type="submit" id="submitBtn">로그인</button>

            <!-- 하단 링크: 비밀번호 찾기 & 회원가입 -->
            <div class="bottom-links">
                <a href="/findpw">비밀번호 찾기</a>
                <span class="dot">·</span>
                <a href="/register">회원가입</a>
            </div>
        </form>
    </main>
</div>

<script>
    const form = document.getElementById("loginForm");
    const username = document.getElementById("username");
    const password = document.getElementById("password");
    const passwordToggle = document.getElementById("passwordToggle");
    const errorMessage = document.getElementById("errorMessage");

    // 비밀번호 보기 / 숨김 토글
    passwordToggle.addEventListener("click", function () {
        const visible = password.type === "text";
        password.type = visible ? "password" : "text";
        passwordToggle.textContent = visible ? "보기" : "숨김";
    });

    [username, password].forEach(function (input) {
        input.addEventListener("input", function () {
            errorMessage.classList.remove("show");
        });
    });

    // 로그인 폼 제출 이벤트
    form.addEventListener("submit", function (event) {
        event.preventDefault();

        const userVal = username.value.trim();
        const passVal = password.value.trim();

        if (!userVal) {
            alert("아이디를 입력해 주세요.");
            username.focus();
            return;
        }

        if (!passVal) {
            alert("비밀번호를 입력해 주세요.");
            password.focus();
            return;
        }

        alert("로그인 입력 양식이 올바르게 제출되었습니다. (로그인 API 연결 예정)");
    });
</script>
</body>
</html>
