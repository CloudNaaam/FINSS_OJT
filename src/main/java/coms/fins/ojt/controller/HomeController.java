package coms.fins.ojt.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("message", "hello?");
        return "index";
    }

    @GetMapping("/mypage")
    public String mypage() {
        return "mypage";
    }

    @GetMapping("/mypage/apply")
    public String mypageApply() {
        return "manager-apply";
    }

    @GetMapping("/mypage/apply/myapply")
    public String mypageMyApply() {
        return "manager-myapply";
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
}
