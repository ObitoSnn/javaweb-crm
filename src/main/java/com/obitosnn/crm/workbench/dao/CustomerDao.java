package com.obitosnn.crm.workbench.dao;

import com.obitosnn.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerDao {

    Customer selectByName(String name);

    Integer insert(Customer customer);

    List<String> selectNameListByName(String name);

    List<Customer> selectCustomerListForPageVo(Map<String, Object> map);

    Long selectCustomerTotalForPageVo(Map<String, Object> map);

    Customer selectCustomerDetailById(String id);

    Integer insertCustomer(Customer customer);

    Customer selectCustomerById(String id);

    Integer updateCustomerById(Customer customer);

    Integer deleteCustomerByIds(String[] ids);

}
