package com.obitosnn.crm.workbench.dao;

import com.obitosnn.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {

    Integer insert(Tran tran);

    List<Tran> selectTranListForPageVo(Map<String, Object> map);

    Long selectTranTotalForPageVo(Map<String, Object> map);

    Tran selectTranById(String id);

    Tran selectTranForActivityIdAndContactsId(String id);

    Integer updateById(Tran tran);

    Tran selectTranDetailById(String id);

    Integer deleteTranByIds(String[] ids);

    Integer updateTranStageById(Tran tran);

    List<Map<String, Object>> selectForCharts();

    List<Tran> selectTranListByCustomerId(String customerId);

}
