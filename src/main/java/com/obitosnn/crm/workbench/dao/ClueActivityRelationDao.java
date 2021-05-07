package com.obitosnn.crm.workbench.dao;


import com.obitosnn.crm.workbench.domain.ClueActivityRelation;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ClueActivityRelationDao {

    Integer deleteClueActivityRelationById(String carId);

    Integer insertCarByClueIdAndActivityId(@Param("carId") String carId, @Param("cid") String cid, @Param("aid") String aid);

    List<ClueActivityRelation> selectListByClueId(String clueId);

}
