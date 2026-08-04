package coms.fins.ojt.service;

import coms.fins.ojt.domain.JobApplicationVO;
import coms.fins.ojt.mapper.JobApplicationMapper;
import coms.fins.ojt.util.FileUtil;
import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

@Service
public class JobApplicationService {

    private static final Logger logger = LoggerFactory.getLogger(JobApplicationService.class);

    @org.springframework.beans.factory.annotation.Value("${admin.base.path:C:/Users/FINS/uploads}")
    private String adminBasePath;

    @Autowired(required = false)
    private JobApplicationMapper jobApplicationMapper;

    @Autowired(required = false)
    private coms.fins.ojt.mapper.UserMapper userMapper;

    public JobApplicationVO getLatestApplicationForUser(Long userId) {
        if (userId == null || userMapper == null || jobApplicationMapper == null) {
            return null;
        }

        try {
            coms.fins.ojt.domain.UserVO user = userMapper.selectUserById(userId);
            if (user == null) {
                return null;
            }

            return jobApplicationMapper.selectLatestByEmailOrPhone(user.getEmail(), user.getPhoneNumber());
        } catch (Exception e) {
            logger.error("사용자 지원 내역 조회 오류: userId={}", userId, e);
            return null;
        }
    }

    @Transactional
    public boolean submitApplication(
            String name,
            String birthStr,
            String phoneNumber,
            String email,
            String activityRegion,
            String futsalExperience,
            String motivation,
            MultipartFile pdfFile,
            HttpServletRequest request) {

        if (name == null || name.isBlank() ||
            phoneNameOrBlank(phoneNumber) ||
            email == null || email.isBlank() ||
            activityRegion == null || activityRegion.isBlank() ||
            futsalExperience == null || futsalExperience.isBlank() ||
            motivation == null || motivation.isBlank()) {
            logger.warn("매니저 지원서 필수 항목이 누락되었습니다.");
            return false;
        }

        // 기존 제출 내역이 있는지 조회 (Upsert 판별)
        JobApplicationVO existingVo = null;
        if (jobApplicationMapper != null) {
            existingVo = jobApplicationMapper.selectLatestByEmailOrPhone(email.trim(), phoneNumber.trim());
        }

        boolean hasNewFile = (pdfFile != null && !pdfFile.isEmpty());

        // 신규 신청인데 파일이 없는 경우 실패
        if (existingVo == null && !hasNewFile) {
            logger.warn("신규 지원서 제출 시 이력서 파일 첨부는 필수입니다.");
            return false;
        }

        String cvPath = (existingVo != null) ? existingVo.getCvPath() : null;

        // 새 파일이 첨부된 경우 저장 및 PDF 변환 처리
        if (hasNewFile) {
            String originalFilename = pdfFile.getOriginalFilename();
            String filenameLower = (originalFilename != null) ? originalFilename.toLowerCase() : "";

            boolean isPdf = filenameLower.endsWith(".pdf");
            boolean isDocx = filenameLower.endsWith(".docx");

            if (!isPdf && !isDocx) {
                logger.warn("첨부 파일이 PDF 또는 DOCX 확장자가 아닙니다: {}", originalFilename);
                return false;
            }

            // 매직 바이트 검증
            if (!FileUtil.isValidMagicByte(pdfFile)) {
                logger.warn("첨부 파일의 바이너리 시그니처가 유효하지 않은 문서입니다.");
                return false;
            }

            try {
                // 2. admin.base.path 설정 기반 업로드 폴더 및 어드민 폴더 설정
                String baseUploadPath = (adminBasePath != null && !adminBasePath.isBlank()) ? adminBasePath.trim() : "C:/Users/FINS/uploads";
                Path applyDir = Paths.get(baseUploadPath, "apply");
                Path adminApplyDir = Paths.get(baseUploadPath, "admin", "apply");

                if (!Files.exists(applyDir)) {
                    Files.createDirectories(applyDir);
                }
                if (!Files.exists(adminApplyDir)) {
                    Files.createDirectories(adminApplyDir);
                }

                // 3. 업로드된 원본 파일명 추출 및 안전 정제 (UUID 대신 원본 파일명 사용)
                String rawFilename = pdfFile.getOriginalFilename();
                if (rawFilename == null || rawFilename.isBlank()) {
                    rawFilename = "resume" + (isDocx ? ".docx" : ".pdf");
                }
                String safeOriginalFilename = Paths.get(rawFilename).getFileName().toString().replaceAll("[\\\\/:*?\"<>|]", "_");
                String savedFilename = safeOriginalFilename;
                Path targetPath = applyDir.resolve(savedFilename);
                try (InputStream is = pdfFile.getInputStream()) {
                    Files.copy(is, targetPath, StandardCopyOption.REPLACE_EXISTING);
                }

                // 4. 어드민 전용 폴더에 PDF 저장 (원본명 + .pdf 확장자)
                String baseName = safeOriginalFilename;
                if (safeOriginalFilename.contains(".")) {
                    baseName = safeOriginalFilename.substring(0, safeOriginalFilename.lastIndexOf("."));
                }
                String adminPdfFilename = baseName + ".pdf";
                Path adminPdfPath = adminApplyDir.resolve(adminPdfFilename);
                boolean pdfCopyOk = FileUtil.processAdminPdfCopy(targetPath, adminPdfPath, isDocx);
                if (!pdfCopyOk) {
                    logger.error("어드민 PDF 파일 저장/변환 실패로 지원서 제출 취소");
                    try { Files.deleteIfExists(targetPath); } catch (Exception ignored) {}
                    return false;
                }

                cvPath = "/uploads/apply/" + savedFilename;
            } catch (Exception e) {
                logger.error("이력서 파일 업로드/변환 중 예외 발생:", e);
                return false;
            }
        }

        // 생년월일 날짜 파싱
        Date birthDate = null;
        if (birthStr != null && !birthStr.isBlank()) {
            try {
                SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
                birthDate = formatter.parse(birthStr.trim());
            } catch (Exception e) {
                logger.warn("생년월일 파싱 오류: {}", birthStr);
                birthDate = new Date();
            }
        } else {
            birthDate = new Date();
        }

        try {
            if (existingVo != null) {
                // 기존 지원서 수정 (UPDATE)
                existingVo.setApplicantName(name.trim());
                existingVo.setBirthDate(birthDate);
                existingVo.setPhoneNumber(phoneNumber.trim());
                existingVo.setEmail(email.trim());
                existingVo.setActivityRegion(activityRegion.trim());
                existingVo.setFutsalExperience(futsalExperience.trim());
                existingVo.setMotivation(motivation.trim());
                existingVo.setCvPath(cvPath);

                jobApplicationMapper.updateJobApplication(existingVo);
                logger.info("매니저 지원서 성공적으로 DB 수정(UPDATE) 완료: applicationId={}, applicantName={}", existingVo.getApplicationId(), name);
                return true;
            } else {
                // 신규 지원서 등록 (INSERT)
                JobApplicationVO vo = new JobApplicationVO(
                        name.trim(),
                        birthDate,
                        phoneNumber.trim(),
                        email.trim(),
                        activityRegion.trim(),
                        futsalExperience.trim(),
                        motivation.trim(),
                        cvPath
                );

                jobApplicationMapper.insertJobApplication(vo);
                logger.info("매니저 지원서 성공적으로 DB 등록(INSERT) 완료: applicantName={}, cvPath={}", name, cvPath);
                return true;
            }
        } catch (Exception e) {
            logger.error("매니저 지원서 DB 저장/수정 중 예외 발생:", e);
            return false;
        }
    }

    private boolean phoneNameOrBlank(String phone) {
        return phone == null || phone.isBlank();
    }
}
