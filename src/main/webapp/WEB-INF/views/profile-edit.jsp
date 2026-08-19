<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>핀랩풋볼 - 내 정보 수정</title>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap");

        * { box-sizing: border-box; }

        :root {
            --blue: #1570ff;
            --blue-dark: #0758d7;
            --blue-soft: #eaf3ff;
            --ink: #1e293b;
            --muted: #64748b;
            --line: #e2e8f0;
            --bg: #f8fafc;
            --green: #10b981;
            --red: #ef4444;
        }

        body {
            margin: 0;
            background: var(--bg);
            color: var(--ink);
            font-family: "Noto Sans KR", sans-serif;
            word-break: keep-all;
        }

        button, input, select { font: inherit; }
        button { cursor: pointer; }

        .page {
            width: min(100%, 600px);
            min-height: 100vh;
            margin: 0 auto;
            background: #fff;
            box-shadow: 0 0 30px rgba(20, 26, 36, .05);
            display: flex;
            flex-direction: column;
        }

        /* 헤더 */
        .header {
            position: sticky;
            z-index: 20;
            top: 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 60px;
            padding: 0 20px;
            background: rgba(255, 255, 255, .96);
            border-bottom: 1px solid var(--line);
            backdrop-filter: blur(10px);
        }

        .header-title {
            font-size: 18px;
            font-weight: 800;
            color: var(--ink);
        }

        .back-btn {
            display: grid;
            width: 36px;
            height: 36px;
            place-items: center;
            border: 0;
            background: transparent;
            color: var(--ink);
            font-size: 22px;
            text-decoration: none;
            border-radius: 50%;
            transition: background 0.15s;
        }

        .back-btn:hover { background: #f1f5f9; }

        /* 컨텐츠 */
        .content {
            padding: 28px 24px 60px;
            flex: 1;
        }

        /* 프로필 이미지 섹션 */
        .avatar-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 32px;
        }

        .avatar-wrapper {
            position: relative;
            width: 100px;
            height: 100px;
            margin-bottom: 12px;
        }

        .avatar-img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
            background: var(--blue-soft);
            display: grid;
            place-items: center;
            font-size: 42px;
            border: 3px solid #fff;
            box-shadow: 0 4px 14px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        .avatar-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .avatar-actions {
            display: flex;
            gap: 8px;
        }

        .btn-avatar {
            padding: 6px 14px;
            border-radius: 20px;
            border: 1px solid var(--line);
            background: #fff;
            font-size: 12px;
            font-weight: 700;
            color: var(--muted);
            transition: all 0.15s;
        }

        .btn-avatar:hover {
            border-color: var(--blue);
            color: var(--blue);
            background: var(--blue-soft);
        }

        .btn-avatar.delete:hover {
            border-color: var(--red);
            color: var(--red);
            background: #fef2f2;
        }

        /* 폼 섹션 */
        .form-group {
            margin-bottom: 22px;
        }

        .form-label {
            display: block;
            font-size: 13px;
            font-weight: 700;
            color: var(--ink);
            margin-bottom: 8px;
        }

        .form-input {
            width: 100%;
            height: 48px;
            padding: 0 16px;
            border-radius: 12px;
            border: 1.5px solid var(--line);
            background: #fff;
            font-size: 15px;
            color: var(--ink);
            outline: 0;
            transition: border-color 0.15s, box-shadow 0.15s;
        }

        .form-input:focus {
            border-color: var(--blue);
            box-shadow: 0 0 0 3px rgba(21, 112, 255, 0.12);
        }

        .form-input:disabled, .form-input[readonly] {
            background: #f1f5f9;
            color: #94a3b8;
            cursor: not-allowed;
        }

        .form-hint {
            font-size: 12px;
            color: var(--muted);
            margin-top: 6px;
        }

        /* 성별 선택 세그먼트 */
        .gender-options {
            display: flex;
            gap: 8px;
        }

        .gender-btn {
            flex: 1;
            height: 46px;
            border-radius: 12px;
            border: 1.5px solid var(--line);
            background: #fff;
            font-size: 14px;
            font-weight: 700;
            color: var(--muted);
            transition: all 0.15s;
        }

        .gender-btn.active {
            border-color: var(--blue);
            background: var(--blue-soft);
            color: var(--blue);
        }

        /* 구분선 */
        .divider {
            height: 1px;
            background: var(--line);
            margin: 28px 0;
        }

        .section-title {
            font-size: 15px;
            font-weight: 800;
            color: var(--ink);
            margin: 0 0 16px;
        }

        /* 하단 버튼 */
        .btn-submit {
            width: 100%;
            height: 52px;
            border-radius: 14px;
            border: 0;
            background: var(--blue);
            color: #fff;
            font-size: 16px;
            font-weight: 800;
            box-shadow: 0 4px 14px rgba(21, 112, 255, 0.3);
            transition: background 0.15s, transform 0.05s;
            margin-top: 20px;
        }

        .btn-submit:hover { background: var(--blue-dark); }
        .btn-submit:active { transform: scale(0.98); }

        /* 토스트 알림 */
        .toast {
            position: fixed;
            bottom: 30px;
            left: 50%;
            transform: translateX(-50%) translateY(20px);
            background: rgba(15, 23, 42, 0.9);
            color: #fff;
            padding: 12px 24px;
            border-radius: 24px;
            font-size: 14px;
            font-weight: 600;
            opacity: 0;
            transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
            pointer-events: none;
            z-index: 100;
        }

        .toast.show {
            opacity: 1;
            transform: translateX(-50%) translateY(0);
        }
    </style>
</head>
<body>
<div class="page">
    <header class="header">
        <a href="/mypage" class="back-btn" aria-label="마이페이지로 돌아가기">←</a>
        <div class="header-title">내 정보 수정</div>
        <div style="width: 36px;"></div>
    </header>

    <main class="content">
        <!-- 프로필 사진 관리 -->
        <div class="avatar-section">
            <div class="avatar-wrapper">
                <div class="avatar-img" id="avatarDisplay">👤</div>
            </div>
            <div class="avatar-actions">
                <input type="file" id="profileImgInput" accept="image/png, image/jpeg, image/jpg" style="display: none;">
                <button type="button" class="btn-avatar" onclick="document.getElementById('profileImgInput').click()">📷 사진 변경</button>
                <button type="button" class="btn-avatar delete" id="btnDeleteAvatar" onclick="handleDeleteProfileImg()">🗑️ 삭제</button>
            </div>
        </div>

        <form id="profileForm" onsubmit="handleUpdateProfile(event)">
            <!-- 아이디 (수정 불가) -->
            <div class="form-group">
                <label class="form-label">아이디</label>
                <input type="text" class="form-input" id="inputUsername" readonly disabled placeholder="아이디 불러오는 중...">
                <div class="form-hint">아이디는 변경할 수 없습니다.</div>
            </div>

            <!-- 이름 -->
            <div class="form-group">
                <label class="form-label">이름</label>
                <input type="text" class="form-input" id="inputName" placeholder="이름을 입력하세요" required>
            </div>

            <!-- 이메일 -->
            <div class="form-group">
                <label class="form-label">이메일</label>
                <div style="display: flex; gap: 8px;">
                    <input type="email" class="form-input" id="inputEmail" placeholder="example@finss.com" required oninput="handleEmailInput()">
                    <button type="button" class="btn-avatar" id="btnSendCode" style="display: none; height: 48px; border-radius: 12px; white-space: nowrap; font-size: 13px; font-weight: 700; color: var(--blue); border-color: var(--blue); background: var(--blue-soft);" onclick="handleSendEmailCode()">인증코드 발송</button>
                </div>
                <div class="form-hint" id="emailHint">이메일 변경 시 새 이메일 인증이 필요합니다.</div>
            </div>

            <!-- 이메일 인증코드 입력 영역 (이메일 변경 시 노출) -->
            <div class="form-group" id="emailAuthBox" style="display: none; background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 14px; padding: 16px;">
                <label class="form-label" style="color: #166534; margin-bottom: 6px;">📧 새 이메일 인증코드</label>
                <div style="display: flex; gap: 8px;">
                    <input type="text" class="form-input" id="inputAuthCode" maxlength="6" placeholder="6자리 인증코드 입력" style="background: #fff;">
                    <button type="button" class="btn-avatar" id="btnVerifyCode" style="height: 48px; border-radius: 12px; white-space: nowrap; font-size: 13px; font-weight: 700; background: #16a34a; color: #fff; border: 0;" onclick="handleVerifyEmailCode()">인증 확인</button>
                </div>
                <div id="authStatusText" style="font-size: 12px; color: #166534; margin-top: 6px;">메일로 발송된 6자리 코드를 입력해주세요.</div>
            </div>

            <!-- 연락처 -->
            <div class="form-group">
                <label class="form-label">휴대폰 번호</label>
                <input type="tel" class="form-input" id="inputPhone" placeholder="010-1234-5678">
            </div>

            <!-- 나이 & 성별 -->
            <div style="display: flex; gap: 16px; margin-bottom: 22px;">
                <div style="flex: 1;">
                    <label class="form-label">나이</label>
                    <input type="number" class="form-input" id="inputAge" min="10" max="100" placeholder="25">
                </div>
                <div style="flex: 1.5;">
                    <label class="form-label">성별</label>
                    <div class="gender-options">
                        <button type="button" class="gender-btn" id="btnGenderMale" onclick="selectGender('MALE')">남성</button>
                        <button type="button" class="gender-btn" id="btnGenderFemale" onclick="selectGender('FEMALE')">여성</button>
                    </div>
                </div>
            </div>

            <div class="divider"></div>

            <!-- 비밀번호 변경 (선택 사항) -->
            <h3 class="section-title">🔒 비밀번호 변경 (선택)</h3>
            <div class="form-group">
                <label class="form-label">새 비밀번호</label>
                <input type="password" class="form-input" id="inputPassword" placeholder="변경할 때만 입력하세요">
            </div>
            <div class="form-group">
                <label class="form-label">새 비밀번호 확인</label>
                <input type="password" class="form-input" id="inputPasswordConfirm" placeholder="새 비밀번호를 한 번 더 입력하세요">
            </div>

            <!-- 제출 버튼 -->
            <button type="submit" class="btn-submit" id="btnSubmit">수정 완료</button>

            <!-- 회원 탈퇴 링크 -->
            <div style="text-align: center; margin-top: 24px;">
                <button type="button" onclick="handleWithdrawAccount()" style="background: transparent; border: 0; color: #ef4444; font-size: 13px; font-weight: 600; text-decoration: underline; cursor: pointer;">회원 탈퇴 (계정 삭제)</button>
            </div>
        </form>
    </main>
</div>

<div class="toast" id="toast"></div>

<script>
    let selectedGender = "MALE";
    let originalEmail = "";
    let isEmailVerified = false;
    const toast = document.getElementById("toast");

    function showToast(msg) {
        toast.textContent = msg;
        toast.classList.add("show");
        setTimeout(function() { toast.classList.remove("show"); }, 2200);
    }

    function selectGender(gender) {
        selectedGender = gender;
        document.getElementById("btnGenderMale").classList.toggle("active", gender === "MALE");
        document.getElementById("btnGenderFemale").classList.toggle("active", gender === "FEMALE");
    }

    // 내 프로필 정보 불러오기
    function fetchProfileData() {
        fetch('/api/profile/me')
            .then(function(res) {
                if (!res.ok) throw new Error("인증 실패");
                return res.json();
            })
            .then(function(user) {
                if (!user) return;

                document.getElementById("inputUsername").value = user.username || "";
                document.getElementById("inputName").value = user.name || "";
                originalEmail = user.email || "";
                document.getElementById("inputEmail").value = originalEmail;
                document.getElementById("inputPhone").value = user.phone_number || "";
                document.getElementById("inputAge").value = user.age || "";

                if (user.gender) {
                    selectGender(user.gender.toUpperCase());
                } else {
                    selectGender("MALE");
                }

                // 프로필 사진 렌더링
                renderAvatar(user.profile_img);
            })
            .catch(function(err) {
                console.error("프로필 정보 로드 실패:", err);
                alert("로그인 정보가 필요합니다.");
                location.href = "/login";
            });
    }

    function renderAvatar(profileImg) {
        const avatarDisplay = document.getElementById("avatarDisplay");
        if (profileImg && profileImg.trim() !== "") {
            var fullPath = profileImg.startsWith("/") ? profileImg : "/uploads/profile/" + profileImg;
            avatarDisplay.innerHTML = '<img src="' + fullPath + '" alt="프로필 이미지">';
        } else {
            avatarDisplay.innerHTML = '👤';
        }
    }

    // 이메일 입력 감지
    function handleEmailInput() {
        const current = document.getElementById("inputEmail").value.trim();
        const btnSend = document.getElementById("btnSendCode");
        const authBox = document.getElementById("emailAuthBox");
        const hint = document.getElementById("emailHint");

        if (current !== originalEmail) {
            btnSend.style.display = "block";
            hint.innerText = "이메일 변경 시 새 이메일 인증이 필요합니다.";
            hint.style.color = "var(--blue)";
            isEmailVerified = false;
        } else {
            btnSend.style.display = "none";
            authBox.style.display = "none";
            hint.innerText = "기존에 등록된 이메일입니다.";
            hint.style.color = "var(--muted)";
            isEmailVerified = true;
        }
    }

    // 이메일 변경 인증코드 발송 (유효기간 무제한)
    function handleSendEmailCode() {
        const email = document.getElementById("inputEmail").value.trim();
        if (!email) {
            alert("이메일 주소를 입력해주세요.");
            return;
        }

        const btn = document.getElementById("btnSendCode");
        btn.disabled = true;
        btn.innerText = "발송 중...";

        fetch('/api/profile/send_code', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email: email })
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            btn.disabled = false;
            btn.innerText = "재발송";

            if (data && data.success) {
                document.getElementById("emailAuthBox").style.display = "block";
                document.getElementById("inputAuthCode").disabled = false;
                document.getElementById("inputAuthCode").value = "";
                document.getElementById("btnVerifyCode").disabled = false;
                document.getElementById("btnVerifyCode").innerText = "인증 확인";
                document.getElementById("authStatusText").innerText = "메일로 발송된 6자리 코드를 입력해주세요.";
                showToast("인증 코드가 이메일로 발송되었습니다.");
            } else {
                alert(data.message || "인증 코드 발송에 실패했습니다.");
            }
        })
        .catch(function(err) {
            btn.disabled = false;
            btn.innerText = "인증코드 발송";
            console.error("인증코드 발송 오류:", err);
            alert("인증 코드 요청 중 네트워크 오류가 발생했습니다.");
        });
    }

    // 이메일 변경 인증코드 검증 (제한시간 없이 검증 통과)
    function handleVerifyEmailCode() {
        const email = document.getElementById("inputEmail").value.trim();
        const code = document.getElementById("inputAuthCode").value.trim();

        if (!code) {
            alert("인증 코드를 입력해주세요.");
            document.getElementById("inputAuthCode").focus();
            return;
        }

        fetch('/api/profile/valid_code', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email: email, code: code })
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data && data.success) {
                isEmailVerified = true;
                document.getElementById("inputAuthCode").disabled = true;
                document.getElementById("btnVerifyCode").disabled = true;
                document.getElementById("btnVerifyCode").innerText = "인증완료";
                document.getElementById("authStatusText").innerHTML = "<b>✅ 이메일 인증이 완료되었습니다.</b>";
                showToast("이메일 인증이 완료되었습니다.");
            } else {
                alert(data.message || "인증 코드가 올바르지 않습니다.");
            }
        })
        .catch(function(err) {
            console.error("인증 검증 오류:", err);
            alert("인증 검증 중 오류가 발생했습니다.");
        });
    }

    // 프로필 사진 업로드 처리
    document.getElementById("profileImgInput").addEventListener("change", function(e) {
        const file = e.target.files[0];
        if (!file) return;

        const formData = new FormData();
        formData.append("profile_img", file);

        showToast("프로필 사진 업로드 중...");

        fetch('/api/profile/imgup', {
            method: 'POST',
            body: formData
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data && data.success && data.profile_img) {
                renderAvatar(data.profile_img);
                showToast("프로필 사진이 변경되었습니다.");
            } else {
                alert("사진 업로드 실패 (JPG, PNG 형식만 지원됩니다)");
            }
        })
        .catch(function(err) {
            console.error("사진 업로드 오류:", err);
            alert("사진 업로드 중 오류가 발생했습니다.");
        });
    });

    // 프로필 사진 삭제 처리
    function handleDeleteProfileImg() {
        if (!confirm("프로필 사진을 삭제하시겠습니까?")) return;

        fetch('/api/profile/imagedel', { method: 'DELETE' })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                if (data && data.success) {
                    renderAvatar(null);
                    showToast("프로필 사진이 삭제되었습니다.");
                } else {
                    showToast("삭제할 사진이 없습니다.");
                }
            })
            .catch(function(err) {
                console.error("사진 삭제 오류:", err);
                alert("사진 삭제 중 오류가 발생했습니다.");
            });
    }

    // 회원 정보 수정 폼 제출
    function handleUpdateProfile(e) {
        e.preventDefault();

        const name = document.getElementById("inputName").value.trim();
        const email = document.getElementById("inputEmail").value.trim();
        const phone = document.getElementById("inputPhone").value.trim();
        const ageVal = document.getElementById("inputAge").value.trim();
        const pwd = document.getElementById("inputPassword").value;
        const pwdConfirm = document.getElementById("inputPasswordConfirm").value;

        if (!name) {
            alert("이름을 입력해주세요.");
            return;
        }
        if (!email) {
            alert("이메일을 입력해주세요.");
            return;
        }

        // 이메일이 변경되었는데 인증을 안 받은 경우
        if (email !== originalEmail && !isEmailVerified) {
            alert("새 이메일 인증을 먼저 완료해주세요.");
            document.getElementById("btnSendCode").focus();
            return;
        }

        if (pwd && pwd !== pwdConfirm) {
            alert("새 비밀번호와 비밀번호 확인이 일치하지 않습니다.");
            document.getElementById("inputPasswordConfirm").focus();
            return;
        }

        const payload = {
            name: name,
            email: email,
            phone_number: phone,
            gender: selectedGender
        };

        if (ageVal) {
            payload.age = parseInt(ageVal, 10);
        }

        if (pwd && pwd.trim() !== "") {
            payload.password = pwd.trim();
        }

        const btn = document.getElementById("btnSubmit");
        btn.disabled = true;
        btn.innerText = "저장 중...";

        fetch('/api/profile/update', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            btn.disabled = false;
            btn.innerText = "수정 완료";

            if (data && data.success) {
                alert(data.message || "회원 정보가 성공적으로 수정되었습니다.");
                location.href = "/mypage";
            } else {
                alert("수정 실패: " + (data.message || "오류가 발생했습니다."));
            }
        })
        .catch(function(err) {
            btn.disabled = false;
            btn.innerText = "수정 완료";
            console.error("정보 수정 오류:", err);
            alert("정보 수정 중 네트워크 오류가 발생했습니다.");
        });
    }

    // 회원 탈퇴 처리
    function handleWithdrawAccount() {
        if (!confirm("정말로 회원 탈퇴를 진행하시겠습니까?\n탈퇴 시 모든 정보(매치 내역, 포인트 등)가 삭제되며 복구할 수 없습니다.")) {
            return;
        }
        if (!confirm("마지막 확인: 정말로 계정을 삭제하시겠습니까?")) {
            return;
        }

        fetch('/api/profile/withdraw', {
            method: 'POST'
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data && data.success) {
                localStorage.removeItem('access_token');
                alert(data.message || "회원 탈퇴가 완료되었습니다.");
                location.href = data.redirect_url || "/login";
            } else {
                alert(data.message || "회원 탈퇴 처리에 실패했습니다.");
            }
        })
        .catch(function(err) {
            console.error("탈퇴 오류:", err);
            alert("회원 탈퇴 처리 중 오류가 발생했습니다.");
        });
    }

    document.addEventListener("DOMContentLoaded", fetchProfileData);
</script>
</body>
</html>
