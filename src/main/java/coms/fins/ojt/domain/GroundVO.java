package coms.fins.ojt.domain;

import java.util.Date;

public class GroundVO {

    private Long groundId;
    private Long managerId;
    private String name;
    private String address;
    private String addressDetail;
    private String region;
    private String sizeInfo;
    private Integer isIndoor;
    private String grassType;
    private Integer parkingType;
    private Integer hasShower;
    private Integer hasLights;
    private Integer hasShoesRental;
    private Integer hasBallRental;
    private Long pricePerHour;
    private String notice;
    private Date createdAt;

    public GroundVO() {}

    public Long getGroundId() {
        return groundId;
    }

    public void setGroundId(Long groundId) {
        this.groundId = groundId;
    }

    public Long getManagerId() {
        return managerId;
    }

    public void setManagerId(Long managerId) {
        this.managerId = managerId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getAddressDetail() {
        return addressDetail;
    }

    public void setAddressDetail(String addressDetail) {
        this.addressDetail = addressDetail;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public String getSizeInfo() {
        return sizeInfo;
    }

    public void setSizeInfo(String sizeInfo) {
        this.sizeInfo = sizeInfo;
    }

    public Integer getIsIndoor() {
        return isIndoor;
    }

    public void setIsIndoor(Integer isIndoor) {
        this.isIndoor = isIndoor;
    }

    public String getGrassType() {
        return grassType;
    }

    public void setGrassType(String grassType) {
        this.grassType = grassType;
    }

    public Integer getParkingType() {
        return parkingType;
    }

    public void setParkingType(Integer parkingType) {
        this.parkingType = parkingType;
    }

    public Integer getHasShower() {
        return hasShower;
    }

    public void setHasShower(Integer hasShower) {
        this.hasShower = hasShower;
    }

    public Integer getHasLights() {
        return hasLights;
    }

    public void setHasLights(Integer hasLights) {
        this.hasLights = hasLights;
    }

    public Integer getHasShoesRental() {
        return hasShoesRental;
    }

    public void setHasShoesRental(Integer hasShoesRental) {
        this.hasShoesRental = hasShoesRental;
    }

    public Integer getHasBallRental() {
        return hasBallRental;
    }

    public void setHasBallRental(Integer hasBallRental) {
        this.hasBallRental = hasBallRental;
    }

    public Long getPricePerHour() {
        return pricePerHour;
    }

    public void setPricePerHour(Long pricePerHour) {
        this.pricePerHour = pricePerHour;
    }

    public String getNotice() {
        return notice;
    }

    public void setNotice(String notice) {
        this.notice = notice;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}
