<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FINSS PAY - 안전 결제</title>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Pretendard:wght@400;500;600;700;800&display=swap");

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            background: #f1f5f9;
            font-family: "Pretendard", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
            color: #1e293b;
        }

        .pg-card {
            width: 100%;
            max-width: 440px;
            background: #ffffff;
            border-radius: 24px;
            box-shadow: 0 20px 40px -15px rgba(15, 23, 42, 0.15), 0 0 0 1px rgba(15, 23, 42, 0.05);
            overflow: hidden;
        }

        .pg-header {
            background: linear-gradient(135deg, #1e40af, #3b82f6);
            color: #ffffff;
            padding: 28px 24px;
            text-align: center;
            position: relative;
        }

        .pg-logo {
            font-size: 24px;
            font-weight: 900;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-bottom: 6px;
        }

        .pg-subtitle {
            font-size: 13px;
            opacity: 0.85;
            font-weight: 500;
        }

        .pg-body {
            padding: 28px 24px;
        }

        .order-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 18px;
            margin-bottom: 24px;
        }

        .order-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 14px;
            margin-bottom: 8px;
            color: #64748b;
        }

        .order-row:last-child {
            margin-bottom: 0;
            padding-top: 10px;
            border-top: 1px dashed #cbd5e1;
        }

        .order-row.total {
            font-size: 16px;
            font-weight: 700;
            color: #0f172a;
        }

        .order-row.total .price {
            color: #2563eb;
            font-size: 20px;
            font-weight: 800;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-label {
            display: block;
            font-size: 13px;
            font-weight: 700;
            color: #334155;
            margin-bottom: 6px;
        }

        .form-input {
            width: 100%;
            height: 48px;
            padding: 0 16px;
            border: 1px solid #cbd5e1;
            border-radius: 12px;
            font-size: 15px;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
            font-family: inherit;
        }

        .form-input:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .btn-pay {
            width: 100%;
            height: 52px;
            background: #2563eb;
            color: #ffffff;
            border: none;
            border-radius: 14px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s, transform 0.1s;
            margin-top: 8px;
            box-shadow: 0 6px 16px rgba(37, 99, 235, 0.25);
        }

        .btn-pay:hover {
            background: #1d4ed8;
        }

        .btn-pay:active {
            transform: scale(0.98);
        }

        .btn-pay:disabled {
            background: #94a3b8;
            cursor: not-allowed;
            box-shadow: none;
        }

        .security-badge {
            margin-top: 20px;
            text-align: center;
            font-size: 12px;
            color: #94a3b8;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }
    </style>
</head>
<body>

<div class="pg-card">
    <div class="pg-header">
        <div class="pg-logo">
            <span>💳</span> FINSS PAY
        </div>
        <div class="pg-subtitle">안전한 전자결제 서비스</div>
    </div>

    <div class="pg-body">
        <div class="order-box">
            <div class="order-row">
                <span>상품명</span>
                <span style="font-weight: 600; color: #334155;">포인트 충전</span>
            </div>
            <div class="order-row">
                <span>주문번호</span>
                <span style="font-family: monospace; font-size: 13px;">${paymentId}</span>
            </div>
            <div class="order-row total">
                <span>결제금액</span>
                <span class="price"><fmt:formatNumber value="${amount}" pattern="#,###"/>원</span>
            </div>
        </div>

        <form id="mockPgForm">
            <input type="hidden" id="paymentId" value="${paymentId}">
            <input type="hidden" id="amount" value="${amount}">

            <div class="form-group">
                <label class="form-label" for="cardNumber">카드번호</label>
                <input type="text" id="cardNumber" class="form-input" value="1111-2222-3333-4444" placeholder="0000-0000-0000-0000" required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="cardExpiry">유효기간</label>
                    <input type="text" id="cardExpiry" class="form-input" value="12/30" placeholder="MM/YY" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="cardCvc">CVC</label>
                    <input type="password" id="cardCvc" class="form-input" value="123" maxlength="3" placeholder="3자리" required>
                </div>
            </div>

            <button type="submit" id="btnSubmit" class="btn-pay">
                <fmt:formatNumber value="${amount}" pattern="#,###"/>원 결제하기
            </button>
        </form>

        <div class="security-badge">
            <span>🔒 256-bit SSL 암호화 결제 보안 적용</span>
        </div>
    </div>
</div>

<script>
    document.getElementById('mockPgForm').addEventListener('submit', function(e) {
        e.preventDefault();

        const btnSubmit = document.getElementById('btnSubmit');
        const paymentId = document.getElementById('paymentId').value;
        const amount = parseInt(document.getElementById('amount').value, 10);

        btnSubmit.disabled = true;
        btnSubmit.innerText = '결제 승인 처리 중...';

        // 1단계: Mock PG 결제 승인 API 호출 (POST /mock-pg/pay)
        fetch('/mock-pg/pay', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                payment_id: paymentId,
                amount: amount
            })
        })
        .then(function(res) { return res.json(); })
        .then(function(pgData) {
            if (pgData && pgData.success) {
                btnSubmit.innerText = '포인트 충전 반영 중...';

                // 2단계: FINSS 결제 완료 및 포인트 지급 API 호출 (POST /api/point/charge/complete)
                return fetch('/api/point/charge/complete', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        payment_id: paymentId,
                        pg_transaction_id: pgData.pg_transaction_id
                    })
                });
            } else {
                throw new Error(pgData.message || 'Mock PG 결제 승인에 실패했습니다.');
            }
        })
        .then(function(res) { return res.json(); })
        .then(function(completeData) {
            if (completeData && completeData.success) {
                alert('🎉 포인트 ' + Number(completeData.charged_point || amount).toLocaleString() + 'P 충전이 성공적으로 완료되었습니다!');
                window.location.href = '/mypage';
            } else {
                alert('결제는 완료되었으나 포인트 반영에 실패했습니다: ' + (completeData.message || ''));
                window.location.href = '/mypage';
            }
        })
        .catch(function(err) {
            console.error('결제 오류:', err);
            alert('결제 처리 중 오류가 발생했습니다: ' + err.message);
            btnSubmit.disabled = false;
            btnSubmit.innerText = Number(amount).toLocaleString() + '원 결제하기';
        });
    });
</script>

</body>
</html>
