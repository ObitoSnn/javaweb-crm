package com.obitosnn.crm.workbench.service.impl;

import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.workbench.dao.ClueDao;
import com.obitosnn.crm.workbench.domain.Clue;
import com.obitosnn.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @Author ObitoSnn
 * @Date 2021/1/31 14:11
 */
@Service
public class ClueServiceImpl implements ClueService {
    @Autowired
    private ClueDao clueDao;

    @Override
    public boolean saveClue(Clue clue) throws FailToSaveException {
        Integer count = clueDao.insertClue(clue);
        if (count != 1) {
            throw new FailToSaveException("线索保存失败");
        }
        return true;
    }

}
