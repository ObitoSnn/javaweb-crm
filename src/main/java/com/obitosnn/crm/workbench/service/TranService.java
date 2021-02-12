package com.obitosnn.crm.workbench.service;


import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.vo.PageVo;
import com.obitosnn.crm.workbench.domain.Tran;
import com.obitosnn.crm.workbench.domain.TranHistory;
import com.obitosnn.crm.workbench.domain.TranRemark;

import java.util.List;
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

    Tran getTranDetailById(String id);

    List<TranHistory> getTranHistoryListByTranId(String tranId);

    boolean saveTranRemark(TranRemark tranRemark) throws FailToSaveException;

    TranRemark getTranRemarkById(String id);

    List<TranRemark> getTranRemarkListByTranId(String id);

    boolean deleteTranRemarkById(String id) throws FailToDeleteException;

    boolean updateTranRemark(TranRemark tranRemark) throws FailToUpdateException;

    boolean deleteTranByIds(String[] ids) throws FailToDeleteException;

    boolean updateTranStage(Tran tran) throws FailToUpdateException, FailToSaveException;

    List<Map<String, Object>> getCharts();

    List<Tran> getTranList();

}
