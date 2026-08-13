<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>신규 구장 등록 - 핀랩풋볼 파트너 센터</title>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800;900&display=swap");

        * { box-sizing: border-box; }

        :root {
            --brand-accent: #10b981;
            --brand-accent-hover: #059669;
            --ink: #1e293b;
            --muted: #64748b;
            --line: #e2e8f0;
            --bg: #f8fafc;
            --card-bg: #ffffff;
        }

        body {
            margin: 0;
            background: var(--bg);
            color: var(--ink);
            font-family: "Noto Sans KR", sans-serif;
        }

        button, input, select, textarea { font: inherit; }

        .container {
            max-width: 680px;
            margin: 40px auto 80px;
            padding: 0 20px;
        }

        .header-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }

        .header-title {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .header-title h1 {
            font-size: 22px;
            font-weight: 800;
            margin: 0;
        }

        .btn-back {
            color: var(--muted);
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
        }

        .form-card {
            background: var(--card-bg);
            border: 1px solid var(--line);
            border-radius: 20px;
            padding: 32px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.03);
        }

        .form-section-title {
            font-size: 16px;
            font-weight: 800;
            margin: 0 0 16px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f1f5f9;
            color: #0f172a;
        }

        .form-grid {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        label {
            font-size: 13px;
            font-weight: 700;
            color: #334155;
        }

        .required-star {
            color: #ef4444;
            margin-left: 2px;
        }

        input[type="text"], input[type="number"], select, textarea {
            width: 100%;
            padding: 12px 14px;
            border-radius: 10px;
            border: 1px solid #cbd5e1;
            font-size: 14px;
            outline: none;
            transition: border-color 0.2s;
        }

        input:focus, select:focus, textarea:focus {
            border-color: var(--brand-accent);
        }

        .checkbox-group {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 12px;
            margin-top: 4px;
        }

        .checkbox-label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            padding: 10px 14px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
        }

        .checkbox-label input {
            width: 18px;
            height: 18px;
            accent-color: var(--brand-accent);
        }

        .btn-submit {
            width: 100%;
            padding: 14px;
            margin-top: 10px;
            border: 0;
            border-radius: 12px;
            background: var(--brand-accent);
            color: #fff;
            font-size: 16px;
            font-weight: 800;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(16, 185, 129, 0.3);
            transition: background 0.2s;
        }

        .btn-submit:hover {
            background: var(--brand-accent-hover);
        }

        @media (max-width: 600px) {
            .container { margin: 20px auto 40px; }
            .form-card { padding: 20px; }
            .form-row { grid-template-columns: 1fr; }
            .checkbox-group { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header-bar">
        <div class="header-title">
            <span>🏟️</span>
            <h1>신규 구장 등록</h1>
        </div>
        <a href="/gm" class="btn-back">← 구장 목록으로</a>
    </div>

    <form id="addForm" onsubmit="submitForm(event)">
        <!-- 💡 세션 CSRF 토큰 직접 주입 -->
        <input type="hidden" name="csrfToken" id="csrfToken" value="${sessionScope.CSRF_TOKEN}">
        <div class="form-card">
            <!-- 1. 기본 및 위치 정보 -->
            <div class="form-section-title">📍 구장 위치 및 기본 정보</div>
            <div class="form-grid">
                <div class="form-group">
                    <label for="name">구장 이름 <span class="required-star">*</span></label>
                    <input type="text" id="name" placeholder="예: 강남 핀랩 풋살 파크 A구장" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="address">도로명 주소 <span class="required-star">*</span></label>
                        <input type="text" id="address" placeholder="예: 서울 서초구 강남대로 39길 12" required>
                    </div>
                    <div class="form-group">
                        <label for="address_detail">상세 주소</label>
                        <input type="text" id="address_detail" placeholder="예: 루프탑 4층">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="region">지역 구분</label>
                        <input type="text" id="region" placeholder="예: 서울 서초구">
                    </div>
                    <div class="form-group">
                        <label for="size_info">구장 규격 및 추천 인원</label>
                        <input type="text" id="size_info" placeholder="예: 40m x 20m (6대6)">
                    </div>
                </div>
            </div>

            <br><br>

            <!-- 2. 구장 시설 사양 -->
            <div class="form-section-title">⚡ 시설 사양 및 서비스 옵션</div>
            <div class="form-grid">
                <div class="form-row">
                    <div class="form-group">
                        <label for="is_indoor">실내/실외 구분</label>
                        <select id="is_indoor">
                            <option value="0">야외 구장</option>
                            <option value="1">실내 구장</option>
                            <option value="2">천막 / 그늘막 구장</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="grass_type">잔디 종류</label>
                        <select id="grass_type">
                            <option value="인조잔디">인조잔디</option>
                            <option value="천연잔디">천연잔디</option>
                            <option value="우레탄">우레탄/마루</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="parking_type">주차 조건</label>
                    <select id="parking_type">
                        <option value="1">무료 주차 가능</option>
                        <option value="2">유료 주차 가능</option>
                        <option value="0">주차 불가</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>부대시설 및 대여 가능 서비스</label>
                    <div class="checkbox-group">
                        <label class="checkbox-label">
                            <input type="checkbox" id="has_shower" value="1" checked> 🚿 샤워실 보유
                        </label>
                        <label class="checkbox-label">
                            <input type="checkbox" id="has_lights" value="1" checked> 💡 야간 조명 설치
                        </label>
                        <label class="checkbox-label">
                            <input type="checkbox" id="has_shoes_rental" value="1"> 👟 풋살화 대여 가능
                        </label>
                        <label class="checkbox-label">
                            <input type="checkbox" id="has_ball_rental" value="1" checked> ⚽ 공/조끼 대여 가능
                        </label>
                    </div>
                </div>
            </div>

            <br><br>

            <!-- 3. 가격 및 주의사항 -->
            <div class="form-section-title">💰 가격 및 이용 수칙</div>
            <div class="form-grid">
                <div class="form-group">
                    <label for="price_per_hour">시간당 대여 가격 (원) <span class="required-star">*</span></label>
                    <input type="number" id="price_per_hour" placeholder="예: 85000" required>
                </div>

                <div class="form-group">
                    <label for="notice">이용 안내 및 수칙</label>
                    <textarea id="notice" rows="4" placeholder="구장 이용 시 준수사항, 주차 등록 방법 등을 입력하세요."></textarea>
                </div>

                <button type="submit" class="btn-submit">➕ 구장 신규 등록하기</button>
            </div>
        </div>
    </form>
</div>

<script>
    function escapeXml(unsafe) {
        if (!unsafe) return '';
        return unsafe.replace(/[<>&'"]/g, function (c) {
            switch (c) {
                case '<': return '&lt;';
                case '>': return '&gt;';
                case '&': return '&amp;';
                case '\'': return '&apos;';
                case '"': return '&quot;';
            }
        });
    }

    function submitForm(e) {
        e.preventDefault();

        var name = document.getElementById('name').value;
        var address = document.getElementById('address').value;
        var addressDetail = document.getElementById('address_detail').value;
        var region = document.getElementById('region').value;
        var sizeInfo = document.getElementById('size_info').value;
        var isIndoor = document.getElementById('is_indoor').value;
        var grassType = document.getElementById('grass_type').value;
        var parkingType = document.getElementById('parking_type').value;

        var hasShower = document.getElementById('has_shower').checked ? 1 : 0;
        var hasLights = document.getElementById('has_lights').checked ? 1 : 0;
        var hasShoesRental = document.getElementById('has_shoes_rental').checked ? 1 : 0;
        var hasBallRental = document.getElementById('has_ball_rental').checked ? 1 : 0;

        var pricePerHour = document.getElementById('price_per_hour').value;
        var notice = document.getElementById('notice').value;

        var xmlPayload = 
            '<?xml version="1.0" encoding="UTF-8"?>\n' +
            '<ground>\n' +
            '    <name>' + escapeXml(name) + '</name>\n' +
            '    <address>' + escapeXml(address) + '</address>\n' +
            '    <address_detail>' + escapeXml(addressDetail) + '</address_detail>\n' +
            '    <region>' + escapeXml(region) + '</region>\n' +
            '    <size_info>' + escapeXml(sizeInfo) + '</size_info>\n' +
            '    <is_indoor>' + isIndoor + '</is_indoor>\n' +
            '    <grass_type>' + escapeXml(grassType) + '</grass_type>\n' +
            '    <parking_type>' + parkingType + '</parking_type>\n' +
            '    <has_shower>' + hasShower + '</has_shower>\n' +
            '    <has_lights>' + hasLights + '</has_lights>\n' +
            '    <has_shoes_rental>' + hasShoesRental + '</has_shoes_rental>\n' +
            '    <has_ball_rental>' + hasBallRental + '</has_ball_rental>\n' +
            '    <price_per_hour>' + (pricePerHour || 0) + '</price_per_hour>\n' +
            '    <notice>' + escapeXml(notice) + '</notice>\n' +
            '</ground>';

        var csrfVal = document.getElementById('csrfToken') ? document.getElementById('csrfToken').value : '';

        fetch('/api/ground/add', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/xml; charset=UTF-8',
                'X-CSRF-TOKEN': csrfVal
            },
            body: xmlPayload
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.success) {
                alert('신규 구장이 성공적으로 등록되었습니다!');
                window.location.href = '/gm';
            } else {
                alert('구장 등록 실패: ' + (data.message || '입력 정보를 확인해 주세요.'));
            }
        })
        .catch(function(err) {
            console.error('구장 등록 에러:', err);
            alert('요청 처리 중 오류가 발생했습니다. (' + err.message + ')');
        });
    }
</script>
</body>
</html>
