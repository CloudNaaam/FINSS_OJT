package coms.fins.ojt.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Date;

public class MatchApplicationVO {

    @JsonProperty("application_id")
    private String applicationId;

    @JsonProperty("match_id")
    private String matchId;

    @JsonProperty("user_id")
    private Long userId;

    private Integer fee;

    private String status;

    @JsonProperty("created_at")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
    private Date createdAt;

    public MatchApplicationVO() {}

    public MatchApplicationVO(String applicationId, String matchId, Long userId, Integer fee, String status, Date createdAt) {
        this.applicationId = applicationId;
        this.matchId = matchId;
        this.userId = userId;
        this.fee = fee;
        this.status = status;
        this.createdAt = createdAt;
    }

    public String getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(String applicationId) {
        this.applicationId = applicationId;
    }

    public String getMatchId() {
        return matchId;
    }

    public void setMatchId(String matchId) {
        this.matchId = matchId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Integer getFee() {
        return fee;
    }

    public void setFee(Integer fee) {
        this.fee = fee;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}
