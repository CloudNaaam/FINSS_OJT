from flask import Flask, render_template, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# ==========================================
# 백엔드 서버 (192.168.21.198) 및 hosts 도메인 설정
# ==========================================
# 1) IP 직접 사용 시: "http://192.168.21.198:8080"
# 2) hosts 파일(C:\Windows\System32\drivers\etc\hosts) 등록 도메인 사용 시: "http://ojt-backend:8080"
TARGET_BACKEND_URL = "http://finlabfootball"  # 필요 시 hosts 도메인명(예: http://ojt-backend:8080)으로 치환 가능


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
# REAL API Endpoints (/api/...)
# ==========================================

# 1. 회원 목록 및 검색 조회 API (GET /api/users)
@app.route('/api/users', methods=['GET'])
def get_users():
    search_q = request.args.get('q', '').strip()

    # [192.168.21.198 백엔드 서버 연동 시 예시]
    # import requests
    # res = requests.get(f"{TARGET_BACKEND_URL}/api/users", params={"q": search_q})
    # return jsonify(res.json())

    return jsonify({
        "success": True,
        "total": 0,
        "users": []
    })


# 2. 회원 상세 정보 조회 API (GET /api/user/<user_id>)
@app.route('/api/user/<user_id>', methods=['GET'])
def get_user_detail(user_id):
    # [192.168.21.198 백엔드 서버 연동 시 예시]
    # import requests
    # res = requests.get(f"{TARGET_BACKEND_URL}/api/user/{user_id}")
    # return jsonify(res.json())

    return jsonify({
        "success": True,
        "user": {
            "id": user_id,
            "username": "",
            "name": "",
            "email": "",
            "phone": "",
            "created_at": "",
            "until": None,
            "posts": []
        }
    })


# 3. 회원 정지 처리 API (GET /api/admin/<user_id>/penalty?until=...)
@app.route('/api/admin/<user_id>/penalty', methods=['GET', 'PUT', 'POST'])
def update_user_status(user_id):
    until_val = request.args.get('until')
    if until_val is None:
        data = request.get_json(silent=True) or {}
        until_val = data.get('until')

    # [192.168.21.198 백엔드 서버 연동 시 예시]
    # import requests
    # res = requests.get(f"{TARGET_BACKEND_URL}/api/admin/{user_id}/penalty", params={"until": until_val})
    # return jsonify(res.json())

    msg = f"회원 [{user_id}] 정지 해제 (until = null)" if not until_val or str(until_val).upper() in ['NONE', 'CLEAR', 'NULL', ''] else f"회원 [{user_id}] 정지 만료 일시(until)가 [{until_val}](으)로 전달되었습니다."

    return jsonify({
        "success": True,
        "message": msg,
        "until": until_val
    })


# 4. 게시글 목록 조회 API (GET /api/board)
@app.route('/api/board', methods=['GET'])
def get_posts():
    search_q = request.args.get('q', '').strip()

    # [192.168.21.198 백엔드 서버 연동 시 예시]
    # import requests
    # res = requests.get(f"{TARGET_BACKEND_URL}/api/board", params={"q": search_q})
    # return jsonify(res.json())

    return jsonify({
        "success": True,
        "total": 0,
        "posts": []
    })


# 5. 게시글 삭제 API (GET /api/admin/<board_id>/delete)
@app.route('/api/admin/<board_id>/delete', methods=['GET', 'DELETE', 'POST'])
def delete_post(board_id):
    # [192.168.21.198 백엔드 서버 연동 시 예시]
    # import requests
    # res = requests.get(f"{TARGET_BACKEND_URL}/api/admin/{board_id}/delete")
    # return jsonify(res.json())

    return jsonify({
        "success": True,
        "message": f"게시글 [{board_id}] 삭제 요청 전달 완료"
    })


# 6. 대시보드 통계 API (GET /api/stats)
@app.route('/api/stats', methods=['GET'])
def get_stats():
    # [192.168.21.198 백엔드 서버 연동 시 예시]
    # import requests
    # res = requests.get(f"{TARGET_BACKEND_URL}/api/stats")
    # return jsonify(res.json())

    return jsonify({
        "success": True,
        "stats": {
            "total_users": 0,
            "suspended_users": 0,
            "total_posts": 0
        }
    })

if __name__ == '__main__':
    print("[ADMIN SERVER] FINSS OJT ADMIN SERVER is running on http://127.0.0.1:8080")
    print(f"[TARGET BACKEND] Remote Backend Target: {TARGET_BACKEND_URL}")
    app.run(host='0.0.0.0', port=5000, debug=True)
