package coms.fins.ojt.mapper;

import coms.fins.ojt.domain.PointPaymentVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface PointPaymentMapper {

    int insertPayment(PointPaymentVO vo);

    PointPaymentVO selectByPaymentId(@Param("paymentId") String paymentId);

    int updateCompleted(@Param("paymentId") String paymentId, @Param("pgTransactionId") String pgTransactionId);
}
