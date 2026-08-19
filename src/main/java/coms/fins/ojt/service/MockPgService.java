package coms.fins.ojt.service;

import coms.fins.ojt.domain.MockPgPaymentVO;
import coms.fins.ojt.mapper.MockPgPaymentMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.Random;

@Service
public class MockPgService {

    private static final Logger logger = LoggerFactory.getLogger(MockPgService.class);

    @Autowired
    private MockPgPaymentMapper mockPgPaymentMapper;

    @Transactional
    public MockPgPaymentVO processPayment(String paymentId, Integer amount) {
        if (paymentId == null || paymentId.isBlank() || amount == null || amount <= 0) {
            return null;
        }

        // PG-난수 6자리 트랜잭션 ID 생성 (예: PG-938291)
        int randNum = 100000 + new Random().nextInt(900000);
        String pgTxId = "PG-" + randNum;

        MockPgPaymentVO vo = new MockPgPaymentVO(pgTxId, paymentId.trim(), amount, "PAID", new Date());
        mockPgPaymentMapper.insertMockPgPayment(vo);

        logger.info("Mock PG 결제 승인 완료: pgTxId={}, paymentId={}, amount={}", pgTxId, paymentId, amount);
        return vo;
    }

    public MockPgPaymentVO getPayment(String pgTransactionId) {
        if (pgTransactionId == null || pgTransactionId.isBlank()) {
            return null;
        }
        return mockPgPaymentMapper.selectByPgTransactionId(pgTransactionId.trim());
    }

    public MockPgPaymentVO getPaymentByPaymentId(String paymentId) {
        if (paymentId == null || paymentId.isBlank()) {
            return null;
        }
        return mockPgPaymentMapper.selectByPaymentId(paymentId.trim());
    }
}
