package coms.fins.ojt.domain;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Date;

public class JobApplicationVO {

    @JsonProperty("application_id")
    private Long applicationId;

    @JsonProperty("applicant_name")
    private String applicantName;

    @JsonProperty("birth_date")
    private Date birthDate;

    @JsonProperty("phone_number")
    private String phoneNumber;

    @JsonProperty("email")
    private String email;

    @JsonProperty("activity_region")
    private String activityRegion;

    @JsonProperty("futsal_experience")
    private String futsalExperience;

    @JsonProperty("motivation")
    private String motivation;

    @JsonProperty("cv_path")
    private String cvPath;

    @JsonProperty("created_at")
    private Date createdAt;

    public JobApplicationVO() {}

    public JobApplicationVO(String applicantName, Date birthDate, String phoneNumber, String email,
                            String activityRegion, String futsalExperience, String motivation, String cvPath) {
        this.applicantName = applicantName;
        this.birthDate = birthDate;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.activityRegion = activityRegion;
        this.futsalExperience = futsalExperience;
        this.motivation = motivation;
        this.cvPath = cvPath;
    }

    public Long getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(Long applicationId) {
        this.applicationId = applicationId;
    }

    public String getApplicantName() {
        return applicantName;
    }

    public void setApplicantName(String applicantName) {
        this.applicantName = applicantName;
    }

    public Date getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(Date birthDate) {
        this.birthDate = birthDate;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getActivityRegion() {
        return activityRegion;
    }

    public void setActivityRegion(String activityRegion) {
        this.activityRegion = activityRegion;
    }

    public String getFutsalExperience() {
        return futsalExperience;
    }

    public void setFutsalExperience(String futsalExperience) {
        this.futsalExperience = futsalExperience;
    }

    public String getMotivation() {
        return motivation;
    }

    public void setMotivation(String motivation) {
        this.motivation = motivation;
    }

    public String getCvPath() {
        return cvPath;
    }

    public void setCvPath(String cvPath) {
        this.cvPath = cvPath;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}
