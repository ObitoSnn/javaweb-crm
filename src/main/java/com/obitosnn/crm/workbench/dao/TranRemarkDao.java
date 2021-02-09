package com.obitosnn.crm.workbench.dao;

import com.obitosnn.crm.workbench.domain.TranRemark;

import java.util.List;

/**
 * @Author ObitoSnn
 * @Date 2021/2/9 19:07
 */
public interface TranRemarkDao {

    Integer insertTranRemark(TranRemark tranRemark);

    TranRemark selectTranRemarkById(String id);

    List<TranRemark> selectTranRemarkListByTranId(String id);

    Integer deleteTranRemarkById(String id);

    Integer updateTranRemarkById(TranRemark tranRemark);

}
