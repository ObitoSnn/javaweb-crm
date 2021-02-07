package com.obitosnn.crm.workbench.dao;

import com.obitosnn.crm.workbench.domain.Customer;

import java.util.List;

public interface CustomerDao {

    Customer selectByName(String name);

    Integer insert(Customer customer);

    List<String> selectNameListByName(String name);

}
