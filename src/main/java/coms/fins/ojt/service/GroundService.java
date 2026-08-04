package coms.fins.ojt.service;

import coms.fins.ojt.domain.GroundVO;
import coms.fins.ojt.mapper.GroundMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class GroundService {

    @Autowired
    private GroundMapper groundMapper;

    @Transactional
    public boolean addGround(GroundVO ground) {
        if (ground == null || ground.getManagerId() == null || ground.getName() == null || ground.getAddress() == null) {
            return false;
        }
        int rows = groundMapper.insertGround(ground);
        return rows > 0;
    }

    @Transactional
    public boolean updateGround(GroundVO ground) {
        if (ground == null || ground.getGroundId() == null || ground.getManagerId() == null) {
            return false;
        }
        int rows = groundMapper.updateGround(ground);
        return rows > 0;
    }

    public List<GroundVO> getGroundsByManager(Long managerId) {
        if (managerId == null) {
            return List.of();
        }
        return groundMapper.selectGroundsByManagerId(managerId);
    }

    public GroundVO getGroundById(Long groundId) {
        if (groundId == null) {
            return null;
        }
        return groundMapper.selectGroundById(groundId);
    }
}
