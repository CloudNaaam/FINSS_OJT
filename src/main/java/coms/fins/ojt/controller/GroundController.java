package coms.fins.ojt.controller;

import coms.fins.ojt.domain.GroundVO;
import coms.fins.ojt.domain.UserVO;
import coms.fins.ojt.service.GroundService;
import coms.fins.ojt.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import java.io.ByteArrayInputStream;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

@RestController
public class GroundController {

    private static final Logger logger = LoggerFactory.getLogger(GroundController.class);

    @Autowired
    private GroundService groundService;

    @Autowired
    private UserService userService;

    /**
     * 신규 구장 등록 API (/api/ground/add 및 /api/gm/add 호환)
     * 요청 XML 데이터 파싱 및 DB 저장
     * 응답: {"success": true} 또는 {"success": false}
     */
    @PostMapping(value = {"/api/ground/add", "/api/gm/add"}, consumes = {MediaType.APPLICATION_XML_VALUE, MediaType.TEXT_XML_VALUE, MediaType.ALL_VALUE})
    public ResponseEntity<Map<String, Object>> addGround(
            @RequestBody(required = false) String xmlData,
            @CookieValue(value = "user_id", required = false) String userIdCookie) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 1. 쿠키 검증 및 유저 조회 (manager_id)
            Long managerId = parseUserIdCookie(userIdCookie);
            if (managerId == null) {
                logger.warn("구장 등록 실패: user_id 쿠키가 없거나 올바르지 않습니다.");
                response.put("success", false);
                response.put("message", "로그인이 필요합니다. 쿠키 정보를 확인하세요.");
                return ResponseEntity.ok(response);
            }

            UserVO currentUser = userService.getUserById(managerId);
            if (currentUser == null) {
                logger.warn("구장 등록 실패: 존재하지 않는 회원 ID입니다. (managerId={})", managerId);
                response.put("success", false);
                response.put("message", "회원 정보를 찾을 수 없습니다.");
                return ResponseEntity.ok(response);
            }

            // 구장 등록 시 구장 관리자 권한(is_manager = 1) 자동 부여/승격
            if (currentUser.getIsManager() == null || currentUser.getIsManager() == 0) {
                userService.grantManagerRole(managerId);
            }

            // 2. XML 데이터 파싱
            if (xmlData == null || xmlData.trim().isEmpty()) {
                logger.warn("구장 등록 실패: 요청 XML 본문이 비어있습니다.");
                response.put("success", false);
                response.put("message", "XML 데이터가 존재하지 않습니다.");
                return ResponseEntity.ok(response);
            }

            GroundVO ground = parseGroundXml(xmlData, managerId);
            if (ground == null) {
                logger.warn("구장 등록 실패: XML 파싱 결과가 null입니다.");
                response.put("success", false);
                response.put("message", "XML 데이터 파싱에 실패했습니다.");
                return ResponseEntity.ok(response);
            }

            if (ground.getName() == null || ground.getName().isBlank() ||
                ground.getAddress() == null || ground.getAddress().isBlank()) {
                logger.warn("구장 등록 실패: 필수 파싱 항목 누락. name={}, address={}", ground.getName(), ground.getAddress());
                response.put("success", false);
                response.put("message", "구장 이름과 주소는 필수 입력 항목입니다.");
                return ResponseEntity.ok(response);
            }

            // 3. DB 저장
            boolean success = groundService.addGround(ground);
            response.put("success", success);
            if (success) {
                response.put("ground_id", ground.getGroundId());
            } else {
                response.put("message", "DB 저장 중 오류가 발생했습니다.");
            }
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            logger.error("구장 신규 등록 예외 발생: ", e);
            response.put("success", false);
            response.put("message", "서버 내부 오류: " + e.getMessage());
            return ResponseEntity.ok(response);
        }
    }

    /**
     * 구장 정보 수정 API (/api/ground/mod)
     * 요청 XML 데이터 파싱 및 DB 수정
     * 응답: {"success": true} 또는 {"success": false}
     */
    @PostMapping(value = "/api/ground/mod", consumes = {MediaType.APPLICATION_XML_VALUE, MediaType.TEXT_XML_VALUE, MediaType.ALL_VALUE})
    public ResponseEntity<Map<String, Object>> modifyGround(
            @RequestBody(required = false) String xmlData,
            @CookieValue(value = "user_id", required = false) String userIdCookie) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 1. 쿠키 검증 (manager_id)
            Long managerId = parseUserIdCookie(userIdCookie);
            if (managerId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.ok(response);
            }

            // 2. XML 데이터 파싱 (ground_id 필수)
            if (xmlData == null || xmlData.trim().isEmpty()) {
                response.put("success", false);
                response.put("message", "XML 데이터가 누락되었습니다.");
                return ResponseEntity.ok(response);
            }

            GroundVO ground = parseGroundXml(xmlData, managerId);
            if (ground == null || ground.getGroundId() == null) {
                logger.warn("구장 수정 실패: ground_id가 XML 요청 본문에 포함되지 않았거나 XML 파싱에 실패했습니다.");
                response.put("success", false);
                response.put("message", "ground_id가 누락되었거나 XML 파싱에 실패했습니다.");
                return ResponseEntity.ok(response);
            }

            // 3. DB 수정
            boolean success = groundService.updateGround(ground);
            response.put("success", success);
            if (!success) {
                response.put("message", "구장 정보 수정에 실패했습니다. (소유권 또는 ground_id 확인 필요)");
            }

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            logger.error("구장 정보 수정 예외 발생: ", e);
            response.put("success", false);
            response.put("message", "서버 내부 오류: " + e.getMessage());
            return ResponseEntity.ok(response);
        }
    }

    /**
     * 내가 소유한 구장 목록 조회 API
     */
    @GetMapping("/api/ground/my")
    public ResponseEntity<java.util.List<GroundVO>> getMyGrounds(
            @CookieValue(value = "user_id", required = false) String userIdCookie) {
        Long managerId = parseUserIdCookie(userIdCookie);
        if (managerId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        java.util.List<GroundVO> list = groundService.getGroundsByManager(managerId);
        return ResponseEntity.ok(list);
    }

    /**
     * 구장 단건 정보 조회 API
     */
    @GetMapping("/api/ground/{groundId}")
    public ResponseEntity<GroundVO> getGroundById(@PathVariable("groundId") Long groundId) {
        GroundVO vo = groundService.getGroundById(groundId);
        if (vo == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(vo);
    }

    private Long parseUserIdCookie(String userIdCookie) {
        if (userIdCookie == null || userIdCookie.trim().isEmpty()) {
            return null;
        }
        try {
            return Long.parseLong(userIdCookie.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private GroundVO parseGroundXml(String xmlData, Long managerId) {
        GroundVO ground = new GroundVO();
        ground.setManagerId(managerId);

        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            // 기본값: false (DOCTYPE 선언 허용)
            factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", false);
            // 기본값: false (일반 외부 엔티티 참조 허용)
            factory.setFeature("http://xml.org/sax/features/external-general-entities", true);
            // 기본값: false (파라미터 외부 엔티티 참조 허용)
            factory.setFeature("http://xml.org/sax/features/external-parameter-entities", true);
            // 기본값: false (XInclude 처리 비활성화)
            factory.setXIncludeAware(false);
            // 기본값: false (엔티티 참조를 텍스트 노드로 자동 확장/치환)
            factory.setExpandEntityReferences(true);

            DocumentBuilder builder = factory.newDocumentBuilder();
            ByteArrayInputStream input = new ByteArrayInputStream(xmlData.getBytes(StandardCharsets.UTF_8));
            Document doc = builder.parse(input);
            doc.getDocumentElement().normalize();

            Element root = doc.getDocumentElement();

            // ground_id (수정 시 필수 항목)
            ground.setGroundId(parseLongOrDefault(getTagValue(root, "ground_id"), null));

            ground.setName(getTagValue(root, "name"));
            ground.setAddress(getTagValue(root, "address"));
            ground.setAddressDetail(getTagValue(root, "address_detail"));
            ground.setRegion(getTagValue(root, "region"));
            ground.setSizeInfo(getTagValue(root, "size_info"));

            ground.setIsIndoor(parseIntOrDefault(getTagValue(root, "is_indoor"), 0));
            ground.setGrassType(getTagValueOrDefault(root, "grass_type", "인조잔디"));
            ground.setParkingType(parseIntOrDefault(getTagValue(root, "parking_type"), 0));
            ground.setHasShower(parseIntOrDefault(getTagValue(root, "has_shower"), 0));
            ground.setHasLights(parseIntOrDefault(getTagValue(root, "has_lights"), 1));
            ground.setHasShoesRental(parseIntOrDefault(getTagValue(root, "has_shoes_rental"), 0));
            ground.setHasBallRental(parseIntOrDefault(getTagValue(root, "has_ball_rental"), 0));

            ground.setPricePerHour(parseLongOrDefault(getTagValue(root, "price_per_hour"), 0L));
            ground.setNotice(getTagValue(root, "notice"));

            return ground;

        } catch (Exception e) {
            logger.error("XML 데이터 파싱 중 에러 발생: ", e);
            return null;
        }
    }

    private String getTagValue(Element element, String tagName) {
        if (element == null || tagName == null) {
            return null;
        }
        NodeList nodeList = element.getElementsByTagName(tagName);
        if (nodeList != null && nodeList.getLength() > 0) {
            String text = nodeList.item(0).getTextContent();
            return (text != null) ? text.trim() : null;
        }
        return null;
    }

    private String getTagValueOrDefault(Element element, String tagName, String defaultValue) {
        String val = getTagValue(element, tagName);
        return (val != null && !val.trim().isEmpty()) ? val : defaultValue;
    }

    private Integer parseIntOrDefault(String value, Integer defaultValue) {
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private Long parseLongOrDefault(String value, Long defaultValue) {
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Long.parseLong(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}
