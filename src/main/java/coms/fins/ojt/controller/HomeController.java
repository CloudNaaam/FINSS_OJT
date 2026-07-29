package coms.fins.ojt.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

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
}
