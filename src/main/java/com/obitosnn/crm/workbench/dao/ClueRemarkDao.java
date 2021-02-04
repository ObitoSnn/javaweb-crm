package com.obitosnn.crm.workbench.dao;

import com.obitosnn.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    Integer insertClueRemark(ClueRemark clueRemark);

    ClueRemark selectClueRemarkById(String id);

    List<ClueRemark> selectClueRemarkListByClueId(String id);

    Integer updateClueRemarkById(ClueRemark clueRemark);

    Integer deleteClueRemarkById(String id);

}
