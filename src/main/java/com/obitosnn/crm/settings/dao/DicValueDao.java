package com.obitosnn.crm.settings.dao;

import com.obitosnn.crm.settings.domain.DicValue;

import java.util.List;

/**
 * @Author ObitoSnn
 * @Date 2021/1/31 14:56
 */
public interface DicValueDao {

    List<DicValue> selectDicValueByCode(String code);

    List<DicValue> selectDicValueListForPageVo();

    Long selectDicValueTotalForPageVo();

    Integer insertDicValue(DicValue dicValue);

    String selectDicValueTypeCodeById(String id);

    DicValue selectDicValueDetailById(String id);

    Integer updateDicValue(DicValue dicValue);

    Integer deleteDicValueByIds(String[] ids);

}
