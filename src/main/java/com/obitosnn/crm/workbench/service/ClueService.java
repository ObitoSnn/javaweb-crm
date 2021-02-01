package com.obitosnn.crm.workbench.service;

import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.workbench.domain.Clue;

/**
 * @Author ObitoSnn
 * @Date 2021/1/31 14:11
 */
public interface ClueService {

    boolean saveClue(Clue clue) throws FailToSaveException;

}
