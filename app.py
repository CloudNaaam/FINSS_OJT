import os
from flask import Flask, render_template, jsonify, request
from flask_cors import CORS
from dotenv import load_dotenv
import requests

# .env 파일 자동 로드 (Git 관리 제외 대상)
load_dotenv()

app = Flask(__name__)
CORS(app)

# .env 파일에서 설정값 로드
TARGET_BACKEND_URL = os.getenv("TARGET_BACKEND_URL", "http://192.168.21.198:8080").rstrip('/')
PORT = int(os.getenv("FLASK_PORT", "5000"))


# ==========================================
# Page Routes (HTML Views)
# ==========================================
@app.route('/')
def index():
    return render_template('index.html', active_page='dashboard')

@app.route('/users')
def users_page():
    return render_template('users.html', active_page='users')

@app.route('/posts')
def posts_page():
    return render_template('posts.html', active_page='posts')


# ==========================================
# 백엔드 API 연동 (Proxy & Relay Endpoints)
# ==========================================

# 1. 회원 목록 및 검색 조회 API (GET /api/users)
@app.route('/api/users', methods=['GET'])
def get_users():
    search_q = request.args.get('q', '').strip()
    try:
        resp = requests.get(f"{TARGET_BACKEND_URL}/api/users", params={"q": search_q}, timeout=5)
        return (resp.content, resp.status_code, [
            (k, v) for k, v in resp.headers.items() 
            if k.lower() not in ['content-encoding', 'content-length', 'transfer-encoding', 'connection']
        ])
    except Exception as e:
        print(f"[BACKEND ERROR] 회원 목록 연동 실패 ({TARGET_BACKEND_URL}/api/users): {e}")
        return jsonify({
            "success": False,
            "message": f"백엔드 서버 ({TARGET_BACKEND_URL}) 연동 실패",
            "total": 0,
            "users": []
        }), 502


# 2. 회원 상세 정보 조회 API (GET /api/user/<user_id>)
@app.route('/api/user/<user_id>', methods=['GET'])
def get_user_detail(user_id):
    try:
        resp = requests.get(f"{TARGET_BACKEND_URL}/api/user/{user_id}", timeout=5)
        return (resp.content, resp.status_code, [
            (k, v) for k, v in resp.headers.items() 
            if k.lower() not in ['content-encoding', 'content-length', 'transfer-encoding', 'connection']
        ])
    except Exception as e:
        print(f"[BACKEND ERROR] 회원 상세 연동 실패 ({TARGET_BACKEND_URL}/api/user/{user_id}): {e}")
        return jsonify({
            "success": False,
            "message": f"백엔드 서버 ({TARGET_BACKEND_URL}) 연동 실패",
            "user": None
        }), 502


# 3. 회원 정지 처리 API (GET /api/admin/<user_id>/penalty?until=...)
@app.route('/api/admin/<user_id>/penalty', methods=['GET', 'PUT', 'POST'])
def update_user_status(user_id):
    until_val = request.args.get('until')
    if until_val is None:
        data = request.get_json(silent=True) or {}
        until_val = data.get('until')

    try:
        resp = requests.get(f"{TARGET_BACKEND_URL}/api/admin/{user_id}/penalty", params={"until": until_val}, timeout=5)
        return (resp.content, resp.status_code, [
            (k, v) for k, v in resp.headers.items() 
            if k.lower() not in ['content-encoding', 'content-length', 'transfer-encoding', 'connection']
        ])
    except Exception as e:
        print(f"[BACKEND ERROR] 회원 정지 연동 실패 ({TARGET_BACKEND_URL}/api/admin/{user_id}/penalty): {e}")
        return jsonify({
            "success": False,
            "message": f"백엔드 서버 ({TARGET_BACKEND_URL}) 연동 실패",
            "until": until_val
        }), 502


# 4. 게시글 목록 조회 API (GET /api/board)
@app.route('/api/board', methods=['GET'])
def get_posts():
    search_q = request.args.get('q', '').strip()
    try:
        resp = requests.get(f"{TARGET_BACKEND_URL}/api/board", params={"q": search_q}, timeout=5)
        return (resp.content, resp.status_code, [
            (k, v) for k, v in resp.headers.items() 
            if k.lower() not in ['content-encoding', 'content-length', 'transfer-encoding', 'connection']
        ])
    except Exception as e:
        print(f"[BACKEND ERROR] 게시글 목록 연동 실패 ({TARGET_BACKEND_URL}/api/board): {e}")
        return jsonify({
            "success": False,
            "message": f"백엔드 서버 ({TARGET_BACKEND_URL}) 연동 실패",
            "total": 0,
            "posts": []
        }), 502


# 5. 게시글 삭제 API (GET /api/admin/<board_id>/delete)
@app.route('/api/admin/<board_id>/delete', methods=['GET', 'DELETE', 'POST'])
def delete_post(board_id):
    try:
        resp = requests.get(f"{TARGET_BACKEND_URL}/api/admin/{board_id}/delete", timeout=5)
        return (resp.content, resp.status_code, [
            (k, v) for k, v in resp.headers.items() 
            if k.lower() not in ['content-encoding', 'content-length', 'transfer-encoding', 'connection']
        ])
    except Exception as e:
        print(f"[BACKEND ERROR] 게시글 삭제 연동 실패 ({TARGET_BACKEND_URL}/api/admin/{board_id}/delete): {e}")
        return jsonify({
            "success": False,
            "message": f"백엔드 서버 ({TARGET_BACKEND_URL}) 연동 실패"
        }), 502


# 6. 대시보드 통계 API (GET /api/stats)
@app.route('/api/stats', methods=['GET'])
def get_stats():
    try:
        resp = requests.get(f"{TARGET_BACKEND_URL}/api/stats", timeout=5)
        return (resp.content, resp.status_code, [
            (k, v) for k, v in resp.headers.items() 
            if k.lower() not in ['content-encoding', 'content-length', 'transfer-encoding', 'connection']
        ])
    except Exception as e:
        print(f"[BACKEND ERROR] 통계 연동 실패 ({TARGET_BACKEND_URL}/api/stats): {e}")
        return jsonify({
            "success": False,
            "stats": {
                "total_users": 0,
                "suspended_users": 0,
                "total_posts": 0
            }
        }), 502


if __name__ == '__main__':
    print(f"[ADMIN SERVER] Running on http://127.0.0.1:{PORT}")
    print(f"[ENV LOADED] TARGET_BACKEND_URL from .env: {TARGET_BACKEND_URL}")
    app.run(host='0.0.0.0', port=PORT, debug=True)
