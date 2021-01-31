package com.obitosnn.crm.settings.dao;

import com.obitosnn.crm.settings.domain.DicType;

import java.util.List;

/**
 * @Author ObitoSnn
 * @Date 2021/1/31 14:56
 */
public interface DicTypeDao {

    List<DicType> selectAllDicType();

}
