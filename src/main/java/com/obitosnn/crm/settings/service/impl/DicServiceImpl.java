package com.obitosnn.crm.settings.service.impl;

import com.github.pagehelper.PageHelper;
import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.settings.dao.DicTypeDao;
import com.obitosnn.crm.settings.dao.DicValueDao;
import com.obitosnn.crm.settings.domain.DicType;
import com.obitosnn.crm.settings.domain.DicValue;
import com.obitosnn.crm.settings.service.DicService;
import com.obitosnn.crm.vo.PageVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author ObitoSnn
 * @Date 2021/1/31 15:00
 */
@Service
public class DicServiceImpl implements DicService {
    @Autowired
    private DicTypeDao dicTypeDao;
    @Autowired
    private DicValueDao dicValueDao;

    @Override
    public Map<String, List<DicValue>> getDicValueMap() {
        Map<String, List<DicValue>> map = new HashMap<String, List<DicValue>>();
        List<DicType> dicTypeList = dicTypeDao.selectAllDicType();
        for (DicType dicType : dicTypeList) {
            String code = dicType.getCode();
            List<DicValue> dicValuesList = dicValueDao.selectDicValueByCode(code);
            map.put(code + "List", dicValuesList);
        }
        return map;
    }

    @Override
    public PageVo<DicType> getDicTypePageVo(String pageNo, String pageSize) {
        PageVo<DicType> pageVo = new PageVo<DicType>();
        PageHelper.startPage(Integer.parseInt(pageNo), Integer.parseInt(pageSize));
        List<DicType> dataList = dicTypeDao.selectDicTypeListForPageVo();
        pageVo.setDataList(dataList);
        Long total = dicTypeDao.selectDicTypeTotalForPageVo();
        pageVo.setTotal(total);
        return pageVo;
    }

    @Override
    public boolean saveDicType(DicType dicType) throws FailToSaveException {
        Integer count = dicTypeDao.insertDicType(dicType);
        if (count.compareTo(1) != 0) {
            throw new FailToSaveException("保存字典类型失败");
        }
        return true;
    }

    @Override
    public DicType getDicTypeDetailByCode(String code) {
        return dicTypeDao.selectDicTypeDetailByCode(code);
    }

    @Override
    public boolean updateDicType(DicType dicType) throws FailToUpdateException {
        Integer count = dicTypeDao.updateDicType(dicType);
        if (count.compareTo(1) != 0) {
            throw new FailToUpdateException("更新字典类型失败");
        }
        return true;
    }

    @Override
    public boolean deleteDicTypeByCodes(String[] codes) throws FailToDeleteException {
        Integer count = dicTypeDao.deleteDicTypeByCodes(codes);
        if (count.compareTo(codes.length) != 0) {
            throw new FailToDeleteException("删除字典类型失败");
        }
        return true;
    }

}
