<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finlab - 매니저 지원 현황</title>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap");
        * { box-sizing:border-box; }
        :root { --blue:#1570ff; --blue-dark:#0758d7; --blue-soft:#eaf3ff; --ink:#22252b; --muted:#80858f; --line:#eceef2; --bg:#f3f5f7; --green:#11a767; --orange:#ff8a34; }
        body { margin:0; background:var(--bg); color:var(--ink); font-family:"Noto Sans KR",sans-serif; word-break:keep-all; }
        button { font:inherit; cursor:pointer; }
        .page { width:min(100%,768px); min-height:100vh; margin:0 auto; background:#fff; box-shadow:0 0 30px rgba(20,26,36,.05); }
        .header { position:sticky; z-index:20; top:0; display:grid; grid-template-columns:50px 1fr 50px; align-items:center; height:64px; padding:0 12px; background:rgba(255,255,255,.96); border-bottom:1px solid var(--line); backdrop-filter:blur(10px); }
        .header h1 { margin:0; text-align:center; font-size:17px; }
        .back { display:grid; width:40px; height:40px; place-items:center; border-radius:50%; color:var(--ink); font-size:24px; text-decoration:none; }
        .back:hover { background:#f4f6f8; }
        .content { padding:30px 24px 70px; }
        .status-card { display:flex; align-items:center; justify-content:space-between; gap:20px; padding:24px; border-radius:15px; background:linear-gradient(135deg,#146af0,#4b98ff); color:#fff; }
        .status-card small { display:block; margin-bottom:7px; color:rgba(255,255,255,.72); font-size:11px; }
        .status-card h2 { margin:0 0 6px; font-size:22px; }
        .status-card p { margin:0; color:rgba(255,255,255,.77); font-size:11px; }
        .status-badge { flex:0 0 auto; padding:9px 13px; border-radius:20px; background:rgba(255,255,255,.18); font-size:12px; font-weight:800; }
        .progress { display:grid; grid-template-columns:repeat(3,1fr); margin:24px 0 31px; }
        .progress-item { position:relative; text-align:center; color:#a0a4ac; font-size:11px; }
        .progress-item::before { position:absolute; z-index:0; top:14px; right:50%; left:-50%; height:2px; background:#e4e7eb; content:""; }
        .progress-item:first-child::before { display:none; }
        .progress-item.done::before,.progress-item.active::before { background:var(--blue); }
        .dot { position:relative; z-index:1; display:grid; width:30px; height:30px; margin:0 auto 7px; place-items:center; border:2px solid #dfe3e8; border-radius:50%; background:#fff; color:#a0a4ac; font-size:10px; font-weight:800; }
        .done .dot,.active .dot { border-color:var(--blue); background:var(--blue); color:#fff; }
        .active { color:var(--blue); font-weight:700; }
        .section { margin-top:30px; }
        .section-head { display:flex; align-items:center; justify-content:space-between; margin-bottom:15px; }
        .section h2 { margin:0; font-size:18px; letter-spacing:-.5px; }
        .btn-edit { padding:7px 14px; border:1px solid var(--blue); border-radius:8px; background:#fff; color:var(--blue); font-size:12px; font-weight:700; text-decoration:none; transition:.2s; }
        .btn-edit:hover { background:var(--blue-soft); }
        .info-card { overflow:hidden; border:1px solid var(--line); border-radius:13px; }
        .info-grid { display:grid; grid-template-columns:1fr 1fr; }
        .info { min-height:80px; padding:16px 18px; border-bottom:1px solid var(--line); }
        .info:nth-child(odd) { border-right:1px solid var(--line); }
        .info:nth-last-child(-n+2) { border-bottom:0; }
        .info small { display:block; margin-bottom:7px; color:#989ca4; font-size:10px; }
        .info strong { font-size:13px; font-weight:600; }
        .motivation { padding:19px; border:1px solid var(--line); border-radius:13px; color:#555b64; font-size:13px; line-height:1.85; white-space:pre-line; background:#fff; }
        .file-card { display:flex; align-items:center; justify-content:space-between; gap:15px; padding:18px 20px; border:1px solid var(--line); border-radius:13px; background:#fafbfc; }
        .file-info { display:flex; align-items:center; gap:12px; min-width:0; }
        .file-icon { display:grid; width:42px; height:46px; flex:0 0 auto; place-items:center; border-radius:8px; background:var(--blue-soft); color:var(--blue); font-size:12px; font-weight:900; }
        .file-details { min-width:0; }
        .file-details strong { display:block; overflow:hidden; font-size:13px; font-weight:700; text-overflow:ellipsis; white-space:nowrap; }
        .file-details small { color:var(--muted); font-size:11px; }
        .btn-download { padding:10px 16px; border:1px solid var(--blue); border-radius:8px; background:var(--blue); color:#fff; font-size:12px; font-weight:700; text-decoration:none; flex:0 0 auto; transition:.2s; }
        .btn-download:hover { background:var(--blue-dark); }
        .notice { margin-top:28px; padding:15px 17px; border-radius:10px; background:var(--blue-soft); color:#56759c; font-size:11px; line-height:1.7; }
        .no-data-card { display:flex; flex-direction:column; align-items:center; justify-content:center; padding:80px 24px; border:2px dashed var(--line); border-radius:16px; background:#fafbfc; text-align:center; margin-top:30px; }
        .btn-apply-now { margin-top:20px; padding:12px 24px; border:0; border-radius:10px; background:var(--blue); color:#fff; font-size:14px; font-weight:700; text-decoration:none; }
        @media(max-width:600px){ body{background:#fff}.page{box-shadow:none}.header{height:58px}.content{padding:22px 18px 55px}.status-card{align-items:flex-start;flex-direction:column}.info-grid{grid-template-columns:1fr}.info,.info:nth-child(odd),.info:nth-last-child(-n+2){border-right:0;border-bottom:1px solid var(--line)}.info:last-child{border-bottom:0}.file-card{flex-direction:column;align-items:flex-start}.btn-download{width:100%;text-align:center} }
    </style>
</head>
<body>
<div class="page">
    <header class="header">
        <a class="back" href="/mypage" aria-label="마이페이지로 이동">←</a>
        <h1>매니저 지원 현황</h1>
        <span></span>
    </header>

    <main class="content">
        <!-- 데이터가 존재하는 경우 표시 영역 -->
        <div id="dataContainer">
            <section class="status-card">
                <div>
                    <small>접수 상태</small>
                    <h2>서류 검토 중</h2>
                    <p>제출해주신 매니저 지원서를 확인하고 있습니다.</p>
                </div>
                <span class="status-badge">검토 중</span>
            </section>

            <div class="progress">
                <div class="progress-item done"><span class="dot">✓</span>지원 완료</div>
                <div class="progress-item active"><span class="dot">2</span>서류 검토</div>
                <div class="progress-item"><span class="dot">3</span>결과 안내</div>
            </div>

            <section class="section">
                <div class="section-head">
                    <h2>지원자 정보</h2>
                    <a href="/mypage/apply" class="btn-edit">수정하기</a>
                </div>
                <div class="info-card">
                    <div class="info-grid">
                        <div class="info"><small>이름</small><strong id="applicantName">불러오는 중...</strong></div>
                        <div class="info"><small>생년월일</small><strong id="birthDate">불러오는 중...</strong></div>
                        <div class="info"><small>휴대전화</small><strong id="phone">불러오는 중...</strong></div>
                        <div class="info"><small>이메일</small><strong id="email">불러오는 중...</strong></div>
                        <div class="info"><small>활동 가능 지역</small><strong id="region">불러오는 중...</strong></div>
                        <div class="info"><small>풋살 경험</small><strong id="experience">불러오는 중...</strong></div>
                    </div>
                </div>
            </section>

            <section class="section">
                <div class="section-head"><h2>지원 동기</h2></div>
                <div class="motivation" id="motivation">불러오는 중...</div>
            </section>

            <section class="section">
                <div class="section-head"><h2>첨부 서류</h2></div>
                <div class="file-card">
                    <div class="file-info">
                        <div class="file-icon" id="fileExtIcon">FILE</div>
                        <div class="file-details">
                            <strong id="fileNameDisplay">첨부 파일 불러오는 중...</strong>
                            <small>제출된 이력서 / 지원서 파일</small>
                        </div>
                    </div>
                    <button type="button" class="btn-download" id="filePreviewBtn">이력서 미리보기</button>
                </div>
            </section>

            <aside class="notice">
                지원 내용 수정은 서류 검토 단계 전까지만 가능합니다. 수정이 필요하신 경우 상단의 [수정하기] 버튼을 이용해 주세요.
            </aside>
        </div>

        <!-- 데이터가 없는 경우 안내 카드 -->
        <div class="no-data-card" id="noDataContainer" style="display: none;">
            <div style="font-size: 48px; margin-bottom: 16px;">🏃</div>
            <h2 style="font-size: 20px; margin: 0 0 8px;">제출된 매니저 지원서가 없습니다</h2>
            <p style="color: var(--muted); font-size: 13px; margin: 0;">핀랩풋볼 매니저에 도전하고 현장을 이끌어가 보세요!</p>
            <a href="/mypage/apply" class="btn-apply-now">매니저 지원하기</a>
        </div>
    </main>
</div>

<script>
    function fetchMyApplication() {
        fetch('/api/apply/myapply')
            .then(function(res) {
                if (res.status === 401) {
                    location.href = '/login';
                    return null;
                }
                if (res.status === 404) {
                    document.getElementById('dataContainer').style.display = 'none';
                    document.getElementById('noDataContainer').style.display = 'flex';
                    return null;
                }
                if (!res.ok) throw new Error('지원서 정보를 불러올 수 없습니다.');
                return res.json();
            })
            .then(function(data) {
                if (!data) return;

                document.getElementById('applicantName').textContent = data.name || "-";
                document.getElementById('birthDate').textContent = data.birth || "-";
                document.getElementById('phone').textContent = data["phone-number"] || data.phone_number || "-";
                document.getElementById('email').textContent = data.email || "-";
                document.getElementById('region').textContent = data.activity_region || "-";
                document.getElementById('experience').textContent = data.futsal_experience || "-";
                document.getElementById('motivation').textContent = data.motivation || "-";

                var filePath = data.cv_path || data.pdf_path || "";
                if (filePath) {
                    var filename = filePath.split('/').pop() || "첨부서류";
                    document.getElementById('fileNameDisplay').textContent = filename;

                    var ext = filename.split('.').pop().toUpperCase();
                    if (ext) {
                        document.getElementById('fileExtIcon').textContent = ext;
                    }

                    // PDF 미리보기 URL 생성 (admin/apply/ 아래의 PDF 파일)
                    var baseName = filename;
                    if (filename.indexOf('.') !== -1) {
                        baseName = filename.substring(0, filename.lastIndexOf('.'));
                    }
                    var previewPdfUrl = "/uploads/admin/apply/" + encodeURIComponent(baseName) + ".pdf";

                    document.getElementById('filePreviewBtn').onclick = function() {
                        window.open(previewPdfUrl, '_blank');
                    };
                } else {
                    document.getElementById('fileNameDisplay').textContent = "첨부된 파일 없음";
                    document.getElementById('filePreviewBtn').style.display = "none";
                }
            })
            .catch(function(err) {
                console.error('지원서 현황 로드 오류:', err);
                document.getElementById('dataContainer').style.display = 'none';
                document.getElementById('noDataContainer').style.display = 'flex';
            });
    }

    document.addEventListener('DOMContentLoaded', fetchMyApplication);
</script>
</body>
</html>
