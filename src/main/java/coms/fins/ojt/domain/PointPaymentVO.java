package coms.fins.ojt.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Date;

public class PointPaymentVO {

    @JsonProperty("payment_id")
    private String paymentId;

    @JsonProperty("user_id")
    private Long userId;

    private Integer amount;

    private String status;

    @JsonProperty("pg_transaction_id")
    private String pgTransactionId;

    @JsonProperty("point_applied")
    private Integer pointApplied;

    @JsonProperty("created_at")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
    private Date createdAt;

    @JsonProperty("completed_at")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
    private Date completedAt;

    public PointPaymentVO() {}

    public PointPaymentVO(String paymentId, Long userId, Integer amount, String status, String pgTransactionId, Integer pointApplied, Date createdAt, Date completedAt) {
        this.paymentId = paymentId;
        this.userId = userId;
        this.amount = amount;
        this.status = status;
        this.pgTransactionId = pgTransactionId;
        this.pointApplied = pointApplied;
        this.createdAt = createdAt;
        this.completedAt = completedAt;
    }

    public String getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(String paymentId) {
        this.paymentId = paymentId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
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

    public String getPgTransactionId() {
        return pgTransactionId;
    }

    public void setPgTransactionId(String pgTransactionId) {
        this.pgTransactionId = pgTransactionId;
    }

    public Integer getPointApplied() {
        return pointApplied;
    }

    public void setPointApplied(Integer pointApplied) {
        this.pointApplied = pointApplied;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Date completedAt) {
        this.completedAt = completedAt;
    }
}
