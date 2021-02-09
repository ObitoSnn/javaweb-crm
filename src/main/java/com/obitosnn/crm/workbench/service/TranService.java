package com.obitosnn.crm.workbench.service;


import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.vo.PageVo;
import com.obitosnn.crm.workbench.domain.Tran;

import java.util.Map;

/**
 * @Author ObitoSnn
 * @Date 2021/2/7 11:45
 */
public interface TranService {

    boolean saveTran(Tran tran, String customerName) throws FailToSaveException ;

    PageVo<Tran> getTranPageVo(Map<String, Object> map);

    Tran getTranById(String id);

    Tran getActivityIdAndContactsIdByTranId(String id);

    boolean updateTran(Tran tran, String customerName, String editBy) throws FailToSaveException, FailToUpdateException;

    boolean deleteTranById(String id) throws FailToDeleteException;

    Tran getTranDetailById(String id);

}
