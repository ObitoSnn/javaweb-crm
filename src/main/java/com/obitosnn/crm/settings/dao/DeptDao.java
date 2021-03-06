package com.obitosnn.crm.settings.dao;

import com.obitosnn.crm.settings.domain.Dept;

import java.util.List;
import java.util.Map;

/**
 * @author ObitoSnn
 * @Date 2021/3/1 21:46
 */
public interface DeptDao {

    List<Dept> selectDeptListForPageVo(Map<String, Object> map);

    Long selectDeptTotalForPageVo(Map<String, Object> map);

    Integer insertDept(Dept dept);

    List<String> selectDeptnoList();

    Dept selectDeptById(String id);

    Integer updateDept(Dept dept);

    Integer deleteDeptByIds(String[] id);

    Dept selectDeptByDeptno(String deptno);

    List<String> selectDeptNameList();

    String selectDeptnoByName(String name);

}
