from flask import Flask, render_template, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# ==========================================
# In-Memory Database
# ==========================================
USERS_DB = [
    {
        "id": "usr_001",
        "username": "sonny7",
        "name": "손흥민",
        "email": "sonny7@tottenham.com",
        "phone": "010-7777-7777",
        "created_at": "2024-01-15 14:20",
        "until": None,  # Timestamp (정지 만료 일시, None이면 정상)
        "is_manager": True,
        "assigned_ground": "강남 풋살 파크",
        "manner_score": 98.5,
        "noshow_count": 0,
        "posts": [
            {"id": "p_201", "title": "주말 풋살 용병 모집합니다", "created_at": "2026-08-08 10:15", "views": 142},
            {"id": "p_189", "title": "풋살화 사이즈 추천 부탁드립니다", "created_at": "2026-07-30 18:40", "views": 89}
        ]
    },
    {
        "id": "usr_002",
        "username": "kane_harry",
        "name": "해리케인",
        "email": "kane9@bayern.de",
        "phone": "010-9999-9999",
        "created_at": "2024-02-01 09:10",
        "until": "2026-08-20 23:59:59",  # 14일 정지 Timestamp
        "is_manager": False,
        "assigned_ground": None,
        "manner_score": 62.0,
        "noshow_count": 2,
        "posts": [
            {"id": "p_198", "title": "노쇼 관련 문의글", "created_at": "2026-08-06 21:00", "views": 310}
        ]
    },
    {
        "id": "usr_003",
        "username": "lee_kangin",
        "name": "이강인",
        "email": "kangin20@psg.fr",
        "phone": "010-2020-2020",
        "created_at": "2024-03-12 11:45",
        "until": None,
        "is_manager": True,
        "assigned_ground": "잠실 올림픽 아레나",
        "manner_score": 96.0,
        "noshow_count": 0,
        "posts": [
            {"id": "p_205", "title": "패싱 훈련 꿀팁 공유합니다", "created_at": "2026-08-10 16:30", "views": 520}
        ]
    },
    {
        "id": "usr_004",
        "username": "kim_minjae",
        "name": "김민재",
        "email": "minjae3@bayern.de",
        "phone": "010-3333-3333",
        "created_at": "2024-04-05 16:20",
        "until": None,
        "is_manager": False,
        "assigned_ground": None,
        "manner_score": 94.2,
        "noshow_count": 0,
        "posts": [
            {"id": "p_202", "title": "센터백 수비 위치 선정 노하우", "created_at": "2026-08-09 19:10", "views": 240}
        ]
    },
    {
        "id": "usr_005",
        "username": "spammer_99",
        "name": "홍길동",
        "email": "spam123@badsite.com",
        "phone": "010-0000-1111",
        "created_at": "2024-07-20 03:12",
        "until": "9999-12-31 23:59:59",  # 영구 정지 Timestamp
        "is_manager": False,
        "assigned_ground": None,
        "manner_score": 20.0,
        "noshow_count": 5,
        "posts": [
            {"id": "p_190", "title": "광고성 스팸 글", "created_at": "2026-07-21 02:00", "views": 15}
        ]
    }
]

POSTS_DB = [
    {
        "id": "p_205",
        "title": "패싱 훈련 꿀팁 공유합니다",
        "author_id": "usr_003",
        "author_name": "이강인",
        "category": "팁/노하우",
        "content": "패스할 때 디딤발의 위치가 중요합니다.",
        "created_at": "2026-08-10 16:30",
        "views": 520
    },
    {
        "id": "p_202",
        "title": "센터백 수비 위치 선정 노하우",
        "author_id": "usr_004",
        "author_name": "김민재",
        "category": "전술분석",
        "content": "상대 공격수가 침투할 때 거리를 유지하세요.",
        "created_at": "2026-08-09 19:10",
        "views": 240
    },
    {
        "id": "p_201",
        "title": "주말 풋살 용병 모집합니다",
        "author_id": "usr_001",
        "author_name": "손흥민",
        "category": "용병모집",
        "content": "이번주 토요일 18시 강남 풋살 파크 용병 모집합니다.",
        "created_at": "2026-08-08 10:15",
        "views": 142
    },
    {
        "id": "p_198",
        "title": "노쇼 관련 문의글",
        "author_id": "usr_002",
        "author_name": "해리케인",
        "category": "자유게시판",
        "content": "우천으로 인한 취소 문의입니다.",
        "created_at": "2026-08-06 21:00",
        "views": 310
    },
    {
        "id": "p_190",
        "title": "광고성 스팸 글",
        "author_id": "usr_005",
        "author_name": "홍길동",
        "category": "홍보/광고",
        "content": "불법 광고 링크 포함 글입니다.",
        "created_at": "2026-07-21 02:00",
        "views": 15
    }
]

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
    search_q = request.args.get('q', '').strip().lower()

    filtered = USERS_DB
    if search_q:
        filtered = [
            u for u in filtered
            if search_q in u['username'].lower()
            or search_q in u['name'].lower()
            or search_q in u['email'].lower()
            or search_q in u['phone'].lower()
            or search_q in u['id'].lower()
        ]

    return jsonify({
        "success": True,
        "total": len(filtered),
        "users": filtered
    })


# 2. 회원 상세 정보 조회 API (GET /api/user/<user_id>)
@app.route('/api/user/<user_id>', methods=['GET'])
def get_user_detail(user_id):
    user = next((u for u in USERS_DB if u['id'] == user_id), None)
    if not user:
        return jsonify({"success": False, "message": "존재하지 않는 회원입니다."}), 404
    
    return jsonify({
        "success": True,
        "user": user
    })


# 3. 회원 정지 처리 API (GET /api/admin/<user_id>/penalty?until=...)
@app.route('/api/admin/<user_id>/penalty', methods=['GET', 'PUT', 'POST'])
def update_user_status(user_id):
    user = next((u for u in USERS_DB if u['id'] == user_id), None)
    if not user:
        return jsonify({"success": False, "message": "존재하지 않는 회원입니다."}), 404

    until_val = request.args.get('until')
    if until_val is None:
        data = request.get_json(silent=True) or {}
        until_val = data.get('until')

    if not until_val or str(until_val).upper() in ['NONE', 'CLEAR', 'NULL', '0', '']:
        user['until'] = None
        msg = f"회원 [{user['name']}]의 정지가 해제되었습니다. (until = null)"
    else:
        user['until'] = str(until_val)
        msg = f"회원 [{user['name']}]의 정지 만료 일시(Timestamp)가 [{until_val}](으)로 설정되었습니다."

    return jsonify({
        "success": True,
        "message": msg,
        "user": user
    })


# 4. 게시글 목록 조회 API (GET /api/board)
@app.route('/api/board', methods=['GET'])
def get_posts():
    search_q = request.args.get('q', '').strip().lower()

    filtered = POSTS_DB
    if search_q:
        filtered = [
            p for p in filtered
            if search_q in p['title'].lower()
            or search_q in p['author_name'].lower()
            or search_q in p['content'].lower()
        ]

    return jsonify({
        "success": True,
        "total": len(filtered),
        "posts": filtered
    })


# 5. 게시글 삭제 API (GET /api/admin/<board_id>/delete)
@app.route('/api/admin/<board_id>/delete', methods=['GET', 'DELETE', 'POST'])
def delete_post(board_id):
    global POSTS_DB
    post = next((p for p in POSTS_DB if p['id'] == board_id), None)
    if not post:
        return jsonify({"success": False, "message": "삭제할 게시글이 존재하지 않습니다."}), 404

    POSTS_DB = [p for p in POSTS_DB if p['id'] != board_id]
    return jsonify({
        "success": True,
        "message": f"게시글 [{post['title']}] (ID: {board_id})가 성공적으로 삭제되었습니다."
    })


# 6. 대시보드 통계 API
@app.route('/api/stats', methods=['GET'])
def get_stats():
    total_users = len(USERS_DB)
    suspended_users = len([u for u in USERS_DB if u['until'] is not None])
    total_posts = len(POSTS_DB)

    return jsonify({
        "success": True,
        "stats": {
            "total_users": total_users,
            "suspended_users": suspended_users,
            "total_posts": total_posts
        }
    })

if __name__ == '__main__':
    print("[ADMIN SERVER] FINSS OJT ADMIN SERVER is running on http://127.0.0.1:5000")
    app.run(host='0.0.0.0', port=8080, debug=True)
