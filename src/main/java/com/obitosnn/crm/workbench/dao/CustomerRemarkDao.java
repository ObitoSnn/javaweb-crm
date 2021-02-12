package com.obitosnn.crm.workbench.dao;

import com.obitosnn.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkDao {

    Integer insert(CustomerRemark customerRemark);

    List<CustomerRemark> selectCustomerRemarkListByCustomerId(String id);

    Integer deleteCustomerRemarkById(String id);

    Integer updateCustomerRemarkById(CustomerRemark customerRemark);

}
