package coms.fins.ojt.controller;

import coms.fins.ojt.domain.PointPaymentVO;
import coms.fins.ojt.domain.UserVO;
import coms.fins.ojt.mapper.PointPaymentMapper;
import coms.fins.ojt.mapper.UserMapper;
import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.util.*;

@RestController
@RequestMapping("/api/point")
public class PointController {

    private static final Logger logger = LoggerFactory.getLogger(PointController.class);

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private PointPaymentMapper pointPaymentMapper;

    @Autowired(required = false)
    private coms.fins.ojt.service.MockPgService mockPgService;

    /**
     * 포인트 선물/선송 API (POST /api/point/send)
     * Request Body:
     * {
     *   "send_point": 1000,
     *   "send_to": "받는이름_또는_아이디"
     * }
     * Response Body:
     * {
     *   "success": true / false
     * }
     */
    @PostMapping("/send")
    @Transactional
    public ResponseEntity<Map<String, Object>> sendPoint(
            @RequestBody(required = false) Map<String, Object> requestBody,
            @CookieValue(value = "user_id", required = false) String userIdCookie,
            HttpServletRequest request) {

        Map<String, Object> response = new HashMap<>();

        Long senderId = null;
        if (userIdCookie != null && !userIdCookie.isBlank()) {
            try {
                senderId = Long.parseLong(userIdCookie.trim());
            } catch (NumberFormatException ignored) {}
        }
        if (senderId == null && request.getSession(false) != null) {
            senderId = (Long) request.getSession(false).getAttribute("userId");
        }

        // 1. 로그인 여부 검증
        if (senderId == null) {
            response.put("success", false);
            response.put("message", "로그인이 필요한 서비스입니다.");
            return ResponseEntity.ok(response);
        }

        if (requestBody == null) {
            response.put("success", false);
            response.put("message", "요청 데이터가 올바르지 않습니다.");
            return ResponseEntity.ok(response);
        }

        // 2. Request 파라미터 추출 (send_point, send_to)
        Object pointObj = requestBody.get("send_point");
        String sendTo = (String) requestBody.get("send_to");

        if (pointObj == null || sendTo == null || sendTo.isBlank()) {
            response.put("success", false);
            response.put("message", "보낼 포인트와 받는 사람 이름을 입력해주세요.");
            return ResponseEntity.ok(response);
        }

        int sendPoint;
        try {
            sendPoint = Integer.parseInt(String.valueOf(pointObj).trim());
        } catch (NumberFormatException e) {
            response.put("success", false);
            response.put("message", "포인트는 수치(숫자)로 입력해 주세요.");
            return ResponseEntity.ok(response);
        }

        if (sendPoint <= 0) {
            response.put("success", false);
            response.put("message", "1포인트 이상만 선물할 수 있습니다.");
            return ResponseEntity.ok(response);
        }

        // 3. 보낸 사람(본인) 데이터 및 잔여 포인트 확인
        UserVO sender = userMapper.selectUserById(senderId);
        if (sender == null) {
            response.put("success", false);
            response.put("message", "보내는 사람 정보를 찾을 수 없습니다.");
            return ResponseEntity.ok(response);
        }

        int senderCurrentPoint = (sender.getPoint() != null) ? sender.getPoint() : 0;
        if (senderCurrentPoint < sendPoint) {
            response.put("success", false);
            response.put("message", "보유 포인트가 부족합니다. (현재 보유: " + senderCurrentPoint + " P)");
            return ResponseEntity.ok(response);
        }

        // 4. 받는 사람 유저 데이터 조회 (username 또는 name)
        String targetName = sendTo.trim();
        UserVO receiver = userMapper.findByUsernameOrName(targetName);
        if (receiver == null) {
            response.put("success", false);
            response.put("message", "받는 사람('" + targetName + "') 유저를 찾을 수 없습니다.");
            return ResponseEntity.ok(response);
        }

        if (receiver.getUserId().equals(sender.getUserId())) {
            response.put("success", false);
            response.put("message", "자기 자신에게는 포인트를 보낼 수 없습니다.");
            return ResponseEntity.ok(response);
        }

        // 5. 포인트 이체 트랜잭션 수행
        int receiverCurrentPoint = (receiver.getPoint() != null) ? receiver.getPoint() : 0;

        userMapper.updateUserPoint(sender.getUserId(), senderCurrentPoint - sendPoint);
        userMapper.updateUserPoint(receiver.getUserId(), receiverCurrentPoint + sendPoint);

        logger.info("포인트 선물 완료: senderId={}, receiverId={}, point={}", senderId, receiver.getUserId(), sendPoint);

        response.put("success", true);
        response.put("message", "포인트를 성공적으로 전달했습니다!");
        return ResponseEntity.ok(response);
    }

    /**
     * API ① 포인트 충전 주문 생성
     * POST /api/point/charge/request
     * Request: { "amount": 10000 }
     */
    @PostMapping("/charge/request")
    public ResponseEntity<Map<String, Object>> requestCharge(
            @RequestBody(required = false) Map<String, Object> requestBody,
            @CookieValue(value = "user_id", required = false) String userIdCookie,
            HttpServletRequest request) {

        Map<String, Object> response = new LinkedHashMap<>();

        // 1. 인증된 사용자 ID 판별 (쿠키 우선, JWT fallback)
        Long userId = null;
        if (userIdCookie != null && !userIdCookie.isBlank()) {
            try {
                userId = Long.parseLong(userIdCookie.trim());
            } catch (NumberFormatException ignored) {}
        }
        if (userId == null && request.getSession(false) != null) {
            userId = (Long) request.getSession(false).getAttribute("userId");
        }
        if (userId == null) {
            String authHeader = request.getHeader("Authorization");
            String token = (authHeader != null && authHeader.startsWith("Bearer ")) ? authHeader.substring(7).trim() : request.getParameter("access_token");
            if (token != null && !token.isBlank()) {
                userId = coms.fins.ojt.util.JwtTokenProvider.getUserIdFromToken(token);
            }
        }

        if (userId == null) {
            response.put("success", false);
            response.put("message", "로그인이 필요한 서비스입니다.");
            return ResponseEntity.status(401).body(response);
        }

        // 2. 충전 금액 추출 (기본 10000원)
        int amount = 10000;
        if (requestBody != null && requestBody.get("amount") != null) {
            try {
                amount = Integer.parseInt(String.valueOf(requestBody.get("amount")).trim());
            } catch (NumberFormatException e) {
                response.put("success", false);
                response.put("message", "금액은 숫자여야 합니다.");
                return ResponseEntity.badRequest().body(response);
            }
        }

        if (amount <= 0) {
            response.put("success", false);
            response.put("message", "충전 금액은 1원 이상이어야 합니다.");
            return ResponseEntity.badRequest().body(response);
        }

        // 3. PAY-YYYYMMDD-UUID 주문번호 생성
        String dateStr = new SimpleDateFormat("yyyyMMdd").format(new Date());
        String randomSuffix = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String paymentId = "PAY-" + dateStr + "-" + randomSuffix;

        // 4. point_payment 테이블에 status = 'READY' 로 저장
        PointPaymentVO paymentVO = new PointPaymentVO(paymentId, userId, amount, "READY", null, 0, new Date(), null);
        pointPaymentMapper.insertPayment(paymentVO);

        logger.info("포인트 충전 주문 생성: paymentId={}, userId={}, amount={}", paymentId, userId, amount);

        // 5. 응답 반환
        response.put("success", true);
        response.put("payment_id", paymentId);
        response.put("amount", amount);
        response.put("payment_url", "/mock-pg/pay?payment_id=" + paymentId);

        return ResponseEntity.ok(response);
    }

    /**
     * API ④ FINSS 포인트 지급 완료 처리
     * POST /api/point/charge/complete
     * Request: { "payment_id": "PAY-...", "pg_transaction_id": "...", "amount": 1000000 }
     * [취약점: PG 결제 승인 여부는 검증하지만, 실결제 금액과 충전 금액 대조 누락으로 인한 금액 변조 (Amount Tampering)]
     */
    @PostMapping("/charge/complete")
    public ResponseEntity<Map<String, Object>> completeCharge(
            @RequestBody(required = false) Map<String, Object> request) {

        Map<String, Object> response = new LinkedHashMap<>();

        if (request == null) {
            response.put("success", false);
            response.put("message", "요청 데이터가 올바르지 않습니다.");
            return ResponseEntity.badRequest().body(response);
        }

        String paymentId = request.get("payment_id") != null ? String.valueOf(request.get("payment_id")).trim() : null;
        String pgTransactionId = request.get("pg_transaction_id") != null ? String.valueOf(request.get("pg_transaction_id")).trim() : null;

        if (paymentId == null || paymentId.isBlank()) {
            response.put("success", false);
            response.put("message", "payment_id가 필요합니다.");
            return ResponseEntity.badRequest().body(response);
        }

        PointPaymentVO payment = pointPaymentMapper.selectByPaymentId(paymentId.trim());
        if (payment == null) {
            response.put("success", false);
            response.put("message", "결제 주문 정보를 찾을 수 없습니다.");
            return ResponseEntity.badRequest().body(response);
        }

        // 🛡️ [겉보기 보안 검증]: 실제 PG사 결제 승인 여부 엄격 검증! (결제 건너뛰기 차단)
        if (pgTransactionId == null || pgTransactionId.isBlank()) {
            response.put("success", false);
            response.put("message", "PG 결제 승인 번호(pg_transaction_id)가 필요합니다.");
            return ResponseEntity.badRequest().body(response);
        }

        coms.fins.ojt.domain.MockPgPaymentVO pgPayment = (mockPgService != null) ? mockPgService.getPayment(pgTransactionId) : null;
        if (pgPayment == null || !"PAID".equalsIgnoreCase(pgPayment.getStatus())) {
            response.put("success", false);
            response.put("message", "PG사 결제 승인 내역이 확인되지 않았거나 미결제 상태입니다.");
            return ResponseEntity.badRequest().body(response);
        }

        /*
         * 💥 [취약점 / 비즈니스 로직 결함: 금액 변조 (Amount Tampering)]
         * PG 승인 상태는 정상 검증하였으나, 실제 지급할 포인트는 주문 원본 금액이 아닌
         * 클라이언트 요청 Body의 "amount" 또는 "charged_point" 필드를 1순위로 신뢰하여 반영!
         */
        int chargeAmount = payment.getAmount();
        if (request.containsKey("amount") && request.get("amount") != null) {
            try {
                int customAmount = Integer.parseInt(String.valueOf(request.get("amount")).trim());
                if (customAmount > 0) {
                    chargeAmount = customAmount;
                }
            } catch (Exception ignored) {}
        } else if (request.containsKey("charged_point") && request.get("charged_point") != null) {
            try {
                int customAmount = Integer.parseInt(String.valueOf(request.get("charged_point")).trim());
                if (customAmount > 0) {
                    chargeAmount = customAmount;
                }
            } catch (Exception ignored) {}
        }

        UserVO user = userMapper.selectUserById(payment.getUserId());
        if (user == null) {
            response.put("success", false);
            response.put("message", "사용자 정보를 찾을 수 없습니다.");
            return ResponseEntity.badRequest().body(response);
        }

        int currentPoint = user.getPoint() == null ? 0 : user.getPoint();
        int newPoint = currentPoint + chargeAmount;

        userMapper.updateUserPoint(user.getUserId(), newPoint);
        pointPaymentMapper.updateCompleted(paymentId, pgTransactionId);

        logger.info("포인트 충전 완료 반영 (금액 변조 가능 로직): paymentId={}, userId={}, chargedPoint={}, totalPoint={}",
                paymentId, user.getUserId(), chargeAmount, newPoint);

        response.put("success", true);
        response.put("payment_id", paymentId);
        response.put("charged_point", chargeAmount);
        response.put("total_point", newPoint);

        return ResponseEntity.ok(response);
    }
}

