<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finlab - 2단계 인증</title>
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
            font-family: Noto Sans KR, sans-serif;
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

        .intro { margin-bottom: 34px; text-align: center; }

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
            text-align: center;
        }

        .input {
            width: 100%;
            height: 58px;
            padding: 0 16px;
            border: 1px solid #dfe2e7;
            border-radius: 12px;
            outline: 0;
            background: #fff;
            color: var(--ink);
            font-size: 28px;
            letter-spacing: 14px;
            font-weight: 800;
            text-align: center;
            transition: border-color .2s, box-shadow .2s;
        }

        .input:focus {
            border-color: var(--blue);
            box-shadow: 0 0 0 3px rgba(21, 112, 255, .12);
        }

        .input::placeholder { color: #b0b4bb; letter-spacing: 6px; }

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
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 12px;
            margin-top: 24px;
            font-size: 13px;
        }

        .bottom-links button, .bottom-links a {
            color: #666c77;
            font-weight: 600;
            text-decoration: none;
            border: 0;
            background: transparent;
            padding: 0;
            font-size: 13px;
            cursor: pointer;
        }

        .bottom-links button:hover, .bottom-links a:hover {
            color: var(--blue);
        }

        .error-message {
            display: none;
            margin: -8px 0 16px;
            color: var(--danger);
            font-size: 12px;
            text-align: center;
        }

        .error-message.show { display: block; }
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
            <div style="font-size: 40px; margin-bottom: 12px;">🔐</div>
            <h1>2단계 로그인 인증</h1>
            <p>보안 강화를 위해 2단계 인증이 활성화되어 있습니다.<br/>가입된 이메일로 전송된 <strong>4자리 인증 코드</strong>를 입력해 주세요.</p>
        </section>

        <form id="mfaForm" novalidate>
            <div class="field">
                <label class="field-label" for="mfaCode">4자리 인증 코드 (제한 시간 없음)</label>
                <input class="input" id="mfaCode" name="mfaCode" type="text" maxlength="4"
                       placeholder="••••"
                       autocomplete="one-time-code" autofocus required>
            </div>

            <p class="error-message" id="mfaErrorMessage">인증 코드가 올바르지 않습니다.</p>

            <button class="login-button" type="submit" id="mfaSubmitBtn">인증 완료 및 로그인</button>

            <div class="bottom-links">
                <button type="button" onclick="handleResendMfaCode()" style="color: var(--blue); font-weight: 700;">🔄 인증 코드 다시 받기</button>
                <a href="/logout" style="color: #888;">← 다른 아이디로 로그인 (로그아웃)</a>
            </div>
        </form>
    </main>
</div>

<script>
    const mfaForm = document.getElementById("mfaForm");
    const mfaCode = document.getElementById("mfaCode");
    const mfaErrorMessage = document.getElementById("mfaErrorMessage");

    if (mfaCode) {
        mfaCode.addEventListener("input", function () {
            mfaErrorMessage.classList.remove("show");
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    }

    mfaForm.addEventListener("submit", function (e) {
        e.preventDefault();

        const codeVal = mfaCode.value.trim();
        if (!codeVal || codeVal.length !== 4) {
            alert("4자리 인증 코드를 정확히 입력해 주세요.");
            mfaCode.focus();
            return;
        }

        fetch("/api/auth/mfa/verify", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                code: codeVal
            })
        })
        .then(function (res) {
            return res.json();
        })
        .then(function (data) {
            if (data && data.success) {
                if (data.access_token) {
                    localStorage.setItem('access_token', data.access_token);
                }
                alert("2단계 인증이 완료되었습니다!");
                location.href = data.redirect_url || "/mypage";
            } else {
                if (data && data.message) {
                    alert(data.message);
                }
                mfaErrorMessage.classList.add("show");
                mfaCode.focus();
            }
        })
        .catch(function (err) {
            console.error("MFA 인증 오류:", err);
            mfaErrorMessage.classList.add("show");
        });
    });

    function handleResendMfaCode() {
        fetch("/api/auth/mfa/resend", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({})
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data && data.success) {
                alert("인증 코드가 이메일로 다시 발송되었습니다.");
            } else {
                alert(data.message || "인증 코드 재발송에 실패했습니다.");
            }
        })
        .catch(function(err) {
            alert("네트워크 오류가 발생했습니다.");
        });
    }
</script>
</body>
</html>