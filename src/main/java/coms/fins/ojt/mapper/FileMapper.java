package coms.fins.ojt.mapper;

import coms.fins.ojt.domain.FileVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface FileMapper {
    int insertFile(@Param("fileUuid") String fileUuid, @Param("originalFilename") String originalFilename);
    FileVO selectFileByUuid(@Param("fileUuid") String fileUuid);
    int deleteFileByUuid(@Param("fileUuid") String fileUuid);
}
