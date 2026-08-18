<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finlab - 비밀번호 찾기</title>
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
            --success: #11a767;
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

        .input-row {
            display: flex;
            gap: 8px;
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

        .side-button {
            width: 110px;
            flex: 0 0 auto;
            border: 1px solid var(--blue);
            border-radius: 10px;
            background: #fff;
            color: var(--blue);
            font-size: 13px;
            font-weight: 700;
            transition: background .2s;
        }

        .side-button:hover {
            background: var(--blue-soft);
        }

        .help {
            min-height: 18px;
            margin: 6px 0 0;
            color: #8a8f99;
            font-size: 12px;
        }

        .help.error { color: var(--danger); }
        .help.success { color: var(--success); }

        .submit {
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

        .submit:hover { background: var(--blue-dark); }

        .notice {
            display: flex;
            gap: 10px;
            margin-top: 24px;
            padding: 14px 16px;
            border-radius: 10px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            color: #64748b;
            font-size: 12px;
            line-height: 1.6;
        }

        .notice span:first-child {
            color: var(--blue);
            font-weight: 800;
        }

        .login-link {
            margin-top: 24px;
            text-align: center;
            font-size: 13px;
        }

        .login-link a {
            color: var(--blue);
            font-weight: 700;
            text-decoration: none;
        }

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
        <a class="back" href="/login" aria-label="로그인으로 이동">←</a>
        <a class="brand" href="/">Finlab</a>
    </header>

    <main class="content">
        <section class="intro">
            <h1>비밀번호 찾기</h1>
            <p>가입 시 등록한 아이디와 이메일을 입력 후 [코드 전송] 버튼을 눌러주세요.</p>
        </section>

        <form id="findPwForm" novalidate>
            <input type="hidden" name="csrfToken" id="csrfToken" value="${sessionScope.CSRF_TOKEN}">
            <!-- 1. 아이디 (username) -->
            <div class="field">
                <label class="field-label" for="username">아이디</label>
                <input class="input" id="username" name="username" type="text"
                       placeholder="가입한 아이디 입력" autocomplete="username" required>
            </div>

            <!-- 2. 이메일 입력 & 코드 전송 버튼 -->
            <div class="field">
                <label class="field-label" for="email">가입 이메일</label>
                <div class="input-row">
                    <input class="input" id="email" name="email" type="email"
                           placeholder="example@email.com" autocomplete="email" required>
                    <button class="side-button" id="btnSendCode" type="button">코드 전송</button>
                </div>
                <p class="help" id="emailHelp">아이디와 일치하는 이메일 주소를 입력해 주세요.</p>
            </div>

            <!-- 3. 인증 코드 입력 폼 -->
            <div class="field">
                <label class="field-label" for="authCode">인증 코드</label>
                <input class="input" id="authCode" name="authCode" type="text"
                       placeholder="이메일로 발송된 6자리 코드 입력" required>
                <p class="help" id="codeHelp"></p>
            </div>

            <!-- 4. 코드 확인하기 버튼 -->
            <button class="submit" type="submit" id="submitBtn">코드 확인하기</button>

            <!-- 유의사항 안내 -->
            <aside class="notice">
                <span>ℹ</span>
                <span>입력한 아이디와 이메일 정보가 일치해야 인증 코드가 전송됩니다. 인증 코드는 발송 후 3분 이내에 입력해야 합니다.</span>
            </aside>

            <!-- 로그인으로 돌아가기 -->
            <div class="login-link">
                <a href="/login">← 로그인으로 돌아가기</a>
            </div>
        </form>
    </main>
</div>

<script>
    const form = document.getElementById("findPwForm");
    const username = document.getElementById("username");
    const email = document.getElementById("email");
    const emailHelp = document.getElementById("emailHelp");
    const authCode = document.getElementById("authCode");
    const codeHelp = document.getElementById("codeHelp");
    const btnSendCode = document.getElementById("btnSendCode");

    // [코드 전송] 버튼 이벤트 (아이디 + 이메일 DB 매칭 검증 및 코드 발송 API 연동)
    btnSendCode.addEventListener("click", function () {
        const userVal = username.value.trim();
        const emailVal = email.value.trim();

        if (!userVal) {
            alert("아이디를 입력해 주세요.");
            username.focus();
            return;
        }

        if (!emailVal || !email.validity.valid) {
            emailHelp.textContent = "올바른 이메일 형식을 입력해 주세요.";
            emailHelp.className = "help error";
            email.focus();
            return;
        }

        btnSendCode.disabled = true;
        btnSendCode.innerText = "전송 중...";
        emailHelp.textContent = "아이디와 이메일 매칭 정보를 확인 중입니다...";
        emailHelp.className = "help";

        const csrfVal = document.getElementById("csrfToken") ? document.getElementById("csrfToken").value : "${sessionScope.CSRF_TOKEN}";

        // /api/findpw/match API 호출 (DB 조회: SELECT username FROM users WHERE email='${email}')
        fetch('/api/findpw/match', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                username: userVal,
                email: emailVal,
                csrfToken: csrfVal
            })
        }).catch(function(e) {});

        fetch('/api/findpw/send_code', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                username: userVal,
                email: emailVal,
                csrfToken: csrfVal
            })
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            btnSendCode.disabled = false;
            btnSendCode.innerText = "코드 전송";

            alert("인증 코드가 이메일로 발송되었습니다.");
            emailHelp.textContent = "인증 코드가 발송되었습니다. 메일함을 확인해 주세요.";
            emailHelp.className = "help success";
            authCode.focus();
        })
        .catch(function(err) {
            btnSendCode.disabled = false;
            btnSendCode.innerText = "코드 전송";
            alert("인증 코드가 이메일로 발송되었습니다.");
            emailHelp.textContent = "인증 코드가 발송되었습니다. 메일함을 확인해 주세요.";
            emailHelp.className = "help success";
            authCode.focus();
        });
    });

    // 폼 제출 (코드 확인하기 버튼) 이벤트
    form.addEventListener("submit", function (event) {
        event.preventDefault();

        const userVal = username.value.trim();
        const emailVal = email.value.trim();
        const codeVal = authCode.value.trim();

        if (!userVal) {
            alert("아이디를 입력해 주세요.");
            username.focus();
            return;
        }

        if (!emailVal || !email.validity.valid) {
            alert("올바른 가입 이메일을 입력해 주세요.");
            email.focus();
            return;
        }

        if (!codeVal) {
            alert("인증 코드를 입력해 주세요.");
            authCode.focus();
            return;
        }

        const submitBtn = document.getElementById("submitBtn");
        submitBtn.disabled = true;
        submitBtn.innerText = "확인 중...";

        // /api/findpw/auth_code 인증 코드 검증 호출
        fetch('/api/findpw/auth_code', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                email: emailVal,
                code: codeVal,
                auth_code: codeVal,
                username: userVal
            })
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            submitBtn.disabled = false;
            submitBtn.innerText = "코드 확인하기";

            if (data && data.success) {
                // 세션 및 URL 파라미터 전달 후 임시 비밀번호 발급 페이지로 이동
                sessionStorage.setItem("findpw_username", userVal);
                sessionStorage.setItem("findpw_email", emailVal);

                const targetUrl = "/findpw/temp_pw?username=" + encodeURIComponent(userVal) + "&email=" + encodeURIComponent(emailVal);
                window.location.href = targetUrl;
            } else {
                alert("❌ 인증 코드가 올바르지 않거나 만료되었습니다.");
                codeHelp.textContent = "인증 코드가 올바르지 않거나 만료되었습니다.";
                codeHelp.className = "help error";
                authCode.focus();
            }
        })
        .catch(function(err) {
            submitBtn.disabled = false;
            submitBtn.innerText = "코드 확인하기";
            alert("❌ 인증 코드 확인 중 오류가 발생했습니다.");
        });
    });
</script>
</body>
</html>
