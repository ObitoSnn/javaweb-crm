package com.obitosnn.crm.settings.dao;

import com.obitosnn.crm.settings.domain.DicType;

import java.util.List;
import java.util.Map;

/**
 * @Author ObitoSnn
 * @Date 2021/1/31 14:56
 */
public interface DicTypeDao {

    List<DicType> selectAllDicType();

    List<DicType> selectDicTypeListForPageVo();

    Long selectDicTypeTotalForPageVo();

    Integer insertDicType(DicType dicType);

    DicType selectDicTypeDetailByCode(String code);

    Integer updateDicType(DicType dicType);

    Integer deleteDicTypeByCodes(String[] codes);

    List<Map<String, Object>> selectDicTypeCode();

}
