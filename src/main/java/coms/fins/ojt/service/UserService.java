package coms.fins.ojt.service;

import coms.fins.ojt.domain.EmailVerificationVO;
import coms.fins.ojt.domain.UserVO;
import coms.fins.ojt.mapper.EmailVerificationMapper;
import coms.fins.ojt.mapper.UserMapper;
import coms.fins.ojt.util.EmailUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.Random;

@Service
public class UserService {

    private static final Logger logger = LoggerFactory.getLogger(UserService.class);

    @Autowired(required = false)
    private UserMapper userMapper;

    @Autowired(required = false)
    private EmailVerificationMapper emailVerificationMapper;

    @Transactional
    public boolean registerUser(UserVO user) {
        if (user == null || user.getUsername() == null || user.getUsername().isBlank()
                || user.getPassword() == null || user.getPassword().isBlank()) {
            return false;
        }

        if (userMapper == null) {
            return false;
        }

        try {
            int exists = userMapper.checkUsernameExists(user.getUsername());
            if (exists > 0) {
                return false;
            }

            int result = userMapper.insertUser(user);
            return result > 0;

        } catch (Exception e) {
            logger.error("회원가입 처리 중 오류 발생:", e);
            return false;
        }
    }

    public UserVO loginUser(String username, String password) {
        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            return null;
        }

        if (userMapper == null) {
            return null;
        }

        try {
            int count = userMapper.loginRaw(username, password);
            if (count > 0) {
                return userMapper.findByUsername(username.trim());
            }
            return null;
        } catch (Exception e) {
            logger.error("로그인 처리 중 오류 발생:", e);
            return null;
        }
    }

    @Transactional
    public boolean sendFindPwCode(String username, String email) {
        if (username == null || username.isBlank() || email == null || email.isBlank()) {
            return false;
        }

        if (userMapper == null) {
            return false;
        }

        try {
            // 1. DB에서 username 과 email 이 매칭되는 회원의 user_id 조회
            Long userId = userMapper.findUserIdByUsernameAndEmail(username.trim(), email.trim());
            if (userId == null) {
                logger.warn("비밀번호 찾기 - 일치하는 회원 정보 없음: username={}, email={}", username, email);
                return false;
            }

            // 2. 6자리 난수 인증 코드 생성 (예: 000200 ~ 999999)
            String authCode = String.format("%06d", new Random().nextInt(1000000));

            // 3. 3분 만료 일시 설정
            Date expiredAt = new Date(System.currentTimeMillis() + 3 * 60 * 1000);

            // 4. email_verifications DB 레코드 저장
            if (emailVerificationMapper != null) {
                EmailVerificationVO vo = new EmailVerificationVO(userId, email.trim(), authCode, expiredAt);
                emailVerificationMapper.insertVerification(vo);
            }

            // 5. 구글 SMTP 메일 발송 (username 본문 적용)
            EmailUtil.sendAuthCodeEmail(email.trim(), username.trim(), authCode);

            logger.info("비밀번호 찾기 인증 코드 발송 완료: userId={}, email={}, authCode={}", userId, email, authCode);
            return true;

        } catch (Exception e) {
            logger.error("비밀번호 찾기 인증 코드 발송 중 예외 발생:", e);
            return false;
        }
    }

    @Transactional
    public String generateAndUpdateTempPassword(String username, String email) {
        if (username == null || username.isBlank() || email == null || email.isBlank()) {
            return null;
        }

        if (userMapper == null) {
            return null;
        }

        try {
            // 1. DB에서 username과 email 매칭 확인
            Long userId = userMapper.findUserIdByUsernameAndEmail(username.trim(), email.trim());
            if (userId == null) {
                logger.warn("임시 비밀번호 생성 - 일치하는 회원 정보 없음: username={}, email={}", username, email);
                return null;
            }

            // 2. 무작위 10자리 임시 비밀번호 생성 (대소문자 + 숫자 + 특수문자)
            String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$";
            Random random = new Random();
            StringBuilder tempPwBuilder = new StringBuilder();
            for (int i = 0; i < 10; i++) {
                tempPwBuilder.append(chars.charAt(random.nextInt(chars.length())));
            }
            String tempPassword = tempPwBuilder.toString();

            // 3. DB users 테이블 비밀번호 업데이트
            int updatedRows = userMapper.updatePasswordByUsernameAndEmail(username.trim(), email.trim(), tempPassword);
            if (updatedRows > 0) {
                logger.info("임시 비밀번호 생성 및 DB 저장 성공: userId={}, username={}", userId, username);
                return tempPassword;
            } else {
                return null;
            }

        } catch (Exception e) {
            logger.error("임시 비밀번호 생성 중 예외 발생:", e);
            return null;
        }
    }
}
