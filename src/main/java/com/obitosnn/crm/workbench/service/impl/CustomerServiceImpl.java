package com.obitosnn.crm.workbench.service.impl;

import com.github.pagehelper.PageHelper;
import com.obitosnn.crm.vo.PageVo;
import com.obitosnn.crm.workbench.dao.CustomerDao;
import com.obitosnn.crm.workbench.domain.Customer;
import com.obitosnn.crm.workbench.domain.Tran;
import com.obitosnn.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

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

    @Override
    public PageVo<Customer> getCustomerPageVo(Map<String, Object> map) {
        int pageNo = Integer.parseInt((String) map.get("pageNo"));
        int pageSize =  Integer.parseInt((String) map.get("pageSize"));
        PageHelper.startPage(pageNo, pageSize);
        List<Customer> aList = customerDao.selectCustomerListForPageVo(map);
        PageVo<Customer> pageVo = new PageVo<>();
        Long total = customerDao.selectCustomerTotalForPageVo(map);
        pageVo.setTotal(total);
        pageVo.setDataList(aList);
        return pageVo;
    }

}
