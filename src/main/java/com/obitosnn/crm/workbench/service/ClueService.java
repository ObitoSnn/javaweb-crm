package com.obitosnn.crm.workbench.service;

import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.vo.PageVo;
import com.obitosnn.crm.workbench.domain.Clue;

import java.util.Map;

/**
 * @Author ObitoSnn
 * @Date 2021/1/31 14:11
 */
public interface ClueService {

    boolean saveClue(Clue clue) throws FailToSaveException;

    PageVo<Clue> getCluePageVo(Map<String, Object> map);

    Clue getClueDetailById(String id);

    Clue getClueById(String id);

    boolean deleteClueByIds(String[] ids) throws FailToDeleteException;

    boolean updateClueById(Clue clue) throws FailToUpdateException;

}
