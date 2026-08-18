package coms.fins.ojt.controller;

import coms.fins.ojt.domain.UserVO;
import coms.fins.ojt.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class HomeController {

    @Autowired
    private UserService userService;

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("message", "hello?");
        return "index";
    }

    @GetMapping("/mypage")
    public String mypage(
            @RequestParam(value = "user", required = false) String userKeyword,
            Model model) {

        if (userKeyword != null && !userKeyword.isBlank()) {
            String keyword = userKeyword.trim();
            List<UserVO> users = userService.searchUsers(keyword);

            // 서버 단에서 문자열 조립 (StringBuilder)
            StringBuilder sb = new StringBuilder();
            sb.append("<div class=\"user-search-results-box\" style=\"margin: 20px 24px; padding: 20px; background: #fff; border-radius: 16px; border: 1px solid var(--line); box-shadow: 0 4px 12px rgba(0,0,0,0.03);\">");
            sb.append("<h3 style=\"font-size: 16px; font-weight: 700; margin: 0 0 14px 0; color: var(--ink); display: flex; align-items: center; justify-content: space-between;\">");
            sb.append("<span>🔍 \"<span style=\"color: var(--blue);\">").append(keyword).append("</span>\" 유저 검색 결과</span>");
            sb.append("<span style=\"font-size: 13px; font-weight: 600; color: var(--muted);\">총 ").append(users.size()).append("명</span>");
            sb.append("</h3>");

            if (users.isEmpty()) {
                sb.append("<p style=\"padding: 24px 0; text-align: center; color: #94a3b8; font-size: 14px; margin: 0;\">검색어와 일치하는 유저가 존재하지 않습니다.</p>");
            } else {
                sb.append("<ul style=\"list-style: none; padding: 0; margin: 0; display: flex; flex-direction: column; gap: 10px;\">");
                for (UserVO u : users) {
                    String managerBadge = (u.getIsManager() != null && u.getIsManager() == 1) ? "<span style=\"font-size: 11px; padding: 2px 6px; background: #e0f2fe; color: #0284c7; border-radius: 4px; font-weight: 700; margin-left: 6px;\">구장 매니저</span>" : "";
                    String nameStr = (u.getName() != null && !u.getName().isBlank()) ? u.getName() : "이름 없음";
                    String emailStr = (u.getEmail() != null && !u.getEmail().isBlank()) ? u.getEmail() : "이메일 미등록";

                    sb.append("<li style=\"display: flex; align-items: center; justify-content: space-between; padding: 14px 16px; background: #f8fafc; border-radius: 12px; border: 1px solid #f1f5f9;\">")
                      .append("<div>")
                      .append("<div style=\"font-size: 15px; font-weight: 700; color: var(--ink);\">").append(escapeHtml(u.getUsername())).append(managerBadge).append("</div>")
                      .append("<div style=\"font-size: 13px; color: var(--muted); margin-top: 3px;\">👤 ").append(escapeHtml(nameStr)).append("</div>")
                      .append("</div>")
                      .append("<div style=\"font-size: 12px; color: #64748b;\">").append(escapeHtml(emailStr)).append("</div>")
                      .append("</li>");
                }
                sb.append("</ul>");
            }
            sb.append("</div>");

            model.addAttribute("userKeyword", keyword);
            model.addAttribute("userSearchResultHtml", sb.toString());
        }

        return "mypage";
    }

    private String escapeHtml(String input) {
        if (input == null) return "";
        return input.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }

    @GetMapping("/mypage/apply")
    public String mypageApply() {
        return "manager-apply";
    }

    @GetMapping("/mypage/apply/myapply")
    public String mypageMyApply() {
        return "manager-myapply";
    }

    @GetMapping("/gm")
    public String stadiumManager(
            @CookieValue(value = "user_id", required = false) String userIdCookie,
            HttpServletRequest request,
            HttpServletResponse response) {

        Long userId = null;
        if (userIdCookie != null && !userIdCookie.isBlank()) {
            try {
                userId = Long.parseLong(userIdCookie.trim());
            } catch (NumberFormatException ignored) {}
        }

        if (userId == null) {
            String authHeader = request.getHeader("Authorization");
            String token = (authHeader != null && authHeader.startsWith("Bearer ")) ? authHeader.substring(7).trim() : request.getParameter("access_token");
            if (token != null && !token.isBlank()) {
                userId = coms.fins.ojt.util.JwtTokenProvider.getUserIdFromToken(token);
            }
        }

        boolean isManager = false;
        if (userId != null) {
            UserVO user = userService.getUserById(userId);
            if (user != null && user.getIsManager() != null && user.getIsManager() == 1) {
                isManager = true;
            }
        }

        // 매니저 권한이 없는 경우 302 Location: / 리다이렉트 응답 헤더를 설정하되,
        // 뷰 렌더링을 중단하지 않고 stadium-manager 본문도 함께 응답 바디에 출력
        if (!isManager) {
            response.setStatus(HttpServletResponse.SC_FOUND); // 302 Found
            response.setHeader("Location", "/");
        }

        return "stadium-manager";
    }

    @GetMapping("/gm/add")
    public String stadiumAdd() {
        return "stadium-add";
    }

    @GetMapping("/gm/mod")
    public String stadiumMod() {
        return "stadium-mod";
    }

    @GetMapping("/register")
    public String register() {
        return "register";
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping("/findpw")
    public String findpw() {
        return "findpw";
    }

    @GetMapping("/findpw/temp_pw")
    public String tempPw() {
        return "temp_pw";
    }

    @GetMapping("/matches/{matchId}")
    public String matchDetail(@PathVariable("matchId") Long matchId, Model model) {
        model.addAttribute("matchId", matchId);
        return "match-detail";
    }

    @GetMapping("/rules")
    public String rules() {
        return "rules";
    }
}
