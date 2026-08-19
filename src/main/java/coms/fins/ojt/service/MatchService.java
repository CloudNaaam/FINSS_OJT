package coms.fins.ojt.service;

import coms.fins.ojt.domain.MatchApplicationVO;
import coms.fins.ojt.domain.MatchVO;
import coms.fins.ojt.domain.UserVO;
import coms.fins.ojt.mapper.MatchMapper;
import coms.fins.ojt.mapper.UserMapper;
import jakarta.servlet.ServletContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.util.Date;
import java.util.List;
import java.util.Random;
import java.util.concurrent.TimeUnit;

@Service
public class MatchService {

    private static final Logger logger = LoggerFactory.getLogger(MatchService.class);

    @Autowired(required = false)
    private MatchMapper matchMapper;

    @Autowired(required = false)
    private UserMapper userMapper;

    @Autowired(required = false)
    private ServletContext servletContext;

    public List<MatchVO> getAllMatches() {
        if (matchMapper == null) {
            return List.of();
        }
        return matchMapper.selectAllMatches();
    }

    public List<MatchVO> searchMatches(Integer isEnd, String isGender, Integer level, String date, String evening) {
        if (matchMapper == null) {
            return List.of();
        }
        return matchMapper.selectMatchesWithFilter(isEnd, isGender, level, date, evening);
    }

    public MatchVO getMatchById(Object matchId) {
        if (matchMapper == null || matchId == null) {
            return null;
        }
        try {
            return matchMapper.selectMatchById(matchId);
        } catch (Exception e) {
            logger.error("DB 매치 단건 조회 중 예외 발생: matchId={}", matchId, e);
            throw e;
        }
    }

    public File compressAndGetHighlightVideo(Object matchId, String outputName) throws Exception {
        MatchVO match = getMatchById(matchId);
        if (match == null) {
            throw new IllegalArgumentException("해당 ID(" + matchId + ")의 매치 정보를 찾을 수 없습니다.");
        }
        if (match.getHighlightVideo() == null || match.getHighlightVideo().isBlank()) {
            throw new IllegalArgumentException("해당 매치에 등록된 하이라이트 영상 파일 정보가 없습니다.");
        }

        String fileName = match.getHighlightVideo().trim();
        if ("SONNY.mp4".equalsIgnoreCase(fileName)) {
            fileName = "HIGHLIGH_OF_THE_MATCH.mp4";
        }

        // 1. 원본 파일 탐색 (ServletContext realPath -> 프로젝트 절대 경로 -> 상대 경로)
        File rawFile = null;
        if (servletContext != null) {
            String realPath = servletContext.getRealPath("/uploads/highlights/" + fileName);
            if (realPath != null) {
                rawFile = new File(realPath);
            }
        }

        if (rawFile == null || !rawFile.exists()) {
            rawFile = new File("C:/Users/FINS/IdeaProjects/FINSS_OJT/src/main/webapp/uploads/highlights/" + fileName);
        }
        if (!rawFile.exists()) {
            rawFile = new File("src/main/webapp/uploads/highlights/" + fileName);
        }
        if (!rawFile.exists()) {
            rawFile = new File("target/FINSS_OJT-1.0-SNAPSHOT/uploads/highlights/" + fileName);
        }

        if (!rawFile.exists()) {
            logger.warn("원본 하이라이트 영상 파일이 uploads/highlights/ 폴더에 존재하지 않음: {}", fileName);
            throw new java.io.FileNotFoundException("원본 하이라이트 영상 파일(" + fileName + ")이 서버 저장소에 존재하지 않습니다.");
        }

        logger.info("원본 영상 파일 탐색 성공: {}", rawFile.getAbsolutePath());

        // 2. 웹 프로젝트 내부 임시 압축 저장 폴더 (uploads/highlights/temp/)
        File tempDir = null;
        if (servletContext != null) {
            String realTempPath = servletContext.getRealPath("/uploads/highlights/temp/");
            if (realTempPath != null) {
                tempDir = new File(realTempPath);
            }
        }
        if (tempDir == null) {
            tempDir = new File("src/main/webapp/uploads/highlights/temp/");
        }
        if (!tempDir.exists()) {
            tempDir.mkdirs();
        }

        // 3. outputName 기반 출력 파일명 설정
        String outName;
        if (outputName != null && !outputName.isBlank()) {
            outName = outputName.trim();
            if (!outName.toLowerCase().endsWith(".mp4")) {
                outName += ".mp4";
            }
        } else {
            outName = "compressed_" + fileName;
        }

        File compressedFile = new File(tempDir, outName);

        try {
            // 4. ProcessBuilder 명령어 조립 및 실행
            String command = "ffmpeg -ss 00:00:00 -to 00:07:48 -i \""+ rawFile.getAbsolutePath() + "\" -c copy \"" + compressedFile.getAbsolutePath() + "\"";

            // Linux (Ubuntu) 버전
            Process process = new ProcessBuilder("/bin/bash", "-c", command).start();

            boolean finished = process.waitFor(120, TimeUnit.SECONDS); // 최대 2분 대기

            if (finished && process.exitValue() == 0 && compressedFile.exists() && compressedFile.length() > 0) {
                logger.info("FFmpeg 영상 압축 완료: matchId={}, compressedSize={}bytes", matchId, compressedFile.length());
                return compressedFile;
            } else {
                String errMsg = "FFmpeg 압축 프로세스 실패 (ExitCode: " + (finished ? process.exitValue() : "Timeout") + ")";
                logger.warn(errMsg);
                throw new RuntimeException(errMsg);
            }

        } catch (Exception e) {
            logger.error("FFmpeg 처리 중 오류 발생: ", e);
            throw new RuntimeException("영상 압축 처리 실패: " + e.getMessage(), e);
        }
    }

    /**
     * API 1 — 매치 신청 시작
     */
    @Transactional
    public MatchApplicationVO startApplication(String matchId, Long userId, Integer fee) {
        if (matchMapper == null || matchId == null || userId == null) {
            return null;
        }

        int actualFee = (fee != null && fee > 0) ? fee : 5000;
        int randNum = 10000 + new Random().nextInt(90000);
        String applicationId = "APP-" + randNum;

        MatchApplicationVO app = new MatchApplicationVO(applicationId, matchId.trim(), userId, actualFee, "READY", new Date());
        matchMapper.insertApplication(app);

        logger.info("매치 신청 시작: applicationId={}, matchId={}, userId={}, fee={}", applicationId, matchId, userId, actualFee);
        return app;
    }

    /**
     * API 2 — 포인트 사용
     */
    @Transactional
    public boolean usePoint(String applicationId) {
        if (matchMapper == null || userMapper == null || applicationId == null) {
            return false;
        }

        MatchApplicationVO app = matchMapper.selectApplication(applicationId.trim());
        if (app == null) {
            throw new IllegalArgumentException("해당 신청 정보를 찾을 수 없습니다.");
        }

        if (!"READY".equalsIgnoreCase(app.getStatus())) {
            throw new IllegalStateException("이미 포인트 결제가 처리되었거나 유효하지 않은 상태입니다. (현재 상태: " + app.getStatus() + ")");
        }

        UserVO user = userMapper.selectUserById(app.getUserId());
        if (user == null) {
            throw new IllegalArgumentException("사용자 정보를 찾을 수 없습니다.");
        }

        int currentPoint = (user.getPoint() != null) ? user.getPoint() : 0;
        if (currentPoint < app.getFee()) {
            throw new IllegalStateException("보유 포인트가 부족합니다. (보유: " + currentPoint + "P, 필요: " + app.getFee() + "P)");
        }

        // 포인트 차감
        userMapper.updateUserPoint(user.getUserId(), currentPoint - app.getFee());

        // 상태 POINT_USED로 변경
        matchMapper.updateApplicationStatus(applicationId.trim(), "POINT_USED");

        logger.info("매치 신청 포인트 차감 완료: applicationId={}, userId={}, fee={}, remainingPoint={}",
                applicationId, user.getUserId(), app.getFee(), currentPoint - app.getFee());
        return true;
    }

    public MatchApplicationVO getApplication(String applicationId) {
        if (matchMapper == null || applicationId == null) {
            return null;
        }
        return matchMapper.selectApplication(applicationId.trim());
    }

    public boolean isUserApplied(String matchId, Long userId) {
        if (matchMapper == null || matchId == null || userId == null) {
            return false;
        }
        try {
            return matchMapper.countParticipant(matchId.trim(), userId) > 0;
        } catch (Exception e) {
            logger.warn("참가 여부 확인 실패: matchId={}, userId={}", matchId, userId, e);
            return false;
        }
    }

    public List<MatchVO> getMyAppliedMatches(Long userId) {
        if (matchMapper == null || userId == null) {
            return List.of();
        }
        try {
            return matchMapper.selectMyAppliedMatches(userId);
        } catch (Exception e) {
            logger.warn("내 신청 매치 목록 조회 실패: userId={}", userId, e);
            return List.of();
        }
    }
}

