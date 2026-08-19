package coms.fins.ojt.mapper;

import coms.fins.ojt.domain.MockPgPaymentVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface MockPgPaymentMapper {

    int insertMockPgPayment(MockPgPaymentVO vo);

    MockPgPaymentVO selectByPgTransactionId(@Param("pgTransactionId") String pgTransactionId);

    MockPgPaymentVO selectByPaymentId(@Param("paymentId") String paymentId);
}
