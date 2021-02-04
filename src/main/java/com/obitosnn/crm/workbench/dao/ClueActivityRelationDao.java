package com.obitosnn.crm.workbench.dao;


import org.apache.ibatis.annotations.Param;

public interface ClueActivityRelationDao {

    Integer deleteClueActivityRelationById(String carId);

    Integer insertCarByClueIdAndActivityId(@Param("carId") String carId, @Param("cid") String cid, @Param("aid") String aid);

}
