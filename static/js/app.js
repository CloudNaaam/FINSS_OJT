// ==========================================
// Admin Console Client JS (Resilient Backend API Parser)
// ==========================================

document.addEventListener('DOMContentLoaded', () => {
    const pageId = document.body.dataset.page;
    if (pageId === 'dashboard') {
        loadDashboardStats();
    } else if (pageId === 'users') {
        loadUsersTable();
    } else if (pageId === 'posts') {
        loadPostsTable();
    }
});

// Toast Notification
function showToast(message, type = 'success') {
    const container = document.getElementById('toastContainer');
    if (!container) return;

    const toast = document.createElement('div');
    toast.className = `toast ${type === 'error' ? 'error' : ''}`;
    toast.innerText = message;

    container.appendChild(toast);
    setTimeout(() => {
        toast.style.opacity = '0';
        setTimeout(() => toast.remove(), 200);
    }, 3000);
}

function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) modal.classList.remove('open');
}

// ------------------------------------------
// Robust Data Extraction Helpers
// ------------------------------------------
function extractList(data, key) {
    if (!data) return [];
    if (Array.isArray(data)) return data;
    if (Array.isArray(data[key])) return data[key];
    if (Array.isArray(data.data)) return data.data;
    if (Array.isArray(data.list)) return data.list;
    if (Array.isArray(data.result)) return data.result;
    if (Array.isArray(data.content)) return data.content;
    if (Array.isArray(data.items)) return data.items;
    return [];
}

function getProp(obj, ...keys) {
    if (!obj) return '';
    for (let k of keys) {
        if (obj[k] !== undefined && obj[k] !== null && obj[k] !== '') {
            return obj[k];
        }
    }
    return '';
}

// 1. Dashboard Stats Loader
async function loadDashboardStats() {
    try {
        const res = await fetch('/api/stats');
        if (!res.ok) return;
        const data = await res.json();
        
        const stats = data.stats || data;
        const totalUsers = getProp(stats, 'total_users', 'totalUsers', 'total', 'userCount') || 0;
        const suspendedUsers = getProp(stats, 'suspended_users', 'suspendedUsers', 'penaltyCount') || 0;
        const totalPosts = getProp(stats, 'total_posts', 'totalPosts', 'postCount', 'boardCount') || 0;

        if (document.getElementById('statTotalUsers')) document.getElementById('statTotalUsers').innerText = totalUsers;
        if (document.getElementById('statSuspendedUsers')) document.getElementById('statSuspendedUsers').innerText = suspendedUsers;
        if (document.getElementById('statTotalPosts')) document.getElementById('statTotalPosts').innerText = totalPosts;
    } catch (err) {
        console.error("Failed to load stats", err);
    }
}

// 2. Users Table (GET /api/users)
async function loadUsersTable() {
    const tbody = document.getElementById('usersTableBody');
    if (!tbody) return;

    const searchInput = document.getElementById('userSearchInput');
    const q = searchInput ? searchInput.value : '';

    tbody.innerHTML = `<tr><td colspan="6" style="text-align:center; color:var(--text-muted);">조회 중...</td></tr>`;

    try {
        const res = await fetch(`/api/users?q=${encodeURIComponent(q)}`);
        if (!res.ok) {
            tbody.innerHTML = `<tr><td colspan="6" style="text-align:center; color:var(--accent-red);">백엔드 응답 오류 (${res.status})</td></tr>`;
            return;
        }
        const data = await res.json();
        const usersList = extractList(data, 'users');

        if (usersList.length === 0) {
            tbody.innerHTML = `<tr><td colspan="6" style="text-align:center; color:var(--text-muted);">조회된 회원이 없습니다.</td></tr>`;
            return;
        }

        tbody.innerHTML = usersList.map(u => {
            const userId = getProp(u, 'id', 'userId', 'user_id', 'USER_ID') || '-';
            const name = getProp(u, 'name', 'userName', 'user_name', 'USER_NAME') || '-';
            const username = getProp(u, 'username', 'loginId', 'userId', 'user_id') || userId;
            const email = getProp(u, 'email', 'userEmail', 'user_email', 'EMAIL') || '-';
            const phone = getProp(u, 'phone', 'userPhone', 'phone_number', 'PHONE') || '-';
            const until = getProp(u, 'until', 'suspended_until', 'suspendedUntil', 'UNTIL');
            const createdAt = getProp(u, 'created_at', 'createdAt', 'createDate', 'createdDate', 'regDate', 'reg_date', 'CREATED_AT') || '-';

            const isSuspended = until !== '' && until !== null && until !== undefined;
            const statusBadge = isSuspended 
                ? `<span class="badge badge-suspended">정지 (~ ${until})</span>`
                : `<span class="badge badge-normal">정상</span>`;

            return `
                <tr>
                    <td><code>${userId}</code></td>
                    <td><strong>${name}</strong> (${username})</td>
                    <td>${email} / ${phone}</td>
                    <td>${statusBadge}</td>
                    <td style="font-size:12px; color:var(--text-muted);">${createdAt}</td>
                    <td>
                        <button class="btn btn-secondary btn-sm" onclick="openUserDetailModal('${userId}')">상세</button>
                        <button class="btn btn-warning btn-sm" onclick="openBanModal('${userId}', '${name}', '${until || ''}')">정지 설정</button>
                    </td>
                </tr>
            `;
        }).join('');
    } catch (err) {
        console.error("User fetch error:", err);
        tbody.innerHTML = `<tr><td colspan="6" style="text-align:center; color:var(--accent-red);">데이터 로드 실패 (네트워크/CORS 오류)</td></tr>`;
    }
}

// 2.1 User Detail Modal (GET /api/user/<user_id>)
async function openUserDetailModal(userId) {
    try {
        const res = await fetch(`/api/user/${userId}`);
        if (!res.ok) {
            showToast(`회원 상세 정보 조회 실패 (${res.status})`, 'error');
            return;
        }
        const data = await res.json();
        const u = data.user || data.data || data;

        const modal = document.getElementById('userDetailModal');
        const content = document.getElementById('userDetailContent');

        const uId = getProp(u, 'id', 'userId', 'user_id', 'USER_ID') || userId;
        const name = getProp(u, 'name', 'userName', 'user_name', 'USER_NAME') || '-';
        const username = getProp(u, 'username', 'loginId', 'userId', 'user_id') || uId;
        const email = getProp(u, 'email', 'userEmail', 'user_email', 'EMAIL') || '-';
        const phone = getProp(u, 'phone', 'userPhone', 'phone_number', 'PHONE') || '-';
        const until = getProp(u, 'until', 'suspended_until', 'suspendedUntil', 'UNTIL');
        const createdAt = getProp(u, 'created_at', 'createdAt', 'createDate', 'createdDate', 'regDate', 'reg_date', 'CREATED_AT') || '-';

        const postsList = extractList(u, 'posts');
        let postsHtml = postsList.length > 0
            ? postsList.map(p => {
                const title = getProp(p, 'title', 'boardTitle', 'postTitle') || '제목 없음';
                const views = getProp(p, 'views', 'viewCount', 'hit') || 0;
                const pDate = getProp(p, 'created_at', 'createdAt', 'createDate') || '-';
                return `<li>[${pDate}] ${title} (조회수: ${views})</li>`;
              }).join('')
            : '<li style="color:var(--text-muted);">작성 게시글 없음</li>';

        content.innerHTML = `
            <div class="info-grid">
                <div class="info-item">
                    <span class="info-label">회원 ID / 계정</span>
                    <span class="info-val">${uId} (${username})</span>
                </div>
                <div class="info-item">
                    <span class="info-label">이름</span>
                    <span class="info-val">${name}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">이메일</span>
                    <span class="info-val">${email}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">연락처</span>
                    <span class="info-val">${phone}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">상태 (until)</span>
                    <span class="info-val">${until ? '<span class="badge badge-suspended">정지만료: ' + until + '</span>' : '<span class="badge badge-normal">정상 (null)</span>'}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">가입일시</span>
                    <span class="info-val">${createdAt}</span>
                </div>
            </div>

            <div style="font-weight:700; margin:12px 0 6px 0; font-size:13px;">작성 게시글 이력</div>
            <ul style="padding-left:18px; font-size:12px; line-height:1.6; color:var(--text-secondary);">${postsHtml}</ul>
        `;

        modal.classList.add('open');
    } catch (err) {
        showToast("회원 정보 조회 실패", "error");
    }
}

// 2.2 Ban Modal (GET /api/admin/<user_id>/penalty?until=...)
function openBanModal(userId, userName, currentUntil) {
    document.getElementById('banUserId').value = userId;
    document.getElementById('banUserName').innerText = `${userName} (${userId})`;
    
    if (currentUntil && currentUntil !== 'null' && currentUntil !== 'undefined') {
        document.getElementById('banTimestampInput').value = currentUntil;
    } else {
        applyBanPreset('14');
    }
    document.getElementById('userBanModal').classList.add('open');
}

function applyBanPreset(preset) {
    const input = document.getElementById('banTimestampInput');
    if (!input) return;

    if (preset === 'CLEAR') {
        input.value = '';
    } else if (preset === 'PERMANENT') {
        input.value = '9999-12-31 23:59:59';
    } else {
        const days = parseInt(preset) || 14;
        const d = new Date(Date.now() + days * 24 * 60 * 60 * 1000);
        const yyyy = d.getFullYear();
        const mm = String(d.getMonth() + 1).padStart(2, '0');
        const dd = String(d.getDate()).padStart(2, '0');
        const hh = String(d.getHours()).padStart(2, '0');
        const mi = String(d.getMinutes()).padStart(2, '0');
        const ss = String(d.getSeconds()).padStart(2, '0');
        input.value = `${yyyy}-${mm}-${dd} ${hh}:${mi}:${ss}`;
    }
}

async function submitUserBan() {
    const userId = document.getElementById('banUserId').value;
    const untilVal = document.getElementById('banTimestampInput').value.trim();

    try {
        const res = await fetch(`/api/admin/${userId}/penalty?until=${encodeURIComponent(untilVal)}`);
        const data = await res.json();
        if (res.ok && (data.success !== false)) {
            showToast(data.message || "정지 설정이 완료되었습니다.", 'success');
            closeModal('userBanModal');
            loadUsersTable();
        } else {
            showToast(data.message || "정지 설정 실패", 'error');
        }
    } catch (err) {
        showToast("정지 상태 업데이트 실패", "error");
    }
}

// 3. Posts Table (GET /api/board)
async function loadPostsTable() {
    const tbody = document.getElementById('postsTableBody');
    if (!tbody) return;

    const searchInput = document.getElementById('postSearchInput');
    const q = searchInput ? searchInput.value : '';

    tbody.innerHTML = `<tr><td colspan="6" style="text-align:center; color:var(--text-muted);">조회 중...</td></tr>`;

    try {
        const res = await fetch(`/api/board?q=${encodeURIComponent(q)}`);
        if (!res.ok) {
            tbody.innerHTML = `<tr><td colspan="6" style="text-align:center; color:var(--accent-red);">백엔드 응답 오류 (${res.status})</td></tr>`;
            return;
        }
        const data = await res.json();
        const postsList = extractList(data, 'posts');

        if (postsList.length === 0) {
            tbody.innerHTML = `<tr><td colspan="6" style="text-align:center; color:var(--text-muted);">게시글이 없습니다.</td></tr>`;
            return;
        }

        tbody.innerHTML = postsList.map(p => {
            const boardId = getProp(p, 'id', 'boardId', 'board_id', 'post_id', 'postId', 'BOARD_ID') || '-';
            const title = getProp(p, 'title', 'boardTitle', 'board_title', 'postTitle', 'TITLE') || '제목 없음';
            const author = getProp(p, 'author_name', 'authorName', 'author', 'writer', 'userName', 'name', 'WRITER') || '-';
            const category = getProp(p, 'category', 'boardCategory', 'category_name', 'CATEGORY') || '일반';
            const createdAt = getProp(p, 'created_at', 'createdAt', 'createDate', 'createdDate', 'regDate', 'reg_date', 'CREATED_AT') || '-';

            return `
                <tr>
                    <td><code>${boardId}</code></td>
                    <td><strong>${title}</strong></td>
                    <td>${author}</td>
                    <td>${category}</td>
                    <td style="font-size:12px; color:var(--text-muted);">${createdAt}</td>
                    <td>
                        <button class="btn btn-danger btn-sm" onclick="deletePostApi('${boardId}')">삭제</button>
                    </td>
                </tr>
            `;
        }).join('');
    } catch (err) {
        console.error("Board fetch error:", err);
        tbody.innerHTML = `<tr><td colspan="6" style="text-align:center; color:var(--accent-red);">데이터 로드 실패 (네트워크/CORS 오류)</td></tr>`;
    }
}

// 3.1 Post Delete API (GET /api/admin/<board_id>/delete)
async function deletePostApi(boardId) {
    if (!confirm(`게시글 [${boardId}]을(를) 삭제하시겠습니까?`)) {
        return;
    }

    try {
        const res = await fetch(`/api/admin/${boardId}/delete`);
        const data = await res.json();
        if (res.ok && (data.success !== false)) {
            showToast(data.message || "게시글이 삭제되었습니다.", 'success');
            loadPostsTable();
        } else {
            showToast(data.message || "게시글 삭제 실패", 'error');
        }
    } catch (err) {
        showToast("게시글 삭제 실패", "error");
    }
}
