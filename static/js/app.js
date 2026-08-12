// ==========================================
// Admin Console Client JS (until Timestamp Version)
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

// 1. Dashboard Stats
async function loadDashboardStats() {
    try {
        const res = await fetch('/api/stats');
        const data = await res.json();
        if (data.success) {
            const stats = data.stats;
            if (document.getElementById('statTotalUsers')) document.getElementById('statTotalUsers').innerText = stats.total_users;
            if (document.getElementById('statSuspendedUsers')) document.getElementById('statSuspendedUsers').innerText = stats.suspended_users;
            if (document.getElementById('statTotalPosts')) document.getElementById('statTotalPosts').innerText = stats.total_posts;
        }
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
        const data = await res.json();

        if (data.success) {
            if (data.users.length === 0) {
                tbody.innerHTML = `<tr><td colspan="6" style="text-align:center; color:var(--text-muted);">검색 결과가 없습니다.</td></tr>`;
                return;
            }

            tbody.innerHTML = data.users.map(u => {
                const isSuspended = u.until !== null;
                const statusBadge = isSuspended 
                    ? `<span class="badge badge-suspended">정지 (~ ${u.until})</span>`
                    : `<span class="badge badge-normal">정상</span>`;

                return `
                    <tr>
                        <td><code>${u.id}</code></td>
                        <td><strong>${u.name}</strong> (${u.username})</td>
                        <td>${u.email} / ${u.phone}</td>
                        <td>${statusBadge}</td>
                        <td style="font-size:12px; color:var(--text-muted);">${u.created_at}</td>
                        <td>
                            <button class="btn btn-secondary btn-sm" onclick="openUserDetailModal('${u.id}')">상세</button>
                            <button class="btn btn-warning btn-sm" onclick="openBanModal('${u.id}', '${u.name}', '${u.until || ''}')">정지 설정</button>
                        </td>
                    </tr>
                `;
            }).join('');
        }
    } catch (err) {
        tbody.innerHTML = `<tr><td colspan="6" style="text-align:center; color:var(--btn-danger-bg);">데이터 로드 실패</td></tr>`;
    }
}

// 2.1 User Detail Modal (GET /api/user/<user_id>)
async function openUserDetailModal(userId) {
    try {
        const res = await fetch(`/api/user/${userId}`);
        const data = await res.json();
        if (!data.success) {
            showToast(data.message, 'error');
            return;
        }

        const u = data.user;
        const modal = document.getElementById('userDetailModal');
        const content = document.getElementById('userDetailContent');

        let postsHtml = u.posts && u.posts.length > 0
            ? u.posts.map(p => `<li>[${p.created_at}] ${p.title} (조회수: ${p.views})</li>`).join('')
            : '<li style="color:var(--text-muted);">작성 게시글 없음</li>';

        content.innerHTML = `
            <div class="info-grid">
                <div class="info-item">
                    <span class="info-label">회원 ID / 계정</span>
                    <span class="info-val">${u.id} (${u.username})</span>
                </div>
                <div class="info-item">
                    <span class="info-label">이름</span>
                    <span class="info-val">${u.name}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">이메일</span>
                    <span class="info-val">${u.email}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">연락처</span>
                    <span class="info-val">${u.phone}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">상태 (until)</span>
                    <span class="info-val">${u.until ? '<span class="badge badge-suspended">정지만료: ' + u.until + '</span>' : '<span class="badge badge-normal">정상 (null)</span>'}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">가입일시</span>
                    <span class="info-val">${u.created_at}</span>
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
    
    if (currentUntil) {
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
        if (data.success) {
            showToast(data.message, 'success');
            closeModal('userBanModal');
            loadUsersTable();
        } else {
            showToast(data.message, 'error');
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
        const data = await res.json();

        if (data.success) {
            if (data.posts.length === 0) {
                tbody.innerHTML = `<tr><td colspan="6" style="text-align:center; color:var(--text-muted);">게시글이 없습니다.</td></tr>`;
                return;
            }

            tbody.innerHTML = data.posts.map(p => {
                return `
                    <tr>
                        <td><code>${p.id}</code></td>
                        <td><strong>${p.title}</strong></td>
                        <td>${p.author_name}</td>
                        <td>${p.category}</td>
                        <td style="font-size:12px; color:var(--text-muted);">${p.created_at}</td>
                        <td>
                            <button class="btn btn-danger btn-sm" onclick="deletePostApi('${p.id}')">삭제</button>
                        </td>
                    </tr>
                `;
            }).join('');
        }
    } catch (err) {
        tbody.innerHTML = `<tr><td colspan="6" style="text-align:center; color:var(--btn-danger-bg);">데이터 로드 실패</td></tr>`;
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
        if (data.success) {
            showToast(data.message, 'success');
            loadPostsTable();
        } else {
            showToast(data.message, 'error');
        }
    } catch (err) {
        showToast("게시글 삭제 실패", "error");
    }
}
