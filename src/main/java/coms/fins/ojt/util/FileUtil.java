package coms.fins.ojt.util;

import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.util.UUID;

public class FileUtil {

    // Magic Bytes (16진수 파일 시그니처)
    private static final byte[] MAGIC_JPG = new byte[]{(byte) 0xFF, (byte) 0xD8, (byte) 0xFF};
    private static final byte[] MAGIC_PNG = new byte[]{(byte) 0x89, (byte) 0x50, (byte) 0x4E, (byte) 0x47};
    private static final byte[] MAGIC_PDF = new byte[]{(byte) 0x25, (byte) 0x50, (byte) 0x44, (byte) 0x46}; // %PDF
    private static final byte[] MAGIC_ZIP = new byte[]{(byte) 0x50, (byte) 0x4B, (byte) 0x03, (byte) 0x04}; // DOCX, XLSX, PPTX (ZIP)
    private static final byte[] MAGIC_OLE = new byte[]{(byte) 0xD0, (byte) 0xCF, (byte) 0x11, (byte) 0xE0}; // DOC, XLS, PPT (OLE2)

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
}
