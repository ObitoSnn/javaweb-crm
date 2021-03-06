package com.obitosnn.crm.settings.service;

import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.settings.domain.Dept;
import com.obitosnn.crm.vo.PageVo;

import java.util.List;
import java.util.Map;

/**
 * @author ObitoSnn
 * @Date 2021/3/1 21:45
 */
public interface DeptService {

    PageVo<Dept> getDeptPageVo(Map<String, Object> map);

    boolean saveDept(Dept dept) throws FailToSaveException;

    Dept getDeptById(String id);

    boolean updateDept(Dept dept) throws FailToUpdateException;

    boolean deleteDeptByIds(String[] id) throws FailToDeleteException;

    List<String> getDeptNameList();

}
