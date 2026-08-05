<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finlab - 회원가입</title>
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

        button, input, select { font: inherit; }
        button, select, label { cursor: pointer; }

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

        .header h1 {
            margin: 0;
            font-size: 18px;
            font-weight: 800;
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
            width: min(100%, 560px);
            margin: auto;
            padding: 34px 24px 80px;
        }

        .intro { margin-bottom: 32px; }

        .intro h2 {
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

        .field { margin-bottom: 22px; }

        .field-label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 700;
            color: #333;
        }

        .required { color: var(--blue); }

        .input-row {
            display: flex;
            gap: 8px;
        }

        .input, .select {
            width: 100%;
            height: 49px;
            padding: 0 16px;
            border: 1px solid #dfe2e7;
            border-radius: 10px;
            outline: 0;
            background: #fff;
            color: var(--ink);
            font-size: 15px;
            transition: border-color .2s, box-shadow .2s;
        }

        .input:focus, .select:focus {
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

        .gender-group {
            display: flex;
            gap: 10px;
        }

        .gender-option {
            flex: 1;
            position: relative;
        }

        .gender-option input[type="radio"] {
            position: absolute;
            opacity: 0;
            width: 0;
            height: 0;
        }

        .gender-label {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 49px;
            border: 1px solid #dfe2e7;
            border-radius: 10px;
            background: #fff;
            color: #666;
            font-size: 15px;
            font-weight: 600;
            transition: all .2s;
        }

        .gender-option input[type="radio"]:checked + .gender-label {
            border-color: var(--blue);
            background: var(--blue-soft);
            color: var(--blue);
            font-weight: 800;
        }

        .password-wrap { position: relative; }
        .password-wrap .input { padding-right: 56px; }

        .password-toggle {
            position: absolute;
            top: 0;
            right: 4px;
            width: 48px;
            height: 49px;
            border: 0;
            background: transparent;
            color: #8e939c;
            font-size: 12px;
            font-weight: 600;
        }

        .help {
            min-height: 18px;
            margin: 6px 0 0;
            color: #8a8f99;
            font-size: 12px;
        }

        .help.error { color: var(--danger); }
        .help.success { color: var(--success); }

        .address-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .submit {
            width: 100%;
            height: 54px;
            margin-top: 32px;
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

        .login-link {
            margin: 20px 0 0;
            color: var(--muted);
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
            .content { padding: 28px 18px 60px; }
            .intro h2 { font-size: 23px; }
        }
    </style>
</head>
<body>
<div class="page">
    <header class="header">
        <a class="back" href="/" aria-label="메인으로 이동">←</a>
        <h1>회원가입</h1>
        <a class="brand" href="/">Finlab</a>
    </header>

    <main class="content">
        <section class="intro">
            <h2>Finlab 회원가입</h2>
            <p>회원정보를 입력하고 소셜 매치와 커뮤니티 서비스를 이용해 보세요.</p>
        </section>

        <form id="signupForm" novalidate>
            <!-- 1. 아이디 (username) -->
            <div class="field">
                <label class="field-label" for="username">아이디 <span class="required">*</span></label>
                <div class="input-row">
                    <input class="input" id="username" name="username" type="text"
                           placeholder="영문, 숫자 4~20자" autocomplete="username" required>
                    <button class="side-button" id="btnCheckUsername" type="button">중복 확인</button>
                </div>
                <p class="help" id="usernameHelp">로그인에 사용할 아이디를 입력해 주세요.</p>
            </div>

            <!-- 2. 비밀번호 (password) -->
            <div class="field">
                <label class="field-label" for="password">비밀번호 <span class="required">*</span></label>
                <div class="password-wrap">
                    <input class="input" id="password" name="password" type="password"
                           placeholder="8자 이상 (영문, 숫자, 특수문자 조합)"
                           autocomplete="new-password" required>
                    <button class="password-toggle" type="button" data-target="password">보기</button>
                </div>
                <p class="help" id="passwordHelp">8자 이상, 영문, 숫자, 특수문자(@$!%*#?&)를 조합하여 입력해 주세요.</p>
            </div>

            <!-- 비밀번호 확인 -->
            <div class="field">
                <label class="field-label" for="passwordConfirm">비밀번호 확인 <span class="required">*</span></label>
                <div class="password-wrap">
                    <input class="input" id="passwordConfirm" type="password"
                           placeholder="비밀번호를 한번 더 입력해 주세요"
                           autocomplete="new-password" required>
                    <button class="password-toggle" type="button" data-target="passwordConfirm">보기</button>
                </div>
                <p class="help" id="confirmHelp"></p>
            </div>

            <!-- 3. 이름 (name) -->
            <div class="field">
                <label class="field-label" for="name">이름 <span class="required">*</span></label>
                <input class="input" id="name" name="name" type="text"
                       placeholder="실명을 입력해 주세요" required>
            </div>

            <!-- 4. 나이 (age) & 5. 성별 (gender) -->
            <div class="input-row" style="margin-bottom: 22px;">
                <div class="field" style="flex: 1; margin-bottom: 0;">
                    <label class="field-label" for="age">나이 <span class="required">*</span></label>
                    <input class="input" id="age" name="age" type="number" min="1" max="120"
                           placeholder="예: 28" required>
                </div>

                <div class="field" style="flex: 1; margin-bottom: 0;">
                    <label class="field-label">성별 <span class="required">*</span></label>
                    <div class="gender-group">
                        <div class="gender-option">
                            <input type="radio" id="genderMale" name="gender" value="MALE" checked>
                            <label class="gender-label" for="genderMale">남성</label>
                        </div>
                        <div class="gender-option">
                            <input type="radio" id="genderFemale" name="gender" value="FEMALE">
                            <label class="gender-label" for="genderFemale">여성</label>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 6. 이메일 (email) -->
            <div class="field">
                <label class="field-label" for="email">이메일 <span class="required">*</span></label>
                <div class="input-row">
                    <input class="input" id="email" name="email" type="email"
                           placeholder="example@email.com" autocomplete="email" required>
                    <button class="side-button" id="btnCheckEmail" type="button">중복 확인</button>
                </div>
                <p class="help" id="emailHelp">이메일 주소를 입력해 주세요.</p>
            </div>

            <!-- 7. 전화번호 (phone_number) -->
            <div class="field">
                <label class="field-label" for="phoneNumber">전화번호 <span class="required">*</span></label>
                <input class="input" id="phoneNumber" name="phone_number" type="tel"
                       placeholder="010-0000-0000" autocomplete="tel" required>
            </div>

            <!-- 8. 집 주소 (address) -->
            <div class="field">
                <label class="field-label">집 주소 <span class="required">*</span></label>
                <div class="address-group">
                    <div class="input-row">
                        <input class="input" id="addressRoad" name="address_road" type="text"
                               placeholder="도로명 주소" readonly required>
                        <button class="side-button" id="btnSearchAddress" type="button">도로명 찾기</button>
                    </div>
                    <input class="input" id="addressDetail" name="address_detail" type="text"
                           placeholder="상세 주소 (동, 호수 등 입력)" required>
                </div>
            </div>

            <button class="submit" type="submit" id="submitBtn">가입하기</button>
            <p class="login-link">이미 계정이 있으신가요? <a href="/mypage">로그인 / 마이페이지</a></p>
        </form>
    </main>
</div>

<script>
    const form = document.getElementById("signupForm");
    const username = document.getElementById("username");
    const usernameHelp = document.getElementById("usernameHelp");
    const email = document.getElementById("email");
    const emailHelp = document.getElementById("emailHelp");
    const password = document.getElementById("password");
    const passwordHelp = document.getElementById("passwordHelp");
    const passwordConfirm = document.getElementById("passwordConfirm");
    const confirmHelp = document.getElementById("confirmHelp");

    // 중복 체크 및 도로명 찾기 임시 버튼 이벤트 연동
    document.getElementById("btnCheckUsername").addEventListener("click", function () {
        const val = username.value.trim();
        if (!val) {
            usernameHelp.textContent = "아이디를 입력해 주세요.";
            usernameHelp.className = "help error";
            username.focus();
            return;
        }
        alert("[아이디 중복 확인] API 연결 예정입니다.");
        usernameHelp.textContent = "사용 가능한 아이디입니다. (임시)";
        usernameHelp.className = "help success";
    });

    document.getElementById("btnCheckEmail").addEventListener("click", function () {
        const val = email.value.trim();
        if (!val || !email.validity.valid) {
            emailHelp.textContent = "올바른 이메일 형식을 입력해 주세요.";
            emailHelp.className = "help error";
            email.focus();
            return;
        }
        alert("[이메일 중복 확인] API 연결 예정입니다.");
        emailHelp.textContent = "사용 가능한 이메일입니다. (임시)";
        emailHelp.className = "help success";
    });

    document.getElementById("btnSearchAddress").addEventListener("click", function () {
        alert("[도로명 찾기] 주소 검색 API 연결 예정입니다.");
        document.getElementById("addressRoad").value = "서울시 강남구 테헤란로 123";
    });

    // 비밀번호 규칙 검증: 8자 이상, 영문 + 숫자 + 특수문자 조합
    const passwordRule = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;

    function validatePasswordFormat() {
        const val = password.value;
        if (!val) {
            passwordHelp.textContent = "8자 이상, 영문, 숫자, 특수문자(@$!%*#?&)를 조합하여 입력해 주세요.";
            passwordHelp.className = "help";
            return false;
        }
        if (!passwordRule.test(val)) {
            passwordHelp.textContent = "비밀번호는 8자 이상이며 영문, 숫자, 특수문자(@$!%*#?&)가 모두 포함되어야 합니다.";
            passwordHelp.className = "help error";
            return false;
        }
        passwordHelp.textContent = "올바른 비밀번호 형식입니다.";
        passwordHelp.className = "help success";
        return true;
    }

    function checkPasswordConfirm() {
        if (!passwordConfirm.value) {
            confirmHelp.textContent = "";
            return false;
        }
        const matched = password.value === passwordConfirm.value;
        confirmHelp.textContent = matched ? "비밀번호가 일치합니다." : "비밀번호가 일치하지 않습니다.";
        confirmHelp.className = matched ? "help success" : "help error";
        return matched;
    }

    const btnCheckUsername = document.getElementById("btnCheckUsername");
    let isUsernameChecked = false;

    // 아이디 중복 확인 연동 (/api/auth/dup POST)
    btnCheckUsername.addEventListener("click", function() {
        const usernameVal = username.value.trim();
        if (!usernameVal) {
            alert("아이디를 입력해 주세요.");
            username.focus();
            return;
        }

        if (usernameVal.length < 4 || usernameVal.length > 20) {
            usernameHelp.textContent = "아이디는 영문, 숫자 4~20자 사이여야 합니다.";
            usernameHelp.className = "help error";
            return;
        }

        fetch("/api/auth/dup", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ id: usernameVal })
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.duplicate) {
                usernameHelp.textContent = "❌ 이미 사용 중인 아이디입니다. 다른 아이디를 입력해 주세요.";
                usernameHelp.className = "help error";
                isUsernameChecked = false;
            } else {
                usernameHelp.textContent = "✅ 사용 가능한 아이디입니다.";
                usernameHelp.className = "help success";
                isUsernameChecked = true;
            }
        })
        .catch(function(err) {
            console.error("아이디 중복 확인 오류:", err);
            alert("아이디 중복 확인 처리 중 오류가 발생했습니다.");
        });
    });

    username.addEventListener("input", function() {
        isUsernameChecked = false;
        usernameHelp.textContent = "로그인에 사용할 아이디를 입력해 주세요.";
        usernameHelp.className = "help";
    });

    password.addEventListener("input", function() {
        validatePasswordFormat();
        checkPasswordConfirm();
    });

    passwordConfirm.addEventListener("input", checkPasswordConfirm);

    // 비밀번호 보기 / 숨김 토글
    document.querySelectorAll(".password-toggle").forEach(function (button) {
        button.addEventListener("click", function () {
            const targetId = button.dataset.target;
            const input = document.getElementById(targetId);
            const visible = input.type === "text";
            input.type = visible ? "password" : "text";
            button.textContent = visible ? "보기" : "숨김";
        });
    });

    // 폼 제출 이벤트
    form.addEventListener("submit", function (event) {
        event.preventDefault();

        if (!username.value.trim()) {
            alert("아이디를 입력해 주세요.");
            username.focus();
            return;
        }

        if (!isUsernameChecked) {
            alert("아이디 중복 확인을 진행해 주세요.");
            btnCheckUsername.focus();
            return;
        }

        if (!validatePasswordFormat()) {
            alert("비밀번호 형식이 올바르지 않습니다. (8자 이상, 영문+숫자+특수문자 필수)");
            password.focus();
            return;
        }

        if (!checkPasswordConfirm()) {
            alert("비밀번호 확인이 일치하지 않습니다.");
            passwordConfirm.focus();
            return;
        }

        const nameVal = document.getElementById("name").value.trim();
        if (!nameVal) {
            alert("이름을 입력해 주세요.");
            document.getElementById("name").focus();
            return;
        }

        const ageVal = document.getElementById("age").value;
        if (!ageVal) {
            alert("나이를 입력해 주세요.");
            document.getElementById("age").focus();
            return;
        }

        if (!email.value.trim() || !email.validity.valid) {
            alert("올바른 이메일을 입력해 주세요.");
            email.focus();
            return;
        }

        const phoneVal = document.getElementById("phoneNumber").value.trim();
        if (!phoneVal) {
            alert("전화번호를 입력해 주세요.");
            document.getElementById("phoneNumber").focus();
            return;
        }

        const roadVal = document.getElementById("addressRoad").value.trim();
        if (!roadVal) {
            alert("도로명 주소를 선택/입력해 주세요.");
            document.getElementById("btnSearchAddress").focus();
            return;
        }

        alert("회원가입 입력 양식이 올바르게 검증되었습니다. (회원가입 API 연결 예정)");
    });
</script>
</body>
</html>
