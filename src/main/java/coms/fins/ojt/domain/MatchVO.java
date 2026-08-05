package coms.fins.ojt.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Date;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class MatchVO {

    @JsonProperty("match_id")
    private Long matchId;

    @JsonProperty("field_name")
    private String fieldName;

    @JsonProperty("highlight_video")
    private String highlightVideo;

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

    // --- Ground 상세 정보 추가 ---
    @JsonProperty("address")
    private String address;

    @JsonProperty("address_detail")
    private String addressDetail;

    @JsonProperty("region")
    private String region;

    @JsonProperty("size_info")
    private String sizeInfo;

    @JsonProperty("is_indoor")
    private Integer isIndoor;

    @JsonProperty("grass_type")
    private String grassType;

    @JsonProperty("parking_type")
    private Integer parkingType;

    @JsonProperty("has_shower")
    private Integer hasShower;

    @JsonProperty("has_lights")
    private Integer hasLights;

    @JsonProperty("has_shoes_rental")
    private Integer hasShoesRental;

    @JsonProperty("has_ball_rental")
    private Integer hasBallRental;

    @JsonProperty("price_per_hour")
    private Integer pricePerHour;

    @JsonProperty("notice")
    private String notice;

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

    public String getHighlightVideo() {
        return highlightVideo;
    }

    public void setHighlightVideo(String highlightVideo) {
        this.highlightVideo = highlightVideo;
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

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getAddressDetail() { return addressDetail; }
    public void setAddressDetail(String addressDetail) { this.addressDetail = addressDetail; }

    public String getRegion() { return region; }
    public void setRegion(String region) { this.region = region; }

    public String getSizeInfo() { return sizeInfo; }
    public void setSizeInfo(String sizeInfo) { this.sizeInfo = sizeInfo; }

    public Integer getIsIndoor() { return isIndoor; }
    public void setIsIndoor(Integer isIndoor) { this.isIndoor = isIndoor; }

    public String getGrassType() { return grassType; }
    public void setGrassType(String grassType) { this.grassType = grassType; }

    public Integer getParkingType() { return parkingType; }
    public void setParkingType(Integer parkingType) { this.parkingType = parkingType; }

    public Integer getHasShower() { return hasShower; }
    public void setHasShower(Integer hasShower) { this.hasShower = hasShower; }

    public Integer getHasLights() { return hasLights; }
    public void setHasLights(Integer hasLights) { this.hasLights = hasLights; }

    public Integer getHasShoesRental() { return hasShoesRental; }
    public void setHasShoesRental(Integer hasShoesRental) { this.hasShoesRental = hasShoesRental; }

    public Integer getHasBallRental() { return hasBallRental; }
    public void setHasBallRental(Integer hasBallRental) { this.hasBallRental = hasBallRental; }

    public Integer getPricePerHour() { return pricePerHour; }
    public void setPricePerHour(Integer pricePerHour) { this.pricePerHour = pricePerHour; }

    public String getNotice() { return notice; }
    public void setNotice(String notice) { this.notice = notice; }
}
