package com.obitosnn.crm.workbench.dao;

import com.obitosnn.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {

    Integer insert(Tran tran);

    List<Tran> selectTranListForPageVo(Map<String, Object> map);

    Long selectTranTotalForPageVo(Map<String, Object> map);

}
