<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>핀랩풋볼 - 매니저 지원서</title>
    <style>
        :root {
            --bg: #F8FAFC;
            --surface: #FFFFFF;
            --border: #E2E8F0;
            --text-main: #0F172A;
            --muted: #64748B;
            --brand: #2563EB;
            --brand-dark: #1D4ED8;
            --brand-light: #EFF6FF;
            --error: #EF4444;
            --radius-md: 12px;
            --radius-lg: 16px;
        }

        * { box-sizing: border-box; }

        body {
            margin: 0;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background: var(--bg);
            color: var(--text-main);
            line-height: 1.5;
            -webkit-font-smoothing: antialiased;
        }

        .header {
            position: sticky;
            top: 0;
            z-index: 50;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid var(--border);
            padding: 0 20px;
            height: 64px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .btn-back {
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            color: var(--text-main);
            padding: 4px 8px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            text-decoration: none;
        }
        .btn-back:hover { background: var(--brand-light); color: var(--brand); }

        .logo { font-weight: 800; font-size: 18px; color: var(--brand); text-decoration: none; display: flex; align-items: center; gap: 6px; }

        .container { max-width: 680px; margin: 32px auto 80px; padding: 0 20px; }

        .hero { text-align: center; margin-bottom: 32px; }
        .hero-badge { display: inline-block; padding: 6px 14px; background: var(--brand-light); color: var(--brand); border-radius: 20px; font-weight: 600; font-size: 13px; margin-bottom: 12px; }
        .hero h1 { font-size: 28px; font-weight: 800; margin: 0 0 8px; letter-spacing: -0.5px; }
        .hero p { color: var(--muted); font-size: 15px; margin: 0; }

        .card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-lg); padding: 32px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.03); }

        .section { margin-bottom: 32px; }
        .section-title { font-size: 16px; font-weight: 700; margin: 0 0 16px; display: flex; align-items: center; gap: 8px; border-bottom: 1px solid var(--border); padding-bottom: 10px; }
        .step { background: var(--brand); color: #fff; border-radius: 50%; width: 22px; height: 22px; display: inline-flex; align-items: center; justify-content: center; font-size: 12px; font-weight: 700; }

        .field-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px; }
        .field { margin-bottom: 16px; }
        .field:last-child { margin-bottom: 0; }

        .field-label { display: block; font-size: 13px; font-weight: 600; color: var(--text-main); margin-bottom: 6px; }
        .required { color: var(--error); }

        .input, .select, .textarea {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            font-size: 14px;
            outline: none;
            transition: all 0.2s ease;
            background: #fff;
        }

        .input:focus, .select:focus, .textarea:focus { border-color: var(--brand); box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1); }

        .textarea { height: 140px; resize: vertical; }

        .help { font-size: 12px; color: var(--muted); margin-top: 4px; }
        .counter { text-align: right; }

        .upload-box {
            border: 2px dashed var(--border);
            border-radius: var(--radius-md);
            padding: 32px 20px;
            text-align: center;
            background: var(--bg);
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
        }

        .upload-box:hover, .upload-box.dragover { border-color: var(--brand); background: var(--brand-light); }

        .pdf-icon { font-size: 28px; background: #FEE2E2; color: #DC2626; width: 56px; height: 56px; border-radius: 12px; display: inline-flex; align-items: center; justify-content: center; font-weight: 800; }
        .upload-text strong { display: block; font-size: 14px; margin-bottom: 4px; }
        .upload-text p { font-size: 12px; color: var(--muted); margin: 0; }

        .file-button {
            background: var(--brand-light);
            color: var(--brand);
            padding: 8px 16px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 13px;
            margin-top: 8px;
            display: inline-block;
        }

        .file-name {
            display: none;
            background: var(--brand-light);
            border: 1px solid rgba(37, 99, 235, 0.2);
            color: var(--brand-dark);
            padding: 12px 16px;
            border-radius: var(--radius-md);
            font-size: 14px;
            font-weight: 600;
            align-items: center;
            justify-content: space-between;
            margin-top: 12px;
        }

        .file-name.show { display: flex; }

        .remove-file { background: none; border: none; font-size: 18px; color: var(--muted); cursor: pointer; }
        .remove-file:hover { color: var(--error); }

        .agreement { background: var(--bg); padding: 16px; border-radius: var(--radius-md); font-size: 13px; display: flex; gap: 10px; align-items: flex-start; margin-bottom: 24px; }
        .agreement input { margin-top: 3px; }

        .submit {
            width: 100%;
            padding: 16px;
            background: var(--brand);
            color: #fff;
            border: none;
            border-radius: var(--radius-md);
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s ease;
        }
        .submit:hover { background: var(--brand-dark); }

        .btn-status {
            display: block;
            width: 100%;
            text-align: center;
            padding: 12px;
            margin-top: 12px;
            background: none;
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            color: var(--text-main);
            font-weight: 600;
            font-size: 14px;
            text-decoration: none;
            cursor: pointer;
        }
        .btn-status:hover { background: var(--bg); }

        .error { color: var(--error); font-size: 12px; margin-top: 6px; }

        .complete { display: none; text-align: center; padding: 40px 20px; }
        .complete.show { display: block; }
        .complete-icon { width: 64px; height: 64px; background: #DEF7EC; color: #03543F; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 32px; margin-bottom: 16px; }
        .complete h2 { font-size: 22px; font-weight: 800; margin: 0 0 8px; }
        .complete p { color: var(--muted); font-size: 15px; margin: 0 0 24px; }
        .complete button.home { background: var(--brand); color: #fff; border: none; padding: 12px 24px; border-radius: var(--radius-md); font-weight: 600; font-size: 14px; cursor: pointer; }

        .hidden { display: none !important; }
    </style>
</head>
<body>

<header class="header">
    <div class="header-left">
        <a href="/mypage" class="btn-back" title="마이페이지로 이동">←</a>
        <a href="/" class="logo">⚡ Finlab Manager</a>
    </div>
</header>

<div class="container">
    <div class="hero" id="hero">
        <span class="hero-badge" id="heroBadge">매니저 모집</span>
        <h1 id="pageTitle">핀랩풋볼 매니저 지원서</h1>
        <p id="pageSubtitle">경기 진행부터 소통까지, 최고의 매치를 만드는 주역이 되어주세요.</p>
    </div>

    <form class="card" id="applyForm">
        <section class="section">
            <h2 class="section-title"><span class="step">1</span>인적 사항</h2>
            <div class="field-row">
                <div class="field">
                    <label class="field-label" for="name">이름 <span class="required">*</span></label>
                    <input class="input" id="name" name="name" type="text" placeholder="홍길동" required>
                </div>
                <div class="field">
                    <label class="field-label" for="birthDate">생년월일 <span class="required">*</span></label>
                    <input class="input" id="birthDate" name="birthDate" type="date" required>
                </div>
            </div>
            <div class="field">
                <label class="field-label" for="phone">휴대전화 번호 <span class="required">*</span></label>
                <input class="input" id="phone" name="phoneNumber" type="tel" placeholder="010-1234-5678" required>
            </div>
            <div class="field">
                <label class="field-label" for="email">이메일 <span class="required">*</span></label>
                <input class="input" id="email" name="email" type="email" placeholder="example@email.com" required>
            </div>
        </section>

        <section class="section">
            <h2 class="section-title"><span class="step">2</span>활동 정보</h2>
            <div class="field-row">
                <div class="field">
                    <label class="field-label" for="region">활동 가능 지역 <span class="required">*</span></label>
                    <select class="select" id="region" name="region" required>
                        <option value="" selected disabled>지역 선택</option>
                        <option>서울</option><option>경기</option><option>인천</option><option>대전</option><option>대구</option><option>부산</option><option>광주</option><option>기타</option>
                    </select>
                </div>
                <div class="field">
                    <label class="field-label" for="experience">풋살 경험 <span class="required">*</span></label>
                    <select class="select" id="experience" name="experience" required>
                        <option value="" selected disabled>경력 선택</option>
                        <option>경험 없음</option><option>1년 미만</option><option>1~3년</option><option>3~5년</option><option>5년 이상</option>
                    </select>
                </div>
            </div>
            <div class="field">
                <label class="field-label" for="motivation">지원 동기 <span class="required">*</span></label>
                <textarea class="textarea" id="motivation" name="motivation" maxlength="1000" placeholder="지원 동기와 매니저로서의 강점을 작성해주세요." required></textarea>
                <p class="help counter"><span id="motivationCount">0</span>/1,000</p>
            </div>
        </section>

        <section class="section">
            <h2 class="section-title"><span class="step">3</span>지원서 첨부</h2>
            <div class="field">
                <label class="field-label" id="fileFieldLabel">이력서 또는 지원서 (PDF / DOCX) <span class="required" id="fileRequiredStar">*</span></label>
                <label class="upload-box" id="uploadBox" for="resume">
                    <span class="upload-text">
                        <strong>PDF 또는 DOCX 파일을 올려주세요</strong>
                        <p>파일을 끌어놓거나 버튼을 눌러 선택하세요.<br>PDF, DOCX 형식 · 최대 10MB</p>
                        <span class="file-button">파일 선택</span>
                    </span>
                </label>
                <input id="resume" name="resume" type="file" accept="application/pdf,application/vnd.openxmlformats-officedocument.wordprocessingml.document,.pdf,.docx" hidden required>
                <div class="file-name" id="fileInfo"><span id="fileName"></span><button class="remove-file" id="removeFile" type="button">×</button></div>
                <p class="error" id="fileError"></p>
            </div>
        </section>

        <div class="agreement">
            <input id="privacy" name="privacyAgreement" type="checkbox" required>
            <label for="privacy">
                <strong>[필수] 개인정보 수집 및 이용에 동의합니다.</strong><br>
                지원자 확인과 채용 절차 진행을 위해 제출한 정보를 수집합니다.
            </label>
        </div>

        <button class="submit" id="btnSubmit" type="submit">매니저 지원서 제출</button>
        <button class="btn-status" type="button" onclick="location.href='/mypage/apply/myapply'">매니저 지원 현황 보기 ›</button>
    </form>

    <section class="complete" id="completeView">
        <div class="complete-icon">✓</div>
        <h2 id="completeTitle">지원서가 접수됐어요</h2>
        <p id="completeDesc">제출해주신 내용을 확인한 후<br>입력한 연락처로 결과를 안내드리겠습니다.</p>
        <button class="home" type="button" onclick="location.href='/mypage'">마이페이지로 이동</button>
        <button class="btn-status" type="button" onclick="location.href='/mypage/apply/myapply'" style="max-width:340px; margin:10px auto 0;">매니저 지원 현황 보기 ›</button>
    </section>
</div>

<script>
    var form = document.getElementById("applyForm");
    var resume = document.getElementById("resume");
    var uploadBox = document.getElementById("uploadBox");
    var fileInfo = document.getElementById("fileInfo");
    var fileName = document.getElementById("fileName");
    var fileError = document.getElementById("fileError");
    var motivation = document.getElementById("motivation");
    var isEditMode = false;

    motivation.addEventListener("input", function() {
        document.getElementById("motivationCount").textContent = motivation.value.length.toLocaleString();
    });

    // 기존 지원 내역 자동 로드 (수정 모드 전환)
    fetch("/api/apply/myapply")
        .then(function(res) {
            if (res.ok) return res.json();
            return null;
        })
        .then(function(data) {
            if (data && data.name) {
                isEditMode = true;
                document.getElementById("heroBadge").textContent = "지원서 수정";
                document.getElementById("pageTitle").textContent = "매니저 지원서 수정";
                document.getElementById("pageSubtitle").textContent = "기존에 작성하신 제출 정보를 수정할 수 있습니다.";
                document.getElementById("btnSubmit").textContent = "지원서 수정 완료";
                document.getElementById("completeTitle").textContent = "지원서가 수정되었어요";

                document.getElementById("name").value = data.name || "";
                document.getElementById("birthDate").value = data.birth || "";
                document.getElementById("phone").value = data["phone-number"] || data.phone_number || "";
                document.getElementById("email").value = data.email || "";
                if (data.activity_region) document.getElementById("region").value = data.activity_region;
                if (data.futsal_experience) document.getElementById("experience").value = data.futsal_experience;
                document.getElementById("motivation").value = data.motivation || "";
                document.getElementById("motivationCount").textContent = (data.motivation || "").length.toLocaleString();

                // 수정 모드에서는 새 파일 첨부가 필수 선택이 아님
                resume.removeAttribute("required");
                document.getElementById("fileRequiredStar").style.display = "none";

                var existingFilePath = data.cv_path || data.pdf_path || "";
                if (existingFilePath) {
                    var existingName = existingFilePath.split('/').pop();
                    fileName.textContent = "기존 첨부: " + existingName + " (변경 시 새 파일 선택)";
                    fileInfo.classList.add("show");
                }
            }
        })
        .catch(function(err) {
            console.log("신규 지원 모드로 진행합니다.");
        });

    function validateFile(file) {
        if (!file) {
            if (isEditMode) return true; // 수정 모드에서는 파일 미선택 허용
            fileError.textContent = "이력서 파일을 선택해 주세요.";
            return false;
        }
        var nameLower = file.name.toLowerCase();
        if (!nameLower.endsWith(".pdf") && !nameLower.endsWith(".docx")) {
            fileError.textContent = "PDF 또는 DOCX 파일만 첨부할 수 있습니다.";
            return false;
        }
        if (file.size > 10 * 1024 * 1024) {
            fileError.textContent = "파일 크기는 최대 10MB까지 가능합니다.";
            return false;
        }
        fileError.textContent = "";
        fileName.textContent = file.name + " · " + (file.size / 1024 / 1024).toFixed(1) + "MB";
        fileInfo.classList.add("show");
        return true;
    }

    resume.addEventListener("change", function() {
        if (resume.files[0]) {
            validateFile(resume.files[0]);
        }
    });

    ["dragenter", "dragover"].forEach(function(type) {
        uploadBox.addEventListener(type, function(e) {
            e.preventDefault();
            uploadBox.classList.add("dragover");
        });
    });

    ["dragleave", "drop"].forEach(function(type) {
        uploadBox.addEventListener(type, function(e) {
            e.preventDefault();
            uploadBox.classList.remove("dragover");
        });
    });

    uploadBox.addEventListener("drop", function(e) {
        const file = e.dataTransfer.files[0];
        if (validateFile(file)) {
            const transfer = new DataTransfer();
            transfer.items.add(file);
            resume.files = transfer.files;
        }
    });

    document.getElementById("removeFile").addEventListener("click", function() {
        resume.value = "";
        fileInfo.classList.remove("show");
        fileError.textContent = "";
        if (!isEditMode) {
            resume.setAttribute("required", "required");
        }
    });

    form.addEventListener("submit", function(e) {
        e.preventDefault();
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }
        if (!isEditMode && !resume.files[0]) {
            fileError.textContent = "이력서 파일을 선택해 주세요.";
            return;
        }
        if (resume.files[0] && !validateFile(resume.files[0])) {
            return;
        }

        var formData = new FormData();
        formData.append("name", document.getElementById("name").value.trim());
        formData.append("birth", document.getElementById("birthDate").value.trim());
        formData.append("phone-number", document.getElementById("phone").value.trim());
        formData.append("email", document.getElementById("email").value.trim());
        formData.append("activity_region", document.getElementById("region").value);
        formData.append("futsal_experience", document.getElementById("experience").value);
        formData.append("motivation", document.getElementById("motivation").value.trim());
        if (resume.files[0]) {
            formData.append("pdf", resume.files[0]);
        }

        fetch("/api/apply", {
            method: "POST",
            body: formData
        })
        .then(function(res) {
            if (!res.ok) throw new Error("지원서 처리 중 실패했습니다.");
            return res.json();
        })
        .then(function(data) {
            if (data && data.success) {
                form.classList.add("hidden");
                document.getElementById("hero").classList.add("hidden");
                document.getElementById("completeView").classList.add("show");
                window.scrollTo(0, 0);
            } else {
                alert("지원서 처리에 실패했습니다. 입력 정보를 확인 후 다시 시도해 주세요.");
            }
        })
        .catch(function(err) {
            console.error("지원서 제출 오류:", err);
            alert("지원서 제출 중 오류가 발생했습니다.");
        });
    });
</script>
</body>
</html>
