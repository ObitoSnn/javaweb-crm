package com.obitosnn.crm.settings.service;

import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.settings.domain.DicType;
import com.obitosnn.crm.settings.domain.DicValue;
import com.obitosnn.crm.vo.PageVo;

import java.util.List;
import java.util.Map;

/**
 * @Author ObitoSnn
 * @Date 2021/1/31 14:59
 */
public interface DicService {

    Map<String, List<DicValue>> getDicValueMap();

    PageVo<DicType> getDicTypePageVo(String pageNo, String pageSize);

    boolean saveDicType(DicType dicType) throws FailToSaveException;

    DicType getDicTypeDetailByCode(String code);

    boolean updateDicType(DicType dicType) throws FailToUpdateException;

    boolean deleteDicTypeByCodes(String[] codes) throws FailToDeleteException;

    PageVo<DicValue> getDicValuePageVo(String pageNo, String pageSize);

    List<Map<String, Object>> getDicTypeCode();

    boolean saveDicValue(DicValue dicValue) throws FailToSaveException;

    String getDicValueTypeCodeById(String id);

    DicValue getDicValueDetailById(String id);

    boolean updateDicValue(DicValue dicValue) throws FailToUpdateException;

    boolean deleteDicValueByIds(String[] ids) throws FailToDeleteException;

}
