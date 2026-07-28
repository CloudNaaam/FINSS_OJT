package coms.fins.ojt.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Date;

public class MatchVO {

    @JsonProperty("match_id")
    private Long matchId;

    @JsonProperty("field_name")
    private String fieldName;

    @JsonProperty("field_photo")
    private String fieldPhoto;

    @JsonProperty("match_at")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
    private Date matchAt;

    @JsonProperty("created_at")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
    private Date createdAt;

    @JsonProperty("match_level")
    private Integer matchLevel;

    @JsonProperty("gender")
    private String gender;

    @JsonProperty("num_members")
    private Integer numMembers;

    public Long getMatchId() {
        return matchId;
    }

    public void setMatchId(Long matchId) {
        this.matchId = matchId;
    }

    public String getFieldName() {
        return fieldName;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    public String getFieldPhoto() {
        return fieldPhoto;
    }

    public void setFieldPhoto(String fieldPhoto) {
        this.fieldPhoto = fieldPhoto;
    }

    public Date getMatchAt() {
        return matchAt;
    }

    public void setMatchAt(Date matchAt) {
        this.matchAt = matchAt;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Integer getMatchLevel() {
        return matchLevel;
    }

    public void setMatchLevel(Integer matchLevel) {
        this.matchLevel = matchLevel;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Integer getNumMembers() {
        return numMembers;
    }

    public void setNumMembers(Integer numMembers) {
        this.numMembers = numMembers;
    }
}
