package com.obitosnn.crm.settings.service.impl;

import com.obitosnn.crm.settings.dao.DicTypeDao;
import com.obitosnn.crm.settings.dao.DicValueDao;
import com.obitosnn.crm.settings.service.DicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
}
