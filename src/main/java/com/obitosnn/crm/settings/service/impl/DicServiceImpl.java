package com.obitosnn.crm.settings.service.impl;

import com.obitosnn.crm.settings.dao.DicTypeDao;
import com.obitosnn.crm.settings.dao.DicValueDao;
import com.obitosnn.crm.settings.domain.DicType;
import com.obitosnn.crm.settings.domain.DicValue;
import com.obitosnn.crm.settings.service.DicService;
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

}
