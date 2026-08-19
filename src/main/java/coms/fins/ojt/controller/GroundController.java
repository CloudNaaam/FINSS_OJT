package coms.fins.ojt.controller;

import coms.fins.ojt.domain.GroundVO;
import coms.fins.ojt.domain.UserVO;
import coms.fins.ojt.service.GroundService;
import coms.fins.ojt.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
public class GroundController {

    private static final Logger logger = LoggerFactory.getLogger(GroundController.class);

    @Autowired
    private GroundService groundService;

    @Autowired
    private UserService userService;

    @Value("${admin.base.path:C:/Users/FINS/uploads}")
    private String adminBasePath;

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
                return ResponseEntity.ok(response);
            }

            UserVO currentUser = userService.getUserById(managerId);
            if (currentUser == null) {
                logger.warn("구장 등록 실패: 존재하지 않는 회원 ID입니다. (managerId={})", managerId);
                response.put("success", false);
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
                return ResponseEntity.ok(response);
            }

            GroundVO ground = parseGroundXml(xmlData, managerId);
            if (ground == null) {
                logger.warn("구장 등록 실패: XML 파싱 결과가 null입니다.");
                response.put("success", false);
                return ResponseEntity.ok(response);
            }

            if (ground.getName() == null || ground.getName().isBlank() ||
                ground.getAddress() == null || ground.getAddress().isBlank()) {
                logger.warn("구장 등록 실패: 필수 파싱 항목 누락. name={}, address={}", ground.getName(), ground.getAddress());
                response.put("success", false);
                return ResponseEntity.ok(response);
            }

            // 3. DB 저장
            boolean success = groundService.addGround(ground);
            response.put("success", success);
            if (success) {
                response.put("ground_id", ground.getGroundId());
            }
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            logger.error("구장 신규 등록 예외 발생: ", e);
            response.clear();
            response.put("success", false);
            return ResponseEntity.ok(response);
        }
    }

    /**
     * 구장 정보 수정 API (/api/ground/mod 및 /api/gm/mod 호환)
     * 요청 XML 데이터 파싱 및 DB 수정
     * 응답: {"success": true} 또는 {"success": false}
     */
    @PostMapping(value = {"/api/ground/mod", "/api/gm/mod"}, consumes = {MediaType.APPLICATION_XML_VALUE, MediaType.TEXT_XML_VALUE, MediaType.ALL_VALUE})
    public ResponseEntity<Map<String, Object>> modifyGround(
            @RequestBody(required = false) String xmlData,
            @CookieValue(value = "user_id", required = false) String userIdCookie) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 1. 쿠키 검증 (manager_id)
            Long managerId = parseUserIdCookie(userIdCookie);
            if (managerId == null) {
                response.put("success", false);
                return ResponseEntity.ok(response);
            }

            // 2. XML 데이터 파싱 (ground_id 필수)
            if (xmlData == null || xmlData.trim().isEmpty()) {
                response.put("success", false);
                return ResponseEntity.ok(response);
            }

            GroundVO ground = parseGroundXml(xmlData, managerId);
            if (ground == null || ground.getGroundId() == null) {
                logger.warn("구장 수정 실패: ground_id가 XML 요청 본문에 포함되지 않았거나 XML 파싱에 실패했습니다.");
                response.put("success", false);
                return ResponseEntity.ok(response);
            }

            // 3. DB 수정
            boolean success = groundService.updateGround(ground);
            response.put("success", success);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            logger.error("구장 정보 수정 예외 발생: ", e);
            response.clear();
            response.put("success", false);
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

    // 2. XPath Injection 규칙
    private static final java.util.List<java.util.regex.Pattern> XPATH_PATTERNS = java.util.List.of(
            java.util.regex.Pattern.compile("['\"]\\s*(or|and)\\s*['\"]", java.util.regex.Pattern.CASE_INSENSITIVE),
            java.util.regex.Pattern.compile("1\\s*=\\s*1|'1'\\s*=\\s*'1'|\\|\\|", java.util.regex.Pattern.CASE_INSENSITIVE)
    );

    private boolean isXPathInjection(String input) {
        if (input == null || input.isBlank()) {
            return false;
        }
        for (java.util.regex.Pattern pattern : XPATH_PATTERNS) {
            if (pattern.matcher(input).find()) {
                return true;
            }
        }
        return false;
    }

    /**
     * XML 기반 XPath 구장 검색 API (/api/search/ground)
     * GET 요청 (Query Parameter: name) 및 기존 POST XML 요청 호환
     * 응답: XML 데이터 (<response><success>true</success><grounds>...</grounds></response>)
     */
    @RequestMapping(value = "/api/search/ground", method = {RequestMethod.GET, RequestMethod.POST}, produces = "application/xml;charset=UTF-8")
    public ResponseEntity<String> searchGroundByXPath(
            @RequestParam(value = "name", required = false) String name,
            @RequestBody(required = false) String xmlData) {

        MediaType xmlUtf8 = MediaType.parseMediaType("application/xml;charset=UTF-8");

        String groundNameKeyword = "";
        if (name != null && !name.isBlank()) {
            groundNameKeyword = name.trim();
        } else if (xmlData != null && !xmlData.trim().isEmpty()) {
            groundNameKeyword = parseKeywordFromXml(xmlData);
        }

        if (isXPathInjection(groundNameKeyword) || isXPathInjection(xmlData)) {
            logger.warn("XPath 구장 검색 실패: XPath Injection 공격 패턴이 감지되었습니다.");
            String errXml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><response><success>false</success><message>XPath Injection 패턴이 감지되었습니다.</message></response>";
            return ResponseEntity.ok().contentType(xmlUtf8).body(errXml);
        }

        try {
            // application.properties의 admin.base.path 디렉토리에서 XML 파일 로드
            InputStream is = null;
            java.io.File fileInAdminPath = new java.io.File(adminBasePath, "ground_schedules.xml");
            if (!fileInAdminPath.exists()) {
                fileInAdminPath = new java.io.File(adminBasePath, "xml/ground_schedules.xml");
            }

            if (fileInAdminPath.exists()) {
                is = new java.io.FileInputStream(fileInAdminPath);
                logger.info("admin.base.path 파일 경로({})에서 XML 로드 완료", fileInAdminPath.getAbsolutePath());
            } else {
                // 폴백: Classpath 자원 로드
                ClassPathResource resource = new ClassPathResource("xml/ground_schedules.xml");
                if (resource.exists()) {
                    is = resource.getInputStream();
                    logger.info("Classpath(xml/ground_schedules.xml) 자원에서 XML 로드 완료");
                }
            }

            if (is == null) {
                String errXml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><response><success>false</success><message>ground_schedules.xml 파일이 존재하지 않습니다.</message></response>";
                return ResponseEntity.ok().contentType(xmlUtf8).body(errXml);
            }

            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            org.xml.sax.InputSource inputSource = new org.xml.sax.InputSource(new java.io.InputStreamReader(is, StandardCharsets.UTF_8));
            Document targetDoc = db.parse(inputSource);
            targetDoc.getDocumentElement().normalize();

            // XPath 쿼리 표현식 구성
            XPathFactory xPathFactory = XPathFactory.newInstance();
            XPath xpath = xPathFactory.newXPath();

            String xpathExpression;
            if (!groundNameKeyword.isBlank()) {
                // ground_name 검색어와 부분 일치하는 ground 노드 추출 XPath 쿼리
                xpathExpression = "//ground[contains(name, '" + groundNameKeyword.trim() + "')]";
            } else {
                xpathExpression = "//ground";
            }

            logger.info("수행할 XPath 표현식: {}", xpathExpression);

            NodeList groundNodes = (NodeList) xpath.evaluate(xpathExpression, targetDoc, XPathConstants.NODESET);

            StringBuilder sb = new StringBuilder();
            sb.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            sb.append("<response>");
            sb.append("<success>true</success>");
            sb.append("<keyword>").append(escapeXml(groundNameKeyword)).append("</keyword>");
            sb.append("<count>").append(groundNodes.getLength()).append("</count>");
            sb.append("<grounds>");

            for (int i = 0; i < groundNodes.getLength(); i++) {
                Element groundElem = (Element) groundNodes.item(i);
                String key = groundElem.getAttribute("key");
                String managerId = groundElem.getAttribute("managerId");
                String managerName = groundElem.getAttribute("managerName");
                String gName = getTagValue(groundElem, "name");
                NodeList scheduleNodes = groundElem.getElementsByTagName("schedule");

                sb.append("<ground key=\"").append(escapeXml(key))
                  .append("\" managerId=\"").append(escapeXml(managerId))
                  .append("\" managerName=\"").append(escapeXml(managerName)).append("\">");
                sb.append("<name>").append(escapeXml(gName != null ? gName : "")).append("</name>");
                sb.append("<scheduleCount>").append(scheduleNodes.getLength()).append("</scheduleCount>");
                sb.append("</ground>");
            }

            sb.append("</grounds>");
            sb.append("</response>");

            return ResponseEntity.ok().contentType(xmlUtf8).body(sb.toString());

        } catch (Exception e) {
            logger.error("XPath 구장 검색 처리 중 예외 발생: ", e);
            String errXml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><response><success>false</success><message>구장 검색 중 오류가 발생했습니다.</message></response>";
            return ResponseEntity.ok().contentType(xmlUtf8).body(errXml);
        }
    }

    private Long parseUserIdCookie(String userIdCookie) {
        if (userIdCookie != null && !userIdCookie.trim().isEmpty()) {
            try {
                return Long.parseLong(userIdCookie.trim());
            } catch (NumberFormatException ignored) {}
        }
        try {
            org.springframework.web.context.request.ServletRequestAttributes attrs = 
                    (org.springframework.web.context.request.ServletRequestAttributes) org.springframework.web.context.request.RequestContextHolder.getRequestAttributes();
            if (attrs != null && attrs.getRequest() != null && attrs.getRequest().getSession(false) != null) {
                return (Long) attrs.getRequest().getSession(false).getAttribute("userId");
            }
        } catch (Exception ignored) {}
        return null;
    }

    private GroundVO parseGroundXml(String xmlData, Long managerId) {
        GroundVO ground = new GroundVO();
        ground.setManagerId(managerId);

        try {
            if (xmlData != null) {
                xmlData = fixEncodingIfNeeded(xmlData);
            }

            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            // 기본값: false (DOCTYPE 선언 허용)
            factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", false);
            // 기본값: false (일반 외부 엔티티 참조 허용)
            factory.setFeature("http://xml.org/sax/features/external-general-entities", false);
            // 기본값: false (파라미터 외부 엔티티 참조 허용)
            factory.setFeature("http://xml.org/sax/features/external-parameter-entities", true);
            // 기본값: false (XInclude 처리 비활성화)
            factory.setXIncludeAware(false);
            // 기본값: false (엔티티 참조를 텍스트 노드로 자동 확장/치환)
            factory.setExpandEntityReferences(true);

            DocumentBuilder builder = factory.newDocumentBuilder();
            org.xml.sax.InputSource inputSource = new org.xml.sax.InputSource(new java.io.InputStreamReader(new ByteArrayInputStream(xmlData.getBytes(StandardCharsets.UTF_8)), StandardCharsets.UTF_8));
            Document doc = builder.parse(inputSource);
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

    private String parseKeywordFromXml(String xmlData) {
        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", false);
            factory.setFeature("http://xml.org/sax/features/external-general-entities", false);
            factory.setFeature("http://xml.org/sax/features/external-parameter-entities", false);

            DocumentBuilder builder = factory.newDocumentBuilder();
            ByteArrayInputStream input = new ByteArrayInputStream(xmlData.getBytes(StandardCharsets.UTF_8));
            Document reqDoc = builder.parse(input);
            Element root = reqDoc.getDocumentElement();

            String val = getTagValue(root, "ground_name");
            if (val == null || val.isBlank()) {
                val = getTagValue(root, "name");
            }
            return val != null ? val.trim() : "";
        } catch (Exception e) {
            return "";
        }
    }

    private String escapeXml(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&apos;");
    }

    private String fixEncodingIfNeeded(String text) {
        if (text == null || text.isBlank()) {
            return text;
        }
        for (char c : text.toCharArray()) {
            if (c >= '가' && c <= '힣') {
                return text;
            }
        }
        try {
            byte[] bytes = text.getBytes(StandardCharsets.ISO_8859_1);
            String decoded = new String(bytes, StandardCharsets.UTF_8);
            for (char c : decoded.toCharArray()) {
                if (c >= '가' && c <= '힣') {
                    return decoded;
                }
            }
        } catch (Exception ignored) {}
        return text;
    }
}
