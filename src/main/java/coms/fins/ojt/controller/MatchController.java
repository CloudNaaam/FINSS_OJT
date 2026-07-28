package coms.fins.ojt.controller;

import coms.fins.ojt.domain.MatchVO;
import coms.fins.ojt.service.MatchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class MatchController {

    @Autowired
    private MatchService matchService;

    @GetMapping("/api/matches")
    @ResponseBody
    public ResponseEntity<List<MatchVO>> getAllMatches() {
        List<MatchVO> matches = matchService.getAllMatches();
        return ResponseEntity.ok(matches);
    }
}
