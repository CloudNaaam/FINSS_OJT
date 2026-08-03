package coms.fins.ojt.controller;

import coms.fins.ojt.domain.MatchVO;
import coms.fins.ojt.service.MatchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.File;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@RestController
@RequestMapping("/api/matches")
public class MatchController {

    @Autowired
    private MatchService matchService;

    @GetMapping
    public ResponseEntity<List<MatchVO>> getAllMatches() {
        List<MatchVO> matches = matchService.getAllMatches();
        return ResponseEntity.ok(matches);
    }

    @GetMapping("/{matchId}")
    public ResponseEntity<MatchVO> getMatchById(@PathVariable("matchId") Long matchId) {
        MatchVO match = matchService.getMatchById(matchId);
        if (match != null) {
            return ResponseEntity.ok(match);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/{matchId}/highlight_download")
    public ResponseEntity<Resource> downloadHighlight(
            @PathVariable("matchId") Long matchId,
            @RequestParam(value = "output_name", required = false) String outputName) {

        File videoFile = matchService.compressAndGetHighlightVideo(matchId, outputName);

        if (videoFile == null || !videoFile.exists()) {
            return ResponseEntity.notFound().build();
        }

        Resource resource = new FileSystemResource(videoFile);

        String downloadName = (outputName != null && !outputName.isBlank()) ? outputName.trim() : videoFile.getName();
        if (!downloadName.toLowerCase().endsWith(".mp4")) {
            downloadName += ".mp4";
        }

        String encodedFilename = URLEncoder.encode(downloadName, StandardCharsets.UTF_8).replaceAll("\\+", "%20");

        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType("video/mp4"))
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFilename + "\"; filename*=UTF-8''" + encodedFilename)
                .body(resource);
    }
}
