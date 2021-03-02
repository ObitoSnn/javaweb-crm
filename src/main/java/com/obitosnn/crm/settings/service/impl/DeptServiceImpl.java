package com.obitosnn.crm.settings.service.impl;

import com.github.pagehelper.PageHelper;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.settings.dao.DeptDao;
import com.obitosnn.crm.settings.domain.Dept;
import com.obitosnn.crm.settings.service.DeptService;
import com.obitosnn.crm.vo.PageVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @author ObitoSnn
 * @Date 2021/3/1 21:45
 */
@Service
public class DeptServiceImpl implements DeptService {
    @Autowired
    private DeptDao deptDao;

    @Override
    public PageVo<Dept> getDeptPageVo(Map<String, Object> map) {
        PageVo<Dept> pageVo = null;
        try {
            pageVo = new PageVo<Dept>();
            int pageNo = Integer.parseInt((String) map.get("pageNo"));
            int pageSize = Integer.parseInt((String) map.get("pageSize"));
            PageHelper.startPage(pageNo, pageSize);
            List<Dept> dataList = deptDao.selectDeptListForPageVo(map);
            pageVo.setDataList(dataList);
            Long total = deptDao.selectDeptTotalForPageVo(map);
            pageVo.setTotal(total);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
        return pageVo;
    }

    @Override
    public boolean saveDept(Dept dept) throws FailToSaveException {
        List<String> list = deptDao.selectDeptnoList();
        for (String s : list) {
            if (s.equals(dept.getDeptno())) {
                throw new FailToSaveException("编号已存在，保存失败");
            }
        }
        Integer count = deptDao.insertDept(dept);
        if (count.compareTo(1) != 0) {
            throw new FailToSaveException("保存失败");
        }
        return true;
    }

}
