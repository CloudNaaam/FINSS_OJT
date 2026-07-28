<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Spring MVC File Upload & Download Test</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; padding: 30px; background-color: #f4f6f9; }
        .card { background: white; border-radius: 8px; padding: 25px; max-width: 600px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); margin-bottom: 20px; }
        h1 { font-size: 22px; color: #333; margin-bottom: 20px; }
        .form-group { margin-bottom: 15px; }
        input[type="file"], input[type="text"] { padding: 10px; border: 1px solid #ccc; border-radius: 4px; width: 100%; box-sizing: border-box; }
        button { background-color: #007bff; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 15px; }
        button:hover { background-color: #0056b3; }
        #result { margin-top: 15px; padding: 15px; border-radius: 4px; background: #e9ecef; white-space: pre-wrap; font-family: monospace; font-size: 13px; }
        .link-box { margin-top: 15px; font-size: 14px; color: #28a745; word-break: break-all; }
    </style>
</head>
<body>
    <!-- 1. 파일 업로드 카드 -->
    <div class="card">
        <h1>📁 1. 파일 업로드 API 테스트</h1>
        <form id="uploadForm">
            <div class="form-group">
                <input type="file" id="fileInput" name="file" required />
            </div>
            <button type="button" onclick="uploadFile()">업로드 전송 (POST)</button>
        </form>

        <div id="linkArea" class="link-box"></div>

        <h3>응답 결과 (JSON)</h3>
        <div id="result">파일을 선택하고 업로드 버튼을 눌러주세요.</div>
    </div>

    <!-- 2. 파일 다운로드 카드 -->
    <div class="card">
        <h1>📥 2. 파일 다운로드 API 테스트</h1>
        <div class="form-group">
            <label style="display:block; margin-bottom:5px; font-weight:bold;">다운로드할 file_path (파일명 또는 경로)</label>
            <input type="text" id="downloadPathInput" placeholder="예: uuid.ext 또는 OJT 과제.txt" />
        </div>
        <button type="button" onclick="downloadFile()">다운로드 요청 (GET)</button>
    </div>

    <script>
        async function uploadFile() {
            const fileInput = document.getElementById('fileInput');
            const resultDiv = document.getElementById('result');
            const linkArea = document.getElementById('linkArea');
            const downloadPathInput = document.getElementById('downloadPathInput');

            if (!fileInput.files || fileInput.files.length === 0) {
                alert('업로드할 파일을 선택해 주세요.');
                return;
            }

            const formData = new FormData();
            formData.append('file', fileInput.files[0]);

            resultDiv.innerText = '업로드 진행 중...';
            linkArea.innerHTML = '';

            try {
                const response = await fetch('${pageContext.request.contextPath}/api/file/upload', {
                    method: 'POST',
                    body: formData
                });

                const data = await response.json();
                resultDiv.innerText = JSON.stringify(data, null, 2);

                if (data.success && data.filename) {
                    downloadPathInput.value = data.filename;
                    const downloadUrl = '${pageContext.request.contextPath}/api/file/download?file_path=' + encodeURIComponent(data.filename);
                    const fullUrl = window.location.origin + downloadUrl;
                    linkArea.innerHTML = `<strong>🔗 다운로드 API URL:</strong> <a href="\${downloadUrl}" target="_blank">\${fullUrl}</a>`;
                }
            } catch (error) {
                resultDiv.innerText = '오류 발생: ' + error.message;
            }
        }

        function downloadFile() {
            const filePath = document.getElementById('downloadPathInput').value.trim();
            if (!filePath) {
                alert('다운로드할 file_path를 입력해 주세요.');
                return;
            }
            const url = '${pageContext.request.contextPath}/api/file/download?file_path=' + encodeURIComponent(filePath);
            window.location.href = url;
        }
    </script>
</body>
</html>
