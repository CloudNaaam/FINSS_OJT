package coms.fins.ojt.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Date;

public class MockPgPaymentVO {

    @JsonProperty("pg_transaction_id")
    private String pgTransactionId;

    @JsonProperty("payment_id")
    private String paymentId;

    private Integer amount;

    private String status;

    @JsonProperty("approved_at")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
    private Date approvedAt;

    public MockPgPaymentVO() {}

    public MockPgPaymentVO(String pgTransactionId, String paymentId, Integer amount, String status, Date approvedAt) {
        this.pgTransactionId = pgTransactionId;
        this.paymentId = paymentId;
        this.amount = amount;
        this.status = status;
        this.approvedAt = approvedAt;
    }

    public String getPgTransactionId() {
        return pgTransactionId;
    }

    public void setPgTransactionId(String pgTransactionId) {
        this.pgTransactionId = pgTransactionId;
    }

    public String getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(String paymentId) {
        this.paymentId = paymentId;
    }

    public Integer getAmount() {
        return amount;
    }

    public void setAmount(Integer amount) {
        this.amount = amount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getApprovedAt() {
        return approvedAt;
    }

    public void setApprovedAt(Date approvedAt) {
        this.approvedAt = approvedAt;
    }
}
