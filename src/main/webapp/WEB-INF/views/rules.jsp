<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>핀랩풋볼 - 이용약관</title>
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
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            margin: 0;
            background: var(--bg);
            color: var(--ink);
            font-family: "Noto Sans KR", sans-serif;
            word-break: keep-all;
        }

        button, input { font: inherit; }
        button { cursor: pointer; }

        .page {
            width: min(100%, 768px);
            min-height: 100vh;
            margin: 0 auto;
            background: #fff;
            box-shadow: 0 0 30px rgba(20, 26, 36, .05);
            display: flex;
            flex-direction: column;
            padding-bottom: 80px;
        }

        /* 상단 헤더 */
        .header {
            position: sticky;
            z-index: 20;
            top: 0;
            background: rgba(255, 255, 255, .96);
            border-bottom: 1px solid var(--line);
            backdrop-filter: blur(10px);
        }

        .header-main {
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 64px;
            padding: 0 20px;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .btn-back {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            border: 0;
            border-radius: 50%;
            background: transparent;
            color: var(--ink);
            font-size: 20px;
            text-decoration: none;
            transition: background 0.15s ease;
        }

        .btn-back:hover { background: #f4f6f8; }

        .page-title {
            font-size: 18px;
            font-weight: 800;
            color: var(--ink);
        }

        .brand {
            color: var(--blue);
            font-size: 20px;
            font-weight: 900;
            letter-spacing: -1px;
            text-decoration: none;
        }

        /* 본문 컨텐츠 */
        .content {
            padding: 28px 24px;
            flex: 1;
        }

        .terms-header-box {
            margin-bottom: 20px;
            padding-bottom: 16px;
            border-bottom: 2px solid var(--line);
        }

        .terms-title {
            font-size: 22px;
            font-weight: 800;
            color: var(--ink);
            margin: 0 0 8px 0;
        }

        .terms-subtitle {
            font-size: 14px;
            color: var(--muted);
            margin: 0;
            line-height: 1.5;
        }

        /* 조항 바로가기 목차 영역 */
        .toc-container {
            margin-bottom: 32px;
            padding: 16px;
            background: #f8fafc;
            border: 1px solid var(--line);
            border-radius: 14px;
        }

        .toc-title {
            font-size: 14px;
            font-weight: 700;
            color: var(--ink);
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .toc-chips {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .toc-chip {
            display: inline-block;
            padding: 6px 12px;
            background: #fff;
            border: 1px solid #cbd5e1;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            color: #334155;
            text-decoration: none;
            transition: all 0.15s ease;
        }

        .toc-chip:hover {
            border-color: var(--blue);
            color: var(--blue);
            background: var(--blue-soft);
        }

        /* 약관 조항 세부 섹션 */
        .terms-section {
            margin-bottom: 36px;
            padding-top: 12px;
            scroll-margin-top: 80px; /* 상단 헤더 공간 고려 */
        }

        .section-title {
            font-size: 17px;
            font-weight: 700;
            color: var(--ink);
            margin: 0 0 14px 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .section-title::before {
            content: "";
            display: inline-block;
            width: 4px;
            height: 18px;
            background: var(--blue);
            border-radius: 2px;
        }

        .terms-text {
            font-size: 14px;
            line-height: 1.75;
            color: #334155;
            margin: 0 0 10px 0;
        }

        .terms-list {
            margin: 8px 0 0 0;
            padding-left: 20px;
            font-size: 14px;
            line-height: 1.8;
            color: #334155;
        }

        .terms-list li {
            margin-bottom: 8px;
        }

        .highlight-box {
            margin-top: 12px;
            padding: 14px 16px;
            background: var(--blue-soft);
            border-radius: 10px;
            font-size: 13px;
            color: #1e40af;
            line-height: 1.6;
        }

        /* 하단 이동 버튼 */
        .action-area {
            margin-top: 40px;
            text-align: center;
        }

        .btn-confirm {
            display: inline-block;
            width: 100%;
            padding: 16px;
            background: var(--blue);
            color: #fff;
            font-size: 16px;
            font-weight: 700;
            border: 0;
            border-radius: 12px;
            text-decoration: none;
            box-shadow: 0 4px 12px rgba(21, 112, 255, 0.25);
            transition: background 0.15s ease;
        }

        .btn-confirm:hover {
            background: var(--blue-dark);
        }

        /* 하단 모바일 메뉴 */
        .bottom-nav {
            position: fixed;
            z-index: 30;
            right: 0;
            bottom: 0;
            left: 0;
            display: flex;
            width: min(100%, 768px);
            height: 72px;
            margin: auto;
            padding: 8px 12px max(8px, env(safe-area-inset-bottom));
            background: rgba(255, 255, 255, .97);
            border-top: 1px solid var(--line);
        }

        .bottom-nav a {
            display: flex;
            align-items: center;
            flex: 1;
            flex-direction: column;
            gap: 3px;
            color: #9a9ea6;
            font-size: 10px;
            text-decoration: none;
        }

        .bottom-nav span { font-size: 22px; line-height: 1.1; }
        .bottom-nav a.active { color: var(--blue); font-weight: 700; }
    </style>
</head>
<body>
<div class="page">
    <!-- 상단 헤더 -->
    <header class="header">
        <div class="header-main">
            <div class="header-left">
                <a href="/" class="btn-back" aria-label="메인으로 이동">←</a>
                <span class="page-title">이용약관</span>
            </div>
            <a href="/" class="brand">핀랩풋볼</a>
        </div>
    </header>

    <!-- 본문 컨텐츠 -->
    <main class="content">
        <div class="terms-header-box">
            <h1 class="terms-title">핀랩풋볼 서비스 이용약관</h1>
            <p class="terms-subtitle">본 약관은 핀랩풋볼(이하 "회사")이 제공하는 소셜 풋살 매칭 및 구장 예약 서비스 이용과 관련한 제반 사항을 규정합니다.</p>
        </div>

        <!-- 조항 바로가기 (Quick TOC) -->
        <nav class="toc-container" aria-label="약관 조항 바로가기">
            <div class="toc-title">📌 약관 조항 바로가기</div>
            <div class="toc-chips">
                <a href="#section-1" class="toc-chip" onclick="navigateTo('#section-1')">제1조 (목적)</a>
                <a href="#section-2" class="toc-chip" onclick="navigateTo('#section-2')">제2조 (용어정의)</a>
                <a href="#section-3" class="toc-chip" onclick="navigateTo('#section-3')">제3조 (효력 및 변경)</a>
                <a href="#section-4" class="toc-chip" onclick="navigateTo('#section-4')">제4조 (서비스 제공)</a>
                <a href="#section-5" class="toc-chip" onclick="navigateTo('#section-5')">제5조 (회원가입)</a>
                <a href="#section-6" class="toc-chip" onclick="navigateTo('#section-6')">제6조 (매치 예약 및 취소)</a>
                <a href="#section-7" class="toc-chip" onclick="navigateTo('#section-7')">제7조 (구장 이용수칙)</a>
                <a href="#section-8" class="toc-chip" onclick="navigateTo('#section-8')">제8조 (매너 점수)</a>
                <a href="#section-9" class="toc-chip" onclick="navigateTo('#section-9')">제9조 (게시물 관리)</a>
                <a href="#section-10" class="toc-chip" onclick="navigateTo('#section-10')">제10조 (서비스 중단)</a>
                <a href="#section-11" class="toc-chip" onclick="navigateTo('#section-11')">제11조 (개인정보보호)</a>
                <a href="#section-12" class="toc-chip" onclick="navigateTo('#section-12')">제12조 (분쟁 해결)</a>
            </div>
        </nav>

        <!-- 약관 세부 내용 -->
        <section id="section-1" class="terms-section">
            <h2 class="section-title">제 1 조 (목적)</h2>
            <p class="terms-text">
                본 약관은 핀랩풋볼(이하 "회사")이 운영하는 온라인 플랫폼을 통하여 제공하는 소셜 풋살 매치 참여, 경기장 예약 및 커뮤니티 서비스(이하 "서비스")의 이용 조건 및 절차, 회사와 회원 간의 권리·의무 및 책임사항을 규정하는 것을 목적으로 합니다.
            </p>
        </section>

        <section id="section-2" class="terms-section">
            <h2 class="section-title">제 2 조 (용어의 정의)</h2>
            <ol class="terms-list">
                <li><strong>"서비스"</strong>라 함은 단말기(PC, 휴대형 단말기 등의 각종 유무선 장치 포함)를 불문하고 회원이 이용할 수 있는 핀랩풋볼 매치 매칭, 구장 정보 제공, 예약 및 커뮤니티 일체를 의미합니다.</li>
                <li><strong>"회원"</strong>이라 함은 본 약관에 동의하고 회사가 승인한 계정을 생성하여 서비스를 지속적으로 이용하는 자를 의미합니다.</li>
                <li><strong>"매치"</strong>라 함은 회사가 기획하거나 구장 관리자가 개설한 소셜 풋살 및 축구 경기 일정 정보를 의미합니다.</li>
                <li><strong>"매니저"</strong>라 함은 매치 현장에서 경기 진행을 조율하고 안전 수칙 준수 여부를 확인하는 관리 전담 인력을 의미합니다.</li>
            </ol>
        </section>

        <section id="section-3" class="terms-section">
            <h2 class="section-title">제 3 조 (약관의 효력 및 변경)</h2>
            <ol class="terms-list">
                <li>본 약관은 서비스를 이용하고자 하는 모든 회원에 대하여 그 효력을 발생시킵니다.</li>
                <li>회사는 「약관의 규제에 관한 법률」, 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」 등 관련 법령을 위배하지 않는 범위에서 본 약관을 개정할 수 있습니다.</li>
                <li>회사가 약관을 개정할 경우에는 적용일자 및 개정사유를 명시하여 현행약관과 함께 개정약관의 적용일자 7일 전부터 적용일자 전일까지 서비스 공지사항을 통해 고지합니다.</li>
            </ol>
        </section>

        <section id="section-4" class="terms-section">
            <h2 class="section-title">제 4 조 (서비스의 제공 및 변경)</h2>
            <p class="terms-text">
                회사는 다음과 같은 서비스를 제공합니다:
            </p>
            <ol class="terms-list">
                <li>소셜 풋살 매치 참가 신청 및 매칭 서비스</li>
                <li>구장 정보 검색 및 대관 일정 제공 서비스</li>
                <li>게시판 및 회원 간 커뮤니티 기능</li>
                <li>기타 회사가 추가 개발하거나 타사와 제휴를 통해 제공하는 서비스</li>
            </ol>
        </section>

        <section id="section-5" class="terms-section">
            <h2 class="section-title">제 5 조 (회원가입 및 계정 관리)</h2>
            <ol class="terms-list">
                <li>회원가입은 신청자가 약관의 내용에 동의를 하고 회사가 정한 가입 양식에 따라 회원정보를 입력한 후 가입신청을 함으로써 이루어집니다.</li>
                <li>회원은 본인의 계정 정보를 타인에게 양도하거나 대여할 수 없으며, 계정 정보 유출로 인한 불이익은 회원 본인에게 책임이 있습니다.</li>
                <li>타인의 명의나 이메일을 도용하여 가입한 경우 서비스 이용이 즉시 정지되거나 탈퇴 처리될 수 있습니다.</li>
            </ol>
        </section>

        <section id="section-6" class="terms-section">
            <h2 class="section-title">제 6 조 (매치 예약 및 취소/환불)</h2>
            <ol class="terms-list">
                <li>회원은 원하는 시간대와 장소의 매치를 선택하여 참가를 신청할 수 있습니다.</li>
                <li>매치 시작 1시간 전까지 최소 인원 미달 시 매치가 자동 취소되며, 참가가 취소된 회원에게는 개별 안내가 이루어집니다.</li>
                <li>회원 사정으로 인한 참가 취소 시 경기 시작 전 시점에 따라 환불 규정이 차등 적용될 수 있습니다.</li>
            </ol>
        </section>

        <section id="section-7" class="terms-section">
            <h2 class="section-title">제 7 조 (구장 이용 수칙 및 안전관리)</h2>
            <ol class="terms-list">
                <li>회원은 구장별 이용 수칙(풋살화 전용 착용, 음식물 반입 금지, 흡연구역 준수 등)을 철저히 준수해야 합니다.</li>
                <li>경기 중 발생할 수 있는 신체적 부상을 예방하기 위해 준비운동을 필수적으로 실시해야 합니다.</li>
                <li>구장 시설물 훼손 시 원상복구에 필요한 비용이 청구될 수 있습니다.</li>
            </ol>
        </section>

        <section id="section-8" class="terms-section">
            <h2 class="section-title">제 8 조 (매너 점수 및 이용 제한)</h2>
            <p class="terms-text">
                핀랩풋볼은 매너 있는 풋살 문화를 조성하기 위해 매너 카드 및 평가 제도를 운영합니다.
            </p>
            <div class="highlight-box">
                💡 <strong>주요 매너 제재 규정:</strong>
                <ul style="margin: 6px 0 0 0; padding-left: 16px;">
                    <li>무단 불참(노쇼): 1회 적발 시 14일간 매치 신청 제한</li>
                    <li>과격한 거친 플레이 및 욕설: 매니저 경고 후 퇴장 조치 및 서비스 영구 이용 정지</li>
                </ul>
            </div>
        </section>

        <section id="section-9" class="terms-section">
            <h2 class="section-title">제 9 조 (게시물 및 커뮤니티 관리)</h2>
            <ol class="terms-list">
                <li>회원이 서비스 내에 작성한 게시물의 저작권은 해당 회원에게 귀속됩니다.</li>
                <li>음란성, 비방, 광고성, 타인의 권리를 침해하는 게시물은 사전 통보 없이 삭제되거나 게시자의 작성 권한이 제한될 수 있습니다.</li>
            </ol>
        </section>

        <section id="section-10" class="terms-section">
            <h2 class="section-title">제 10 조 (서비스 중단 및 손해배상)</h2>
            <ol class="terms-list">
                <li>천재지변, 점검, 통신 장애 등 불가항력적 사유가 발생한 경우 서비스 제공이 일시적으로 중단될 수 있습니다.</li>
                <li>회사는 고의 또는 중대한 과실이 없는 한 서비스 이용으로 발생한 간접 손해에 대해 책임을 지지 않습니다.</li>
            </ol>
        </section>

        <section id="section-11" class="terms-section">
            <h2 class="section-title">제 11 조 (개인정보보호 및 동의)</h2>
            <p class="terms-text">
                회사는 회원의 개인정보를 보호하기 위해 「개인정보 보호법」 등 관련 법령을 준수하며, 상세한 사항은 개인정보 처리방침에 따릅니다.
            </p>
        </section>

        <section id="section-12" class="terms-section">
            <h2 class="section-title">제 12 조 (분쟁 해결 및 관할 법원)</h2>
            <p class="terms-text">
                본 약관과 관련하여 회사와 회원 간에 발생한 분쟁에 관한 소송은 회사의 본사 소재지를 관할하는 법원을 전속 관할 법원으로 합니다.
            </p>
        </section>

        <div class="action-area">
            <a href="/" class="btn-confirm">확인 및 홈으로 이동</a>
        </div>
    </main>

    <!-- 하단 모바일 네비게이션 -->
    <nav class="bottom-nav" aria-label="하단 메뉴">
        <a href="/"><span>⚽</span>매치</a>
        <a href="/board"><span>📋</span>게시판</a>
        <a href="/mypage"><span>●</span>MY</a>
    </nav>
</div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    function navigateTo(hashVal) {
        location.hash = hashVal; // location.hash 입력값 검증 없이 직접 설정
        scrollToHash();
    }

    function scrollToHash() {
        var hashTarget = decodeURIComponent(location.hash.slice(1));
        var targetElem = document.querySelector($(hashTarget));
        // var targetElem = $($.escapeSelector(hashTarget));
        if (targetElem.length) {
            targetElem[0].scrollIntoView({ behavior: 'smooth' });
        }

    }

    $(window).on('hashchange', scrollToHash);

    $(document).ready(function() {
        scrollToHash();
    });
</script></body>
</html>
