package com.obitosnn.crm.workbench.dao;

import com.obitosnn.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryDao {

    Integer insert(TranHistory tranHistory);

    List<TranHistory> selectTranHistoryListByTranId(String tranId);

}
