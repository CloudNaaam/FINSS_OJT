package coms.fins.ojt.domain;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.Date;

public class UserVO {
    private Long userId;
    private String username;
    private String password;
    private String name;
    private Integer age;
    private String gender;
    private String email;

    @JsonProperty("phone_number")
    private String phoneNumber;

    private Integer isAdmin;

    @JsonProperty("is_manager")
    private Integer isManager;

    @JsonProperty("profile_img")
    private String profileImg;

    private Date createdAt;

    public UserVO() {}

    public UserVO(String username, String password, String name, Integer age, String gender, String email, String phoneNumber) {
        this.username = username;
        this.password = password;
        this.name = name;
        this.age = age;
        this.gender = gender;
        this.email = email;
        this.phoneNumber = phoneNumber;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public Integer getIsAdmin() {
        return isAdmin;
    }

    public void setIsAdmin(Integer isAdmin) {
        this.isAdmin = isAdmin;
    }

    public Integer getIsManager() {
        return isManager;
    }

    public void setIsManager(Integer isManager) {
        this.isManager = isManager;
    }

    public String getProfileImg() {
        return profileImg;
    }

    public void setProfileImg(String profileImg) {
        this.profileImg = profileImg;
    }

    @JsonProperty("penalty_until")
    private Date penaltyUntil;

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    private Integer point = 1000;

    @JsonProperty("mfa_enabled")
    private Integer mfaEnabled = 0;

    public Date getPenaltyUntil() {
        return penaltyUntil;
    }

    public void setPenaltyUntil(Date penaltyUntil) {
        this.penaltyUntil = penaltyUntil;
    }

    public Integer getPoint() {
        return point;
    }

    public void setPoint(Integer point) {
        this.point = point;
    }

    public Integer getMfaEnabled() {
        return mfaEnabled != null ? mfaEnabled : 0;
    }

    public void setMfaEnabled(Integer mfaEnabled) {
        this.mfaEnabled = mfaEnabled;
    }
}
