<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>구장 관리자 파트너 센터 - 핀랩풋볼</title>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800;900&display=swap");

        * { box-sizing: border-box; }

        :root {
            --brand-primary: #0f172a;
            --brand-accent: #10b981;
            --brand-accent-hover: #059669;
            --blue: #1570ff;
            --blue-soft: #eaf3ff;
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
            word-break: keep-all;
        }

        button, input, select, textarea { font: inherit; }
        button { cursor: pointer; }

        .app-container {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Top Header */
        .admin-header {
            position: sticky;
            top: 0;
            z-index: 100;
            background: rgba(15, 23, 42, 0.95);
            backdrop-filter: blur(12px);
            color: #fff;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            height: 68px;
            padding: 0 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .brand-logo {
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            color: #fff;
        }

        .brand-badge {
            background: linear-gradient(135deg, #10b981, #059669);
            color: #fff;
            font-size: 11px;
            font-weight: 800;
            padding: 4px 8px;
            border-radius: 6px;
            letter-spacing: 0.5px;
        }

        .brand-title {
            font-size: 20px;
            font-weight: 900;
            letter-spacing: -1px;
        }

        .header-nav {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .btn-main-link {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 8px 14px;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.12);
            color: #e2e8f0;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
        }

        .btn-main-link:hover {
            background: rgba(255, 255, 255, 0.22);
            color: #fff;
        }

        /* Main Content Layout */
        .admin-body {
            max-width: 1200px;
            width: 100%;
            margin: 0 auto;
            padding: 28px 24px 60px;
            flex: 1;
        }

        .welcome-banner {
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            color: #fff;
            border-radius: 20px;
            padding: 28px 32px;
            margin-bottom: 28px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.2);
            position: relative;
            overflow: hidden;
        }

        .welcome-banner::after {
            content: '🏟️';
            position: absolute;
            right: 20px;
            bottom: -20px;
            font-size: 140px;
            opacity: 0.08;
            pointer-events: none;
        }

        .welcome-text h1 {
            margin: 0 0 8px;
            font-size: 24px;
            font-weight: 800;
        }

        .welcome-text p {
            margin: 0;
            color: #94a3b8;
            font-size: 14px;
        }

        .btn-register-stadium {
            display: flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: #fff;
            border: 0;
            border-radius: 12px;
            padding: 12px 22px;
            font-size: 14px;
            font-weight: 700;
            box-shadow: 0 4px 14px rgba(16, 185, 129, 0.35);
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .btn-register-stadium:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.45);
        }

        /* Stats Section */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            margin-bottom: 28px;
        }

        .stat-card {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 20px;
            border: 1px solid var(--line);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.02);
        }

        .stat-label {
            font-size: 13px;
            color: var(--muted);
            font-weight: 600;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .stat-value {
            font-size: 26px;
            font-weight: 900;
            color: var(--ink);
        }

        .stat-change {
            font-size: 12px;
            font-weight: 700;
            color: var(--brand-accent);
            margin-top: 4px;
        }

        /* Section Tabs & Card Lists */
        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 18px;
        }

        .section-title {
            font-size: 18px;
            font-weight: 800;
            margin: 0;
        }

        .stadium-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 20px;
        }

        .stadium-card {
            background: var(--card-bg);
            border: 1px solid var(--line);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .stadium-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.08);
        }

        .stadium-thumb {
            width: 100%;
            height: 180px;
            object-fit: cover;
            background: #cbd5e1;
        }

        .stadium-body {
            padding: 20px;
        }

        .stadium-tags {
            display: flex;
            gap: 6px;
            margin-bottom: 10px;
        }

        .stadium-tag {
            font-size: 11px;
            font-weight: 700;
            padding: 4px 8px;
            border-radius: 6px;
            background: #f1f5f9;
            color: #475569;
        }

        .stadium-tag.active {
            background: #dcfce7;
            color: #15803d;
        }

        .stadium-name {
            font-size: 18px;
            font-weight: 800;
            margin: 0 0 6px;
        }

        .stadium-address {
            font-size: 13px;
            color: var(--muted);
            margin-bottom: 16px;
        }

        .stadium-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-top: 14px;
            border-top: 1px solid var(--line);
        }

        .stadium-price {
            font-size: 15px;
            font-weight: 800;
            color: var(--blue);
        }

        .btn-edit-stadium {
            padding: 7px 14px;
            border-radius: 8px;
            border: 1px solid #cbd5e1;
            background: #fff;
            font-size: 12px;
            font-weight: 700;
            color: #334155;
        }

        .btn-edit-stadium:hover {
            background: #f8fafc;
            border-color: #94a3b8;
        }

        /* Modal Styles */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 200;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .modal-card {
            background: #fff;
            width: min(100%, 540px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            animation: modalFadeUp 0.25s ease-out;
        }

        @keyframes modalFadeUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .modal-header {
            padding: 20px 24px;
            background: #f8fafc;
            border-bottom: 1px solid var(--line);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .modal-header h3 {
            margin: 0;
            font-size: 18px;
            font-weight: 800;
        }

        .btn-close-modal {
            border: 0;
            background: transparent;
            font-size: 20px;
            color: var(--muted);
        }

        .modal-body {
            padding: 24px;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .form-group label {
            font-size: 13px;
            font-weight: 700;
            color: #334155;
        }

        .form-control {
            padding: 10px 14px;
            border-radius: 10px;
            border: 1px solid #cbd5e1;
            font-size: 14px;
            outline: none;
            transition: border-color 0.2s;
        }

        .form-control:focus {
            border-color: var(--brand-accent);
        }

        .modal-footer {
            padding: 16px 24px;
            background: #f8fafc;
            border-top: 1px solid var(--line);
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .btn-cancel {
            padding: 10px 18px;
            border-radius: 10px;
            border: 1px solid #cbd5e1;
            background: #fff;
            font-size: 14px;
            font-weight: 700;
            color: #475569;
        }

        .btn-submit {
            padding: 10px 22px;
            border-radius: 10px;
            border: 0;
            background: var(--brand-accent);
            color: #fff;
            font-size: 14px;
            font-weight: 700;
        }

        .btn-submit:hover {
            background: var(--brand-accent-hover);
        }

        @media (max-width: 768px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .welcome-banner {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
            }
        }
    </style>
</head>
<body>
<div class="app-container">
    <!-- Top Header -->
    <header class="admin-header">
        <div class="header-content">
            <a href="/gm" class="brand-logo">
                <span class="brand-title">Finlab</span>
                <span class="brand-badge">구장 파트너</span>
            </a>
            <div class="header-nav">
                <a href="/" class="btn-main-link">
                    <span>⚽ 메인 서비스로 이동</span>
                </a>
            </div>
        </div>
    </header>

    <!-- Main Content Body -->
    <div class="admin-body">
        <!-- Welcome Banner -->
        <div class="welcome-banner">
            <div class="welcome-text">
                <h1>⚽ 구장 관리자 파트너 센터</h1>
                <p>등록된 구장의 예약 현황을 실시간으로 확인하고 손쉽게 시설을 등록·관리하세요.</p>
            </div>
            <button class="btn-register-stadium" onclick="location.href='/gm/add'">
                <span>➕ 구장 신규 등록</span>
            </button>
        </div>



        <!-- Stadium List Section -->
        <div class="section-header">
            <h2 class="section-title">내 구장 목록</h2>
        </div>

        <div class="stadium-grid" id="stadium-grid">
            <div style="grid-column: 1 / -1; padding: 40px 0; text-align: center; color: #94a3b8;">
                내 구장 목록을 불러오는 중입니다...
            </div>
        </div>
    </div>
</div>

<script>
    function loadMyGrounds() {
        fetch('/api/ground/my')
            .then(function(res) {
                if (res.status === 401) {
                    alert('로그인이 필요합니다. 로그인 후 이용해 주세요.');
                    window.location.href = '/login';
                    return null;
                }
                return res.json();
            })
            .then(function(grounds) {
                if (!grounds) return;
                var grid = document.getElementById('stadium-grid');
                if (!grounds || grounds.length === 0) {
                    grid.innerHTML = 
                        '<div style="grid-column: 1 / -1; padding: 50px 20px; text-align: center; background: #fff; border: 1px dashed #cbd5e1; border-radius: 16px;">' +
                            '<div style="font-size: 40px; margin-bottom: 12px;">🏟️</div>' +
                            '<h3 style="margin: 0 0 8px; font-size: 16px; font-weight: 700; color: #334155;">등록된 구장이 없습니다</h3>' +
                            '<p style="margin: 0 0 16px; font-size: 13px; color: #64748b;">신규 구장을 등록하여 서비스를 시작해 보세요.</p>' +
                            '<button onclick="location.href=\'/gm/add\'" style="padding: 10px 18px; border: 0; border-radius: 8px; background: #10b981; color: #fff; font-weight: 700; font-size: 13px; cursor: pointer;">➕ 구장 신규 등록하기</button>' +
                        '</div>';
                    return;
                }

                var html = '';
                grounds.forEach(function(g) {
                    var isIndoorStr = (g.isIndoor === 1) ? '실내 구장' : ((g.isIndoor === 2) ? '천막/그늘막' : '야외 구장');
                    var photoUrl = 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=600&auto=format&fit=crop&q=80';

                    html += '<div class="stadium-card">' +
                                '<img src="' + photoUrl + '" alt="' + (g.name || '구장') + '" class="stadium-thumb">' +
                                '<div class="stadium-body">' +
                                    '<div class="stadium-tags">' +
                                        '<span class="stadium-tag active">● 정상 운영중</span>' +
                                        '<span class="stadium-tag">' + (g.grassType || '인조잔디') + '</span>' +
                                        '<span class="stadium-tag">' + isIndoorStr + '</span>' +
                                    '</div>' +
                                    '<h3 class="stadium-name">' + (g.name || '구장명') + '</h3>' +
                                    '<div class="stadium-address">📍 ' + (g.address || '') + ' ' + (g.addressDetail || '') + '</div>' +
                                    '<div class="stadium-footer">' +
                                        '<div class="stadium-price">' + (g.pricePerHour ? g.pricePerHour.toLocaleString() : 0) + '원 <small style="font-weight: normal; color: #888;">/ 시간</small></div>' +
                                        '<button class="btn-edit-stadium" onclick="location.href=\'/gm/mod?ground_id=' + g.groundId + '\'">정보 수정</button>' +
                                    '</div>' +
                                '</div>' +
                            '</div>';
                });

                grid.innerHTML = html;
            })
            .catch(function(err) {
                console.error('내 구장 목록 불러오기 오류:', err);
            });
    }

    document.addEventListener('DOMContentLoaded', loadMyGrounds);
</script>
</body>
</html>
