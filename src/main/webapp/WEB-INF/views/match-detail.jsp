<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finlab - 매치 상세 정보</title>
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
            --green: #11a767;
            --orange: #ff7534;
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
            padding-bottom: 96px;
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

        .visual-banner {
            position: relative;
            height: 220px;
            overflow: hidden;
            background: #111;
        }

        .visual-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            opacity: 0.85;
        }

        .visual-badge {
            position: absolute;
            bottom: 16px;
            left: 20px;
            padding: 6px 12px;
            border-radius: 6px;
            background: rgba(0, 0, 0, 0.6);
            color: #fff;
            font-size: 12px;
            font-weight: 700;
            backdrop-filter: blur(4px);
        }

        .summary {
            padding: 24px 20px;
            border-bottom: 8px solid #f5f6f8;
        }

        .status-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 12px;
        }

        .status {
            padding: 5px 10px;
            border-radius: 6px;
            background: #e8f8f1;
            color: var(--green);
            font-size: 12px;
            font-weight: 800;
        }

        .summary h1 {
            margin: 0 0 8px;
            font-size: 24px;
            font-weight: 800;
            letter-spacing: -0.8px;
        }

        .summary .match-time {
            margin: 0 0 16px;
            color: var(--blue);
            font-size: 16px;
            font-weight: 700;
        }

        .tags {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            margin-bottom: 20px;
        }

        .tag {
            padding: 6px 10px;
            border-radius: 6px;
            background: #f1f3f5;
            color: #656b74;
            font-size: 11px;
            font-weight: 700;
        }

        .tag.level { background: var(--blue-soft); color: var(--blue); }
        .tag.gender { background: #fff1e8; color: var(--orange); }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1px;
            border: 1px solid var(--line);
            border-radius: 12px;
            background: var(--line);
            overflow: hidden;
        }

        .info {
            padding: 14px 16px;
            background: #fff;
        }

        .info small {
            display: block;
            margin-bottom: 4px;
            color: #979ba4;
            font-size: 11px;
        }

        .info strong {
            font-size: 14px;
            color: var(--ink);
        }

        .section {
            padding: 24px 20px;
            border-bottom: 8px solid #f5f6f8;
        }

        .section h2 {
            margin: 0 0 16px;
            font-size: 18px;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        .video-card {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 18px 20px;
            border-radius: 12px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
        }

        .video-info strong {
            display: block;
            margin-bottom: 4px;
            font-size: 14px;
        }

        .video-info span {
            color: var(--muted);
            font-size: 12px;
        }

        .download-btn {
            padding: 10px 16px;
            border: 0;
            border-radius: 8px;
            background: var(--blue);
            color: #fff;
            font-size: 13px;
            font-weight: 700;
            transition: background .2s;
        }

        .download-btn:hover { background: var(--blue-dark); }

        .rule-list {
            display: grid;
            gap: 16px;
            margin: 0;
            padding: 0;
            list-style: none;
        }

        .rule {
            display: grid;
            grid-template-columns: 36px 1fr;
            gap: 12px;
        }

        .rule-icon {
            display: grid;
            width: 36px;
            height: 36px;
            place-items: center;
            border-radius: 10px;
            background: var(--blue-soft);
            color: var(--blue);
            font-size: 16px;
        }

        .rule strong {
            display: block;
            margin-bottom: 4px;
            font-size: 13px;
        }

        .rule p {
            margin: 0;
            color: var(--muted);
            font-size: 12px;
            line-height: 1.6;
        }

        .apply-bar {
            position: fixed;
            z-index: 30;
            right: 0;
            bottom: 0;
            left: 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            width: min(100%, 768px);
            margin: auto;
            padding: 12px 20px max(12px, env(safe-area-inset-bottom));
            background: rgba(255, 255, 255, .97);
            border-top: 1px solid var(--line);
        }

        .apply-bar .price {
            font-size: 18px;
            font-weight: 800;
            color: var(--blue);
        }

        .apply-btn {
            width: 55%;
            height: 50px;
            border: 0;
            border-radius: 10px;
            background: var(--blue);
            color: #fff;
            font-size: 15px;
            font-weight: 800;
            box-shadow: 0 4px 12px rgba(21, 112, 255, .25);
        }

        .apply-btn:hover { background: var(--blue-dark); }

        .toast {
            position: fixed;
            z-index: 50;
            bottom: 80px;
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
        }

        .toast.show {
            transform: translate(-50%, 0);
            opacity: 1;
        }

        @media (max-width: 600px) {
            body { background: #fff; }
            .page { box-shadow: none; }
            .header { height: 58px; padding: 0 14px; }
            .visual-banner { height: 180px; }
            .summary h1 { font-size: 21px; }
        }
    </style>
</head>
<body>
<div class="page">
    <header class="header">
        <a class="back" href="/" aria-label="메인 매치 목록으로 이동">←</a>
        <a class="brand" href="/">Finlab</a>
    </header>

    <main>
        <!-- 배너 이미지 -->
        <section class="visual-banner">
            <img class="visual-img" id="fieldPhoto" src="/resources/images/ground-default.jpg" alt="구장 전경">
            <span class="visual-badge" id="fieldLocationBadge">경기장 위치</span>
        </section>

        <!-- 매치 개요 -->
        <section class="summary">
            <!-- ⚽ 신청 완료 상태 뱃지 -->
            <div id="appliedNoticeBadge" style="display: none; background: #ecfdf5; border: 1px solid #a7f3d0; color: #065f46; padding: 14px 18px; border-radius: 14px; font-weight: 700; font-size: 14px; margin-bottom: 16px; align-items: center; gap: 8px;">
                <span style="font-size: 18px;">✅</span>
                <span>회원님이 이미 신청 완료(참가 확정)한 매치입니다.</span>
            </div>

            <div class="status-row">
                <span class="status">신청 가능 · 매치 진행 예정</span>
            </div>
            <h1 id="fieldName">불러오는 중...</h1>
            <p class="match-time" id="matchTime">일시 불러오는 중...</p>

            <div class="tags">
                <span class="tag level" id="levelTag">레벨 --</span>
                <span class="tag gender" id="genderTag">성별 --</span>
                <span class="tag" id="membersTag">모집 --명</span>
                <span class="tag">6vs6 풋살</span>
            </div>

            <div class="info-grid">
                <div class="info"><small>경기 방식</small><strong>6vs6 · 3파전</strong></div>
                <div class="info"><small>구장 형태</small><strong>실외 · 인조잔디</strong></div>
                <div class="info"><small>참가비</small><strong style="color:var(--blue)">10,000원</strong></div>
                <div class="info"><small>진행 시간</small><strong>120분</strong></div>
            </div>
        </section>

        <!-- 구장 상세 정보 섹션 (DB ground 테이블 연동) -->
        <section class="section" id="groundSection">
            <h2>🏟️ 구장 정보 & 시설</h2>
            <div style="background: #f8fafc; border: 1px solid var(--line); border-radius: 12px; padding: 18px; margin-bottom: 16px;">
                <div style="display: flex; align-items: flex-start; gap: 8px; margin-bottom: 12px;">
                    <span style="font-size: 18px;">📍</span>
                    <div>
                        <strong style="font-size: 15px; color: var(--ink);" id="groundAddress">주소 정보 불러오는 중...</strong>
                        <div style="font-size: 13px; color: var(--muted); margin-top: 2px;" id="groundRegion">--</div>
                    </div>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; font-size: 13px; border-top: 1px solid var(--line); padding-top: 12px;">
                    <div><span style="color: var(--muted);">구장 크기:</span> <strong id="groundSize">--</strong></div>
                    <div><span style="color: var(--muted);">잔디 종류:</span> <strong id="groundGrass">--</strong></div>
                    <div><span style="color: var(--muted);">실내/실외:</span> <strong id="groundIndoor">--</strong></div>
                    <div><span style="color: var(--muted);">이용 요금:</span> <strong id="groundPrice" style="color: var(--blue);">--</strong></div>
                </div>
            </div>

            <div style="display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 16px;" id="groundAmenities">
                <!-- 편의시설 태그 동적 삽입 -->
            </div>

            <div id="groundNoticeBox" style="display: none; background: #fffbe6; border: 1px solid #ffe58f; padding: 12px 16px; border-radius: 8px; font-size: 13px; color: #d46b08;">
                <strong>📢 구장 안내사항:</strong> <span id="groundNotice"></span>
            </div>
        </section>

        <!-- 하이라이트 영상 섹션 -->
        <section class="section">
            <h2>매치 하이라이트 영상</h2>
            <div class="video-card">
                <div class="video-info">
                    <strong id="videoFileName">하이라이트 영상 (FFmpeg 압축)</strong>
                    <span>원하는 파일명을 입력 후 다운로드하세요.</span>
                </div>
                <div style="display: flex; gap: 8px; align-items: center; flex-wrap: wrap;">
                    <input type="text" id="downloadFileName" value="매치_하이라이트" placeholder="저장할 파일명" style="padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 13px; outline: none;">
                    <button class="download-btn" id="downloadVideoBtn" type="button">영상 다운로드</button>
                </div>
            </div>
        </section>

        <!-- 진행 방식 -->
        <section class="section">
            <h2>매치 진행 수칙</h2>
            <ul class="rule-list">
                <li class="rule">
                    <span class="rule-icon">⚽</span>
                    <div>
                        <strong>개인 참가 후 팀 배정</strong>
                        <p>혼자 신청해도 괜찮아요. 매니저가 실력을 고려해 균등하게 팀을 나눠드립니다.</p>
                    </div>
                </li>
                <li class="rule">
                    <span class="rule-icon">⏱️</span>
                    <div>
                        <strong>3팀 로테이션 경기</strong>
                        <p>두 팀이 경기하는 동안 한 팀은 휴식하며 공평하게 돌아가며 진행합니다.</p>
                    </div>
                </li>
            </ul>
        </section>
    </main>

    <div class="apply-bar">
        <div>
            <small style="color:var(--muted); font-size:11px;">참가비</small>
            <div class="price">5,000 P</div>
        </div>
        <button class="apply-btn" id="applyButton" type="button" onclick="openApplyModal()">매치 신청하기</button>
    </div>
</div>

<!-- ⚽ 매치 신청 단계형 모달 -->
<div id="matchApplyModal" style="display: none; position: fixed; z-index: 100; inset: 0; background: rgba(0,0,0,0.5); backdrop-filter: blur(4px); align-items: center; justify-content: center; padding: 20px;">
    <div style="width: min(100%, 420px); background: #fff; border-radius: 24px; padding: 28px 24px; box-shadow: 0 20px 40px rgba(0,0,0,0.2); position: relative;">

        <!-- 닫기 버튼 -->
        <button type="button" onclick="closeApplyModal()" style="position: absolute; top: 20px; right: 20px; border: 0; background: transparent; font-size: 20px; color: #94a3b8; cursor: pointer;">✕</button>

        <!-- 1단계: 매치 신청 안내 -->
        <div id="applyStep1">
            <div style="font-size: 28px; margin-bottom: 8px;">⚽</div>
            <h3 style="font-size: 20px; font-weight: 800; color: #1e293b; margin: 0 0 6px;">매치 신청</h3>
            <p style="font-size: 13px; color: #64748b; margin: 0 0 20px;">매치 정보를 확인하고 신청을 시작하세요.</p>

            <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 16px; padding: 16px; margin-bottom: 20px;">
                <div style="display: flex; justify-content: space-between; font-size: 14px; color: #64748b; margin-bottom: 8px;">
                    <span>구장명</span>
                    <strong style="color: #1e293b;" id="modalFieldName">핀랩 풋살 파크</strong>
                </div>
                <div style="display: flex; justify-content: space-between; font-size: 14px; color: #64748b; padding-top: 8px; border-top: 1px dashed #cbd5e1;">
                    <span style="font-weight: 700; color: #1e293b;">참가비</span>
                    <strong style="color: var(--blue); font-size: 18px; font-weight: 800;" id="modalFeeText">5,000 P</strong>
                </div>
            </div>

            <button type="button" id="btnStep1" class="apply-btn" style="width: 100%; border-radius: 14px; height: 50px;" onclick="handleStep1Apply()">
                신청하기
            </button>
        </div>

        <!-- 2단계: 포인트 결제 -->
        <div id="applyStep2" style="display: none;">
            <div style="font-size: 28px; margin-bottom: 8px;">💰</div>
            <h3 style="font-size: 20px; font-weight: 800; color: #1e293b; margin: 0 0 6px;">포인트 결제</h3>
            <p style="font-size: 13px; color: #64748b; margin: 0 0 20px;" id="step2AppIdText">신청번호: APP-10001</p>

            <div style="background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 16px; padding: 18px; margin-bottom: 20px; text-align: center;">
                <span style="font-size: 15px; font-weight: 700; color: #166534;" id="step2PointMsg">
                    참가비 5,000P를 사용합니다.
                </span>
            </div>

            <button type="button" id="btnStep2" class="apply-btn" style="width: 100%; border-radius: 14px; height: 50px; background: #16a34a;" onclick="handleStep2Point()">
                결제
            </button>
        </div>

        <!-- 3단계: 신청 완료 -->
        <div id="applyStep3" style="display: none; text-align: center;">
            <div style="font-size: 36px; margin-bottom: 12px;">🎉</div>
            <h3 style="font-size: 20px; font-weight: 800; color: #1e293b; margin: 0 0 6px;">신청 완료</h3>
            <p style="font-size: 15px; font-weight: 600; color: #15803d; margin: 0 0 24px;">매치 신청이 완료되었습니다.</p>

            <button type="button" class="apply-btn" style="width: 100%; border-radius: 14px; height: 50px;" onclick="handleFinishApply()">
                확인
            </button>
        </div>

    </div>
</div>

<div class="toast" id="toast"></div>

<script>
    const matchId = "${matchId}" || window.location.pathname.split("/").pop();
    const fieldName = document.getElementById("fieldName");
    const matchTime = document.getElementById("matchTime");
    const fieldPhoto = document.getElementById("fieldPhoto");
    const fieldLocationBadge = document.getElementById("fieldLocationBadge");
    const levelTag = document.getElementById("levelTag");
    const genderTag = document.getElementById("genderTag");
    const membersTag = document.getElementById("membersTag");
    const videoFileName = document.getElementById("videoFileName");
    const downloadFileName = document.getElementById("downloadFileName");
    const downloadVideoBtn = document.getElementById("downloadVideoBtn");
    const applyButton = document.getElementById("applyButton");
    const toast = document.getElementById("toast");

    let currentApplicationId = null;
    let currentMatchFee = 5000;

    function showToast(msg) {
        toast.textContent = msg;
        toast.classList.add("show");
        setTimeout(function() { toast.classList.remove("show"); }, 2000);
    }

    // 매치 상세 정보 API 호출
    function fetchMatchDetail() {
        if (!matchId) return;

        fetch('/api/matches/' + matchId)
            .then(function(res) {
                if (!res.ok) throw new Error("매치를 찾을 수 없습니다.");
                return res.json();
            })
            .then(function(data) {
                if (!data) return;

                fieldName.textContent = data.field_name || "핀랩 풋살 파크";
                document.getElementById("modalFieldName").textContent = data.field_name || "핀랩 풋살 파크";
                fieldLocationBadge.textContent = data.field_name || "경기장 위치";
                if (data.field_name) {
                    downloadFileName.value = data.field_name.trim().replaceAll(/\s+/g, "_") + "_하이라이트";
                }

                if (data.match_at) {
                    var matchTimeStr = String(data.match_at).replace("T", " ");
                    matchTime.textContent = "📅 " + matchTimeStr;
                } else {
                    matchTime.textContent = "📅 2026.08.20 (수) 19:00";
                }

                levelTag.textContent = "레벨 " + (data.match_level || 5);
                genderTag.textContent = data.gender === "ANY" ? "남녀 모두" : (data.gender === "MALE" ? "남성 매치" : "여성 매치");
                membersTag.textContent = "모집 " + (data.num_members || 12) + "명";

                if (data.highlight_video && data.highlight_video.trim() !== "") {
                    var highlightName = data.highlight_video.trim();
                    if (highlightName === "SONNY.mp4") {
                        highlightName = "HIGHLIGH_OF_THE_MATCH.mp4";
                    }
                    videoFileName.textContent = highlightName;
                    var baseVideoName = highlightName.replace(/\.[^/.]+$/, "");
                    downloadFileName.value = baseVideoName;
                } else {
                    videoFileName.textContent = "하이라이트 영상 (미등록)";
                }

                // --- Ground DB 구장 정보 동적 바인딩 ---
                var fullAddress = (data.address || "") + (data.address_detail ? " " + data.address_detail : "");
                document.getElementById("groundAddress").textContent = fullAddress.trim() || (data.field_name ? data.field_name + " (상세 주소 미등록)" : "주소 정보 미등록");
                document.getElementById("groundRegion").textContent = data.region ? "지역: " + data.region : "지역 정보 없음";
                document.getElementById("groundSize").textContent = data.size_info || "40m x 20m (기본)";
                document.getElementById("groundGrass").textContent = data.grass_type || "인조잔디";
                document.getElementById("groundIndoor").textContent = (data.is_indoor === 1) ? "실내 구장" : "실외 구장";
                document.getElementById("groundPrice").textContent = data.price_per_hour ? (Number(data.price_per_hour).toLocaleString() + "원 / 시간") : "시간당 100,000원";

                // 편의시설 태그 바인딩
                var amenitiesHtml = '';
                if (data.parking_type === 1 || data.parking_type === 0) amenitiesHtml += '<span class="tag" style="background:#e0f2fe; color:#0369a1;">🅿️ 무료 주차 가능</span>';
                if (data.has_shower === 1) amenitiesHtml += '<span class="tag" style="background:#f0fdf4; color:#15803d;">🚿 샤워실 완비</span>';
                if (data.has_lights === 1) amenitiesHtml += '<span class="tag" style="background:#fefce8; color:#a16207;">💡 야간 조명 보유</span>';
                if (data.has_shoes_rental === 1) amenitiesHtml += '<span class="tag" style="background:#fdf2f8; color:#be185d;">👟 풋살화 대여 가능</span>';
                if (data.has_ball_rental === 1) amenitiesHtml += '<span class="tag" style="background:#f5f3ff; color:#6d28d9;">⚽ 풋살공 대여 가능</span>';
                if (!amenitiesHtml) amenitiesHtml = '<span class="tag">기본 편의시설 제공</span>';

                var amenitiesContainer = document.getElementById("groundAmenities");
                if (amenitiesContainer) amenitiesContainer.innerHTML = amenitiesHtml;

                // 구장 공지사항
                if (data.notice && data.notice.trim() !== "") {
                    document.getElementById("groundNotice").textContent = data.notice;
                    document.getElementById("groundNoticeBox").style.display = "block";
                }

                // 신청 완료 여부 확인 및 UI 전환
                if (data.is_applied) {
                    var badge = document.getElementById("appliedNoticeBadge");
                    if (badge) badge.style.display = "flex";
                    applyButton.textContent = "❌ 매치 신청 취소 (환불받기)";
                    applyButton.disabled = false;
                    applyButton.style.background = "#e11d48";
                    applyButton.onclick = handleCancelApply;
                }
            })
            .catch(function(err) {
                console.error("매치 정보 로드 에러:", err);
                fieldName.textContent = "매치 정보를 불러올 수 없습니다.";
            });
    }

    // 파일명 정제 (특수문자 제거 및 공백/점 처리)
    function sanitizeFileName(name) {
        return name
            .replace(/[<>:"/\\|?*\x00-\x1F]/g, "_")
            .replace(/[. ]+$/g, "")
            .slice(0, 100);
    }

    // 영상 다운로드 버튼 클릭
    downloadVideoBtn.addEventListener("click", function() {
        const inputVal = (downloadFileName.value || "").trim();
        const rawName = inputVal || (fieldName.textContent || "매치").trim();
        const safeName = sanitizeFileName(rawName);
        const finalFileName = safeName.toLowerCase().endsWith(".mp4") ? safeName : safeName + ".mp4";
        const encodedName = encodeURIComponent(finalFileName);

        showToast(finalFileName + " 영상 처리 및 다운로드를 진행 중입니다...");

        const downloadUrl = '/api/matches/' + matchId + '/highlight_download?output_name=' + encodedName;

        fetch(downloadUrl)
            .then(function(res) {
                const contentType = res.headers.get("content-type") || "";
                if (contentType.includes("application/json")) {
                    return res.json().then(function(data) {
                        alert(data.error || "영상 처리 중 오류가 발생했습니다.");
                    });
                } else if (res.ok) {
                    return res.blob().then(function(blob) {
                        const url = window.URL.createObjectURL(blob);
                        const a = document.createElement("a");
                        a.href = url;
                        a.download = finalFileName;
                        document.body.appendChild(a);
                        a.click();
                        a.remove();
                        window.URL.revokeObjectURL(url);
                        showToast("영상 다운로드가 완료되었습니다.");
                    });
                } else {
                    alert("영상 다운로드에 실패했습니다. (HTTP " + res.status + ")");
                }
            })
            .catch(function(err) {
                console.error("다운로드 요청 에러:", err);
                alert("다운로드 요청 중 네트워크 오류가 발생했습니다: " + err.message);
            });
    });

    // --- 단계형 매치 신청 모달 컨트롤러 ---
    function openApplyModal() {
        document.getElementById("applyStep1").style.display = "block";
        document.getElementById("applyStep2").style.display = "none";
        document.getElementById("applyStep3").style.display = "none";
        document.getElementById("matchApplyModal").style.display = "flex";
    }

    function closeApplyModal() {
        document.getElementById("matchApplyModal").style.display = "none";
    }

    // 1단계: POST /api/matches/{matchId}/apply (신청 시작)
    function handleStep1Apply() {
        const btn = document.getElementById("btnStep1");
        btn.disabled = true;
        btn.innerText = "신청 주문 생성 중...";

        fetch('/api/matches/' + matchId + '/apply', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' }
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            btn.disabled = false;
            btn.innerText = "신청하기";

            if (data && data.success) {
                currentApplicationId = data.application_id;
                currentMatchFee = data.fee || 5000;

                document.getElementById("step2AppIdText").innerText = "신청번호: " + currentApplicationId;
                document.getElementById("step2PointMsg").innerText = "참가비 " + Number(currentMatchFee).toLocaleString() + "P를 사용합니다.";
                document.getElementById("btnStep2").innerText = Number(currentMatchFee).toLocaleString() + "P 결제";

                // 2단계(포인트 결제) 화면 전환
                document.getElementById("applyStep1").style.display = "none";
                document.getElementById("applyStep2").style.display = "block";
            } else {
                alert("매치 신청 실패: " + (data.message || "오류가 발생했습니다."));
            }
        })
        .catch(function(err) {
            btn.disabled = false;
            btn.innerText = "신청하기";
            alert("신청 요청 중 네트워크 오류가 발생했습니다.");
        });
    }

    // 2단계: POST /api/matches/apply/point (포인트 차감) -> POST /api/matches/apply/complete (완료 처리)
    function handleStep2Point() {
        if (!currentApplicationId) {
            alert("신청 정보가 올바르지 않습니다.");
            return;
        }

        const btn = document.getElementById("btnStep2");
        btn.disabled = true;
        btn.innerText = "포인트 결제 처리 중...";

        // 1) 포인트 차감 요청
        fetch('/api/matches/apply/point', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ application_id: currentApplicationId })
        })
        .then(function(res) { return res.json(); })
        .then(function(pointData) {
            if (pointData && pointData.success) {
                btn.innerText = "참가자 등록 완료 중...";

                // 2) 신청 완료 처리
                return fetch('/api/matches/apply/complete', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ application_id: currentApplicationId })
                });
            } else {
                throw new Error(pointData.message || "포인트 결제에 실패했습니다.");
            }
        })
        .then(function(res) { return res.json(); })
        .then(function(completeData) {
            btn.disabled = false;
            btn.innerText = "결제";

            if (completeData && completeData.success) {
                // 3단계(완료) 화면 전환
                document.getElementById("applyStep2").style.display = "none";
                document.getElementById("applyStep3").style.display = "block";
            } else {
                alert("신청 완료 처리 실패: " + (completeData.message || ""));
            }
        })
        .catch(function(err) {
            btn.disabled = false;
            btn.innerText = Number(currentMatchFee).toLocaleString() + "P 결제";
            alert("결제 처리 오류: " + err.message);
        });
    }

    // 3단계: 확인 클릭 시 모달 닫기 및 버튼 상태 갱신
    function handleFinishApply() {
        closeApplyModal();
        applyButton.textContent = "❌ 매치 신청 취소 (환불받기)";
        applyButton.disabled = false;
        applyButton.style.background = "#e11d48";
        applyButton.onclick = handleCancelApply;
        showToast("매치 신청이 성공적으로 완료되었습니다!");
    }

    function handleCancelApply() {
        if (!confirm("매치 신청을 취소하고 참가비를 환불받으시겠습니까?")) return;
        fetch('/api/matches/cancel', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ match_id: matchId })
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data && data.success) {
                alert(data.message || "매치 신청이 취소되었으며 포인트가 환불되었습니다.");
                location.reload();
            } else {
                alert("매치 취소 실패: " + (data.message || "오류가 발생했습니다."));
            }
        })
        .catch(function(err) {
            alert("취소 요청 중 오류가 발생했습니다: " + err.message);
        });
    }

    document.addEventListener("DOMContentLoaded", fetchMatchDetail);
</script>
</body>
</html>
