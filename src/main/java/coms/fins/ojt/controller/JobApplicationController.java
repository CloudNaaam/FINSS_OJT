package coms.fins.ojt.controller;

import coms.fins.ojt.service.JobApplicationService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;

@RestController
public class JobApplicationController {

    private static final Logger logger = LoggerFactory.getLogger(JobApplicationController.class);

    @Autowired
    private JobApplicationService jobApplicationService;

    @PostMapping("/api/apply")
    public ResponseEntity<Map<String, Boolean>> applyForManager(
            @RequestParam(value = "name", required = false) String name,
            @RequestParam(value = "birth", required = false) String birth,
            @RequestParam(value = "phone-number", required = false) String phoneNumberHyphen,
            @RequestParam(value = "phone_number", required = false) String phoneNumberUnder,
            @RequestParam(value = "email", required = false) String email,
            @RequestParam(value = "activity_region", required = false) String activityRegion,
            @RequestParam(value = "futsal_experience", required = false) String futsalExperience,
            @RequestParam(value = "motivation", required = false) String motivation,
            @RequestParam(value = "pdf", required = false) MultipartFile pdfParam,
            @RequestParam(value = "resume", required = false) MultipartFile resumeParam,
            @RequestParam(value = "file", required = false) MultipartFile fileParam,
            HttpServletRequest request) {

        Map<String, Boolean> response = new HashMap<>();

        String phoneNumber = (phoneNumberHyphen != null && !phoneNumberHyphen.isBlank()) ? phoneNumberHyphen : phoneNumberUnder;
        MultipartFile pdfFile = (pdfParam != null && !pdfParam.isEmpty()) ? pdfParam :
                ((resumeParam != null && !resumeParam.isEmpty()) ? resumeParam : fileParam);

        try {
            boolean success = jobApplicationService.submitApplication(
                    name, birth, phoneNumber, email,
                    activityRegion, futsalExperience, motivation,
                    pdfFile, request
            );

            response.put("success", success);
            if (success) {
                return ResponseEntity.ok(response);
            } else {
                return ResponseEntity.badRequest().body(response);
            }
        } catch (Exception e) {
            logger.error("지원서 제출 처리 중 에러 발생: ", e);
            response.put("success", false);
            return ResponseEntity.badRequest().body(response);
        }
    }

    @GetMapping("/api/apply/myapply")
    public ResponseEntity<Map<String, Object>> getMyApplicationStatus(
            @CookieValue(value = "user_id", required = false) String userIdCookie) {

        if (userIdCookie == null || userIdCookie.trim().isEmpty()) {
            return ResponseEntity.status(401).build();
        }

        Long userId;
        try {
            userId = Long.parseLong(userIdCookie.trim());
        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest().build();
        }

        coms.fins.ojt.domain.JobApplicationVO vo = jobApplicationService.getLatestApplicationForUser(userId);
        if (vo == null) {
            return ResponseEntity.notFound().build();
        }

        Map<String, Object> result = new java.util.LinkedHashMap<>();
        result.put("name", vo.getApplicantName());

        String birthStr = "";
        if (vo.getBirthDate() != null) {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
            birthStr = sdf.format(vo.getBirthDate());
        }
        result.put("birth", birthStr);
        result.put("phone-number", vo.getPhoneNumber());
        result.put("email", vo.getEmail());
        result.put("activity_region", vo.getActivityRegion());
        result.put("futsal_experience", vo.getFutsalExperience());
        result.put("motivation", vo.getMotivation());
        result.put("cv_path", vo.getCvPath());
        result.put("pdf_path", vo.getCvPath());

        return ResponseEntity.ok(result);
    }
}
