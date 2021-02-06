package com.obitosnn.crm.workbench.dao;

import com.obitosnn.crm.workbench.domain.Customer;

public interface CustomerDao {

    Customer selectByName(String company);

    Integer insert(Customer customer);

}
