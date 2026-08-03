<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finlab - 임시 비밀번호 발급</title>
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

        button { font: inherit; cursor: pointer; }

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
            padding: 55px 24px 70px;
            text-align: center;
        }

        .icon {
            position: relative;
            display: grid;
            width: 88px;
            height: 88px;
            margin: 0 auto 24px;
            place-items: center;
            border-radius: 50%;
            background: var(--blue-soft);
            color: var(--blue);
            font-size: 38px;
        }

        .check {
            position: absolute;
            right: 0;
            bottom: 0;
            display: grid;
            width: 28px;
            height: 28px;
            place-items: center;
            border: 3px solid #fff;
            border-radius: 50%;
            background: var(--blue);
            color: #fff;
            font-size: 12px;
            font-weight: 800;
        }

        h1 {
            margin: 0 0 12px;
            font-size: 26px;
            font-weight: 800;
            letter-spacing: -1px;
        }

        .description {
            margin: 0 0 28px;
            color: var(--muted);
            font-size: 14px;
            line-height: 1.65;
        }

        .password-card {
            margin: 0 0 24px;
            padding: 24px 20px;
            border: 1px solid #dbe8fb;
            border-radius: 14px;
            background: #f7faff;
        }

        .password-card small {
            display: block;
            margin-bottom: 12px;
            color: #738299;
            font-size: 12px;
            font-weight: 700;
        }

        .password-row {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

        .password {
            color: var(--blue-dark);
            font-family: Consolas, Monaco, monospace;
            font-size: 24px;
            font-weight: 800;
            letter-spacing: 2px;
        }

        .copy-btn {
            padding: 8px 14px;
            border: 1px solid #cbdcf6;
            border-radius: 8px;
            background: #fff;
            color: var(--blue);
            font-size: 12px;
            font-weight: 700;
            transition: background .2s;
        }

        .copy-btn:hover { background: var(--blue-soft); }

        .notice {
            margin: 0 0 32px;
            padding: 14px 16px;
            border-radius: 10px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            color: #64748b;
            font-size: 12px;
            line-height: 1.6;
            text-align: left;
        }

        .actions {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .login-btn {
            width: 100%;
            height: 52px;
            border: 0;
            border-radius: 12px;
            background: var(--blue);
            color: #fff;
            font-size: 16px;
            font-weight: 800;
            box-shadow: 0 6px 16px rgba(21, 112, 255, .25);
            transition: background .2s;
        }

        .login-btn:hover { background: var(--blue-dark); }

        .login-link {
            margin-top: 14px;
            font-size: 13px;
        }

        .login-link a {
            color: var(--blue);
            font-weight: 700;
            text-decoration: none;
        }

        .toast {
            position: fixed;
            bottom: 35px;
            left: 50%;
            padding: 12px 20px;
            transform: translate(-50%, 10px);
            border-radius: 24px;
            background: rgba(32, 35, 40, .92);
            color: #fff;
            font-size: 13px;
            font-weight: 600;
            opacity: 0;
            transition: transform .2s, opacity .2s;
            pointer-events: none;
            z-index: 100;
        }

        .toast.show {
            transform: translate(-50%, 0);
            opacity: 1;
        }

        @media (max-width: 600px) {
            body { background: #fff; }
            .page { box-shadow: none; }
            .header { height: 58px; padding: 0 14px; }
            .content { padding: 42px 18px 60px; }
            h1 { font-size: 23px; }
            .password { font-size: 20px; }
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
        <div class="icon">🔒<span class="check">✓</span></div>
        <h1>임시 비밀번호가 발급되었습니다</h1>
        <p class="description">
            회원님의 요청에 따라 새로운 임시 비밀번호가 생성되었습니다.<br>
            아래 발급된 임시 비밀번호로 로그인 후 즉시 변경해 주세요.
        </p>

        <section class="password-card">
            <small>발급된 임시 비밀번호</small>
            <div class="password-row">
                <strong class="password" id="temporaryPassword">불러오는 중...</strong>
                <button class="copy-btn" id="copyButton" type="button">복사</button>
            </div>
        </section>

        <p class="notice">
            ℹ️ 보안을 위해 로그인 후 마이페이지에서 새로운 비밀번호로 반드시 변경해 주세요. 임시 비밀번호는 타인에게 유출되지 않도록 주의해 주세요.
        </p>

        <div class="actions">
            <!-- 로그인 페이지로 이동 버튼 -->
            <button class="login-btn" type="button" onclick="location.href='/login'">로그인 페이지로 이동</button>
        </div>
    </main>
</div>

<div class="toast" id="toast">임시 비밀번호가 복사되었습니다.</div>

<script>
    const temporaryPassword = document.getElementById("temporaryPassword");
    const copyButton = document.getElementById("copyButton");
    const toast = document.getElementById("toast");

    // URL 파라미터 또는 저장소에서 username 과 email 추출
    const urlParams = new URLSearchParams(window.location.search);
    const username = urlParams.get("username") || sessionStorage.getItem("findpw_username") || "";
    const email = urlParams.get("email") || sessionStorage.getItem("findpw_email") || "";

    // 임시 비밀번호 생성 API 호출
    function fetchTempPassword() {
        if (!username || !email) {
            // 파라미터가 없을 경우 기본 안내 텍스트 표시
            temporaryPassword.textContent = "Finlab123!";
            return;
        }

        fetch('/api/findpw/temp_pw', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                username: username,
                email: email
            })
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data && data.temp_password) {
                temporaryPassword.textContent = data.temp_password;
            } else {
                temporaryPassword.textContent = "발급 실패";
            }
        })
        .catch(function(err) {
            console.error("임시 비밀번호 생성 실패:", err);
            temporaryPassword.textContent = "발급 실패";
        });
    }

    // 복사 버튼 기능
    copyButton.addEventListener("click", function () {
        const textToCopy = temporaryPassword.textContent;
        if (textToCopy && textToCopy !== "불러오는 중..." && textToCopy !== "발급 실패") {
            if (navigator.clipboard) {
                navigator.clipboard.writeText(textToCopy);
            } else {
                const textarea = document.createElement("textarea");
                textarea.value = textToCopy;
                document.body.appendChild(textarea);
                textarea.select();
                document.execCommand("copy");
                document.body.removeChild(textarea);
            }
            toast.classList.add("show");
            setTimeout(function () { toast.classList.remove("show"); }, 1800);
        }
    });

    // 페이지 로드 시 API 실행
    document.addEventListener("DOMContentLoaded", fetchTempPassword);
</script>
</body>
</html>
