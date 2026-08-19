package coms.fins.ojt.controller;

import coms.fins.ojt.domain.MockPgPaymentVO;
import coms.fins.ojt.domain.PointPaymentVO;
import coms.fins.ojt.mapper.PointPaymentMapper;
import coms.fins.ojt.service.MockPgService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.Map;

@Controller
public class MockPgController {

    @Autowired
    private MockPgService mockPgService;

    @Autowired
    private PointPaymentMapper pointPaymentMapper;

    /**
     * API ② Mock PG 결제 화면
     * GET /mock-pg/pay?payment_id=PAY-20260819-0001
     */
    @GetMapping("/mock-pg/pay")
    public String showMockPgPage(@RequestParam(value = "payment_id", required = false) String paymentId, Model model) {
        int amount = 10000;
        if (paymentId != null && !paymentId.isBlank()) {
            PointPaymentVO payment = pointPaymentMapper.selectByPaymentId(paymentId.trim());
            if (payment != null && payment.getAmount() != null) {
                amount = payment.getAmount();
            }
        }
        model.addAttribute("paymentId", paymentId != null ? paymentId.trim() : "PAY-SAMPLE-0001");
        model.addAttribute("amount", amount);
        return "mock-pg";
    }

    /**
     * API ③ Mock PG 승인 API
     * POST /mock-pg/pay
     * Request: { "payment_id": "PAY-...", "amount": 10000 }
     */
    @PostMapping("/mock-pg/pay")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> processPayment(@RequestBody Map<String, Object> requestData) {
        Map<String, Object> response = new LinkedHashMap<>();

        if (requestData == null) {
            response.put("success", false);
            response.put("message", "요청 데이터가 올바르지 않습니다.");
            return ResponseEntity.badRequest().body(response);
        }

        String paymentId = (String) requestData.get("payment_id");
        Object amountObj = requestData.get("amount");

        if (paymentId == null || paymentId.isBlank() || amountObj == null) {
            response.put("success", false);
            response.put("message", "payment_id 및 amount 정보가 필요합니다.");
            return ResponseEntity.badRequest().body(response);
        }

        int amount;
        try {
            amount = Integer.parseInt(String.valueOf(amountObj).trim());
        } catch (NumberFormatException e) {
            response.put("success", false);
            response.put("message", "amount는 숫자여야 합니다.");
            return ResponseEntity.badRequest().body(response);
        }

        MockPgPaymentVO pgPayment = mockPgService.processPayment(paymentId, amount);

        if (pgPayment != null) {
            response.put("success", true);
            response.put("pg_transaction_id", pgPayment.getPgTransactionId());
            response.put("payment_id", pgPayment.getPaymentId());
            response.put("amount", pgPayment.getAmount());
            response.put("status", pgPayment.getStatus());
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "Mock PG 결제 승인 실패");
            return ResponseEntity.badRequest().body(response);
        }
    }

    /**
     * API ⑤ Mock PG 조회 API
     * GET /mock-pg/api/payments/{pgTransactionId}
     */
    @GetMapping("/mock-pg/api/payments/{pgTransactionId}")
    @ResponseBody
    public ResponseEntity<?> getPaymentDetails(@PathVariable("pgTransactionId") String pgTransactionId) {
        MockPgPaymentVO pgPayment = mockPgService.getPayment(pgTransactionId);
        if (pgPayment == null) {
            Map<String, Object> err = new LinkedHashMap<>();
            err.put("success", false);
            err.put("message", "해당 PG 거래내역을 찾을 수 없습니다.");
            return ResponseEntity.status(404).body(err);
        }

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("pg_transaction_id", pgPayment.getPgTransactionId());
        res.put("payment_id", pgPayment.getPaymentId());
        res.put("amount", pgPayment.getAmount());
        res.put("status", pgPayment.getStatus());
        res.put("approved_at", pgPayment.getApprovedAt());
        return ResponseEntity.ok(res);
    }
}
