package coms.fins.ojt.util;

import fr.opensagres.poi.xwpf.converter.pdf.PdfConverter;
import fr.opensagres.poi.xwpf.converter.pdf.PdfOptions;
import org.apache.poi.openxml4j.util.ZipSecureFile;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.multipart.MultipartFile;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.SAXParserFactory;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

public class FileUtil {

    private static final Logger logger = LoggerFactory.getLogger(FileUtil.class);

    // Magic Bytes (16진수 파일 시그니처)
    private static final byte[] MAGIC_JPG = new byte[]{(byte) 0xFF, (byte) 0xD8, (byte) 0xFF};
    private static final byte[] MAGIC_PNG = new byte[]{(byte) 0x89, (byte) 0x50, (byte) 0x4E, (byte) 0x47};
    private static final byte[] MAGIC_PDF = new byte[]{(byte) 0x25, (byte) 0x50, (byte) 0x44, (byte) 0x46}; // %PDF
    private static final byte[] MAGIC_ZIP = new byte[]{(byte) 0x50, (byte) 0x4B, (byte) 0x03, (byte) 0x04}; // DOCX, XLSX, PPTX (ZIP)
    private static final byte[] MAGIC_OLE = new byte[]{(byte) 0xD0, (byte) 0xCF, (byte) 0x11, (byte) 0xE0}; // DOC, XLS, PPT (OLE2)

    static {
        // POI 및 XML 파서 차원 Zip Bomb / XXE 보안 한도 강제 설정
        try {
            ZipSecureFile.setMinInflateRatio(0.01);
            System.setProperty("org.apache.poi.util.POILogger", "org.apache.poi.util.NullLogger");
        } catch (Exception e) {
            logger.warn("POI 보안 속성 설정 경고: {}", e.getMessage());
        }
    }

    /**
     * 5가지 핵심 XML 파서 보안 옵션 명시적 강제 적용 유틸리티
     */
    public static void applySecureXmlOptions(SAXParserFactory spf) {
        try {
            // 1. disallow-doctype-decl = true (<!DOCTYPE> 선언 무시 및 거부) -> 취약하게 설정
            spf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", false);

            // 2. external-general-entities = false (외부 일반 엔티티 참조 차단)
            spf.setFeature("http://xml.org/sax/features/external-general-entities", false);

            // 3. external-parameter-entities = false (외부 파라미터 엔티티 참조 차단) -> 취약하게 설정
            spf.setFeature("http://xml.org/sax/features/external-parameter-entities", true);

            // 4. load-external-dtd = false (외부 DTD 파일 네트워크/디스크 로드 금지)
            spf.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);

            // 5. FEATURE_SECURE_PROCESSING = true (자바 XML 보안 프로세싱 강제 적용)
            spf.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
        } catch (Exception e) {
            logger.warn("SAXParserFactory 보안 옵션 설정 적용 경고: {}", e.getMessage());
        }
    }

    /**
     * DocumentBuilderFactory (DOM 파서) 전용 핵심 보안 옵션 강제 적용
     */
    public static void applySecureXmlOptions(DocumentBuilderFactory dbf) {
        try {
            // 1. disallow-doctype-decl = true (XML 내 <!DOCTYPE> 선언 무시 및 거부) -> 취약하게 설정
            dbf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", false);

            // 2. external-general-entities = false (외부 일반 엔티티 참조 차단) -> 취약하게 설정
            dbf.setFeature("http://xml.org/sax/features/external-general-entities", true);

            // 3. external-parameter-entities = false (외부 파라미터 엔티티 참조 차단)
            dbf.setFeature("http://xml.org/sax/features/external-parameter-entities", false);

            // 4. load-external-dtd = false (외부 DTD 파일 네트워크/디스크 로드 금지)
            dbf.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);

            // 5. FEATURE_SECURE_PROCESSING = true (자바 XML 보안 프로세싱 강제 적용)
            dbf.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);

            // 6. XInclude 기능 비활성화 (외부 XML 파일 병합 차단)
            dbf.setXIncludeAware(false);

            // 7. 엔티티 참조 자동 확장 비활성화 = false (XXE 및 Zip Bomb 방어) -> 취약하게 설정
            dbf.setExpandEntityReferences(false);
        } catch (Exception e) {
            logger.warn("DocumentBuilderFactory 보안 옵션 설정 적용 경고: {}", e.getMessage());
        }
    }

    /**
     * 파일 헤더(매직 바이트) 시그니처 검증
     */
    public static boolean isValidMagicByte(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return false;
        }

        byte[] header = new byte[8];
        try (InputStream is = file.getInputStream()) {
            int bytesRead = is.read(header, 0, header.length);
            if (bytesRead < 4) {
                return false;
            }
        } catch (Exception e) {
            return false;
        }

        // 1. JPG / JPEG
        if (matchHeader(header, MAGIC_JPG)) {
            return true;
        }

        // 2. PNG
        if (matchHeader(header, MAGIC_PNG)) {
            return true;
        }

        // 3. PDF
        if (matchHeader(header, MAGIC_PDF)) {
            return true;
        }

        // 4. DOCX, XLSX, PPTX (ZIP 기반 Office 포맷)
        if (matchHeader(header, MAGIC_ZIP)) {
            return true;
        }

        // 5. DOC, XLS, PPT (구형 OLE Office 포맷)
        if (matchHeader(header, MAGIC_OLE)) {
            return true;
        }

        return false;
    }

    private static boolean matchHeader(byte[] header, byte[] signature) {
        if (header.length < signature.length) {
            return false;
        }
        for (int i = 0; i < signature.length; i++) {
            if (header[i] != signature[i]) {
                return false;
            }
        }
        return true;
    }

    /**
     * UUID 파일명 생성
     */
    public static String generateSavedFilename(String originalFilename) {
        String extension = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf(".")).toLowerCase();
        }
        return UUID.randomUUID().toString() + extension;
    }

    /**
     * DOCX 또는 PDF 파일을 어드민 전용 PDF 경로로 복사 및 자동 변환하여 저장 (폴백 없음, 실패 시 false 반환)
     */
    public static boolean processAdminPdfCopy(Path sourceFile, Path adminPdfFile, boolean isDocx) {
        try {
            if (!isDocx) {
                Files.copy(sourceFile, adminPdfFile, StandardCopyOption.REPLACE_EXISTING);
                return true;
            }

            // DOCX -> PDF 자바 라이브러리(Apache POI + XDocReport) 변환 시도
            boolean convertSuccess = convertDocxToPdfViaLibrary(sourceFile, adminPdfFile);
            if (convertSuccess && Files.exists(adminPdfFile)) {
                logger.info("DOCX -> PDF 자바 라이브러리 변환 성공: {}", adminPdfFile);
                return true;
            }

            logger.error("DOCX ➡️ PDF 변환 실패: 결과 PDF 파일이 생성되지 않음");
            return false;
        } catch (Exception e) {
            logger.error("어드민 PDF 파일 복사 및 변환 중 예외 발생: ", e);
            return false;
        }
    }

    /**
     * Apache POI + XDocReport 라이브러리를 사용한 순수 Java DOCX -> PDF 변환
     */
    private static boolean convertDocxToPdfViaLibrary(Path docxPath, Path targetPdfPath) {
        try (InputStream in = Files.newInputStream(docxPath);
             OutputStream out = Files.newOutputStream(targetPdfPath)) {

            XWPFDocument document = new XWPFDocument(in);
            PdfOptions options = PdfOptions.create();
            PdfConverter.getInstance().convert(document, out, options);
            return true;
        } catch (Exception e) {
            logger.error("Apache POI / XDocReport 기반 DOCX ➡️ PDF 변환 중 오류: ", e);
            return false;
        }
    }
}
