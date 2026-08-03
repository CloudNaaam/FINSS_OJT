package coms.fins.ojt.domain;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.Date;

public class EmailVerificationVO {

    @JsonProperty("verification_id")
    private Long verificationId;

    @JsonProperty("user_id")
    private Long userId;

    private String email;

    @JsonProperty("auth_code")
    private String authCode;

    @JsonProperty("expired_at")
    private Date expiredAt;

    private Integer verified;

    @JsonProperty("created_at")
    private Date createdAt;

    public EmailVerificationVO() {}

    public EmailVerificationVO(Long userId, String email, String authCode, Date expiredAt) {
        this.userId = userId;
        this.email = email;
        this.authCode = authCode;
        this.expiredAt = expiredAt;
        this.verified = 0;
    }

    public Long getVerificationId() {
        return verificationId;
    }

    public void setVerificationId(Long verificationId) {
        this.verificationId = verificationId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAuthCode() {
        return authCode;
    }

    public void setAuthCode(String authCode) {
        this.authCode = authCode;
    }

    public Date getExpiredAt() {
        return expiredAt;
    }

    public void setExpiredAt(Date expiredAt) {
        this.expiredAt = expiredAt;
    }

    public Integer getVerified() {
        return verified;
    }

    public void setVerified(Integer verified) {
        this.verified = verified;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}
