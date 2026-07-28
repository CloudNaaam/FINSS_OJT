package coms.fins.ojt.service;

import coms.fins.ojt.domain.MatchVO;
import coms.fins.ojt.mapper.MatchMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MatchService {

    @Autowired(required = false)
    private MatchMapper matchMapper;

    public List<MatchVO> getAllMatches() {
        if (matchMapper == null) {
            return List.of();
        }
        return matchMapper.selectAllMatches();
    }
}
