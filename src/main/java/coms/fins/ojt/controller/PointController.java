package coms.fins.ojt.controller;

import coms.fins.ojt.domain.UserVO;
import coms.fins.ojt.mapper.UserMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/point")
public class PointController {

    private static final Logger logger = LoggerFactory.getLogger(PointController.class);

    @Autowired
    private UserMapper userMapper;

    /**
     * 포인트 선물/선송 API (POST /api/point/send)
     * Request Body:
     * {
     *   "send_point": 1000,
     *   "send_to": "받는이름_또는_아이디"
     * }
     * Response Body:
     * {
     *   "success": true / false
     * }
     */
    @PostMapping("/send")
    @Transactional
    public ResponseEntity<Map<String, Object>> sendPoint(
            @RequestBody(required = false) Map<String, Object> requestBody,
            @CookieValue(value = "user_id", required = false) String userIdCookie) {

        Map<String, Object> response = new HashMap<>();

        // 1. 로그인 여부 검증
        if (userIdCookie == null || userIdCookie.isBlank()) {
            response.put("success", false);
            response.put("message", "로그인이 필요한 서비스입니다.");
            return ResponseEntity.ok(response);
        }

        Long senderId;
        try {
            senderId = Long.parseLong(userIdCookie.trim());
        } catch (NumberFormatException e) {
            response.put("success", false);
            response.put("message", "올바르지 않은 사용자 세션입니다.");
            return ResponseEntity.ok(response);
        }

        if (requestBody == null) {
            response.put("success", false);
            response.put("message", "요청 데이터가 올바르지 않습니다.");
            return ResponseEntity.ok(response);
        }

        // 2. Request 파라미터 추출 (send_point, send_to)
        Object pointObj = requestBody.get("send_point");
        String sendTo = (String) requestBody.get("send_to");

        if (pointObj == null || sendTo == null || sendTo.isBlank()) {
            response.put("success", false);
            response.put("message", "보낼 포인트와 받는 사람 이름을 입력해주세요.");
            return ResponseEntity.ok(response);
        }

        int sendPoint;
        try {
            sendPoint = Integer.parseInt(String.valueOf(pointObj).trim());
        } catch (NumberFormatException e) {
            response.put("success", false);
            response.put("message", "포인트는 수치(숫자)로 입력해 주세요.");
            return ResponseEntity.ok(response);
        }

        if (sendPoint <= 0) {
            response.put("success", false);
            response.put("message", "1포인트 이상만 선물할 수 있습니다.");
            return ResponseEntity.ok(response);
        }

        // 3. 보낸 사람(본인) 데이터 및 잔여 포인트 확인
        UserVO sender = userMapper.selectUserById(senderId);
        if (sender == null) {
            response.put("success", false);
            response.put("message", "보내는 사람 정보를 찾을 수 없습니다.");
            return ResponseEntity.ok(response);
        }

        int senderCurrentPoint = (sender.getPoint() != null) ? sender.getPoint() : 0;
        if (senderCurrentPoint < sendPoint) {
            response.put("success", false);
            response.put("message", "보유 포인트가 부족합니다. (현재 보유: " + senderCurrentPoint + " P)");
            return ResponseEntity.ok(response);
        }

        // 4. 받는 사람 유저 데이터 조회 (username 또는 name)
        String targetName = sendTo.trim();
        UserVO receiver = userMapper.findByUsernameOrName(targetName);
        if (receiver == null) {
            response.put("success", false);
            response.put("message", "받는 사람('" + targetName + "') 유저를 찾을 수 없습니다.");
            return ResponseEntity.ok(response);
        }

        if (receiver.getUserId().equals(sender.getUserId())) {
            response.put("success", false);
            response.put("message", "자기 자신에게는 포인트를 보낼 수 없습니다.");
            return ResponseEntity.ok(response);
        }

        // 5. 포인트 이체 트랜잭션 수행
        int receiverCurrentPoint = (receiver.getPoint() != null) ? receiver.getPoint() : 0;

        userMapper.updateUserPoint(sender.getUserId(), senderCurrentPoint - sendPoint);
        userMapper.updateUserPoint(receiver.getUserId(), receiverCurrentPoint + sendPoint);

        logger.info("포인트 선물 완료: senderId={}, receiverId={}, point={}", senderId, receiver.getUserId(), sendPoint);

        response.put("success", true);
        response.put("message", "포인트를 성공적으로 전달했습니다!");
        return ResponseEntity.ok(response);
    }
}
