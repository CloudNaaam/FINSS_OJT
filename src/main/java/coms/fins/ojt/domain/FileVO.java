package coms.fins.ojt.domain;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.Date;

public class FileVO {

    @JsonProperty("file_uuid")
    private String fileUuid;

    @JsonProperty("original_filename")
    private String originalFilename;

    @JsonProperty("created_at")
    private Date createdAt;

    public FileVO() {}

    public FileVO(String fileUuid, String originalFilename) {
        this.fileUuid = fileUuid;
        this.originalFilename = originalFilename;
    }

    public String getFileUuid() {
        return fileUuid;
    }

    public void setFileUuid(String fileUuid) {
        this.fileUuid = fileUuid;
    }

    public String getOriginalFilename() {
        return originalFilename;
    }

    public void setOriginalFilename(String originalFilename) {
        this.originalFilename = originalFilename;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}
