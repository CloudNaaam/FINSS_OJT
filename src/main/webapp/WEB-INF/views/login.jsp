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
        <!-- 1단계 ID/PW 로그인 영역 -->
        <div id="standardLoginSection">
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
        </div>

        <!-- 🔐 2단계 인증(MFA) OTP 영역 (MFA 활성 계정 로그인 시 표시) -->
        <div id="mfaSection" style="display: none;">
            <section class="intro">
                <div style="font-size: 36px; margin-bottom: 8px;">🔐</div>
                <h1>2단계 로그인 인증</h1>
                <p>보안 강화를 위해 2단계 인증이 활성화되어 있습니다.<br/>가입된 이메일 (<strong id="mfaTargetEmail" style="color: var(--blue);"></strong>)로 전송된 <strong>4자리 인증 코드</strong>를 입력해 주세요.</p>
            </section>

            <form id="mfaForm" novalidate>
                <div class="field">
                    <label class="field-label" for="mfaCode" style="text-align: center;">4자리 인증 코드 (제한 시간 없음)</label>
                    <input class="input" id="mfaCode" name="mfaCode" type="text" maxlength="4"
                           placeholder="••••"
                           style="text-align: center; font-size: 26px; letter-spacing: 12px; font-weight: 800; height: 58px;"
                           autocomplete="one-time-code" required>
                </div>

                <p class="error-message" id="mfaErrorMessage">인증 코드가 올바르지 않습니다.</p>

                <button class="login-button" type="submit" id="mfaSubmitBtn">인증 완료 및 로그인</button>

                <div class="bottom-links" style="flex-direction: column; gap: 10px; margin-top: 20px;">
                    <button type="button" onclick="handleResendMfaCode()" style="color: var(--blue); font-weight: 700;">🔄 인증 코드 다시 받기</button>
                    <button type="button" onclick="cancelMfaLogin()" style="color: #888;">← 다른 아이디로 로그인</button>
                </div>
            </form>
        </div>
    </main>
</div>

<script>
    const form = document.getElementById("loginForm");
    const username = document.getElementById("username");
    const password = document.getElementById("password");
    const passwordToggle = document.getElementById("passwordToggle");
    const errorMessage = document.getElementById("errorMessage");

    const standardLoginSection = document.getElementById("standardLoginSection");
    const mfaSection = document.getElementById("mfaSection");
    const mfaForm = document.getElementById("mfaForm");
    const mfaCode = document.getElementById("mfaCode");
    const mfaErrorMessage = document.getElementById("mfaErrorMessage");
    const mfaTargetEmail = document.getElementById("mfaTargetEmail");

    let currentPendingUserId = null;

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

    if (mfaCode) {
        mfaCode.addEventListener("input", function () {
            mfaErrorMessage.classList.remove("show");
            // 숫자만 허용
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    }

    // 1단계 로그인 폼 제출
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

        fetch("/api/auth/login", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                username: userVal,
                password: passVal
            })
        })
        .then(function (res) {
            if (!res.ok) throw new Error("로그인 처리 중 오류가 발생했습니다.");
            return res.json();
        })
        .then(function (data) {
            if (data && data.success) {
                if (data.access_token) {
                    localStorage.setItem('access_token', data.access_token);
                }

                // 🔐 2단계 인증(MFA)이 필요한 경우 /2fa 페이지로 리다이렉트
                if (data.mfa_required) {
                    location.href = data.redirect_url || "/2fa";
                    return;
                }

                // MFA가 아닌 일반 로그인 완료
                location.href = data.redirect_url || "/mypage";
            } else {
                if (data && data.message) {
                    alert(data.message);
                }
                errorMessage.classList.add("show");
            }
        })
        .catch(function (err) {
            console.error("로그인 오류:", err);
            errorMessage.classList.add("show");
        });
    });

    // 2단계 MFA 인증 폼 제출
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
                user_id: currentPendingUserId,
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

    // MFA 코드 재발송
    function handleResendMfaCode() {
        fetch("/api/auth/mfa/resend", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                user_id: currentPendingUserId
            })
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

    // MFA 취소 및 1단계로 복귀
    function cancelMfaLogin() {
        currentPendingUserId = null;
        mfaSection.style.display = "none";
        standardLoginSection.style.display = "block";
        password.value = "";
        password.focus();
    }
</script>
</body>
</html>
