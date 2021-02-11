package com.obitosnn.crm.workbench.service;

import com.obitosnn.crm.vo.PageVo;
import com.obitosnn.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

/**
 * @Author ObitoSnn
 * @Date 2021/2/7 14:18
 */
public interface CustomerService {

    List<String> getCustomerName(String name);

    PageVo<Customer> getCustomerPageVo(Map<String, Object> map);

}
