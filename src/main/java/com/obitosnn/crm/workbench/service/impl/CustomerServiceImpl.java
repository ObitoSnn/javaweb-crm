package com.obitosnn.crm.workbench.service.impl;

import com.obitosnn.crm.workbench.dao.CustomerDao;
import com.obitosnn.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Author ObitoSnn
 * @Date 2021/2/7 14:18
 */
@Service
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerDao customerDao;

    @Override
    public List<String> getCustomerName(String name) {
        return customerDao.selectNameListByName(name);
    }

}
