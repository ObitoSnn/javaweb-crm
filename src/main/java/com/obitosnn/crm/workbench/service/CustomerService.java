package com.obitosnn.crm.workbench.service;

import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.vo.PageVo;
import com.obitosnn.crm.workbench.domain.Customer;
import com.obitosnn.crm.workbench.domain.CustomerRemark;

import java.util.List;
import java.util.Map;

/**
 * @Author ObitoSnn
 * @Date 2021/2/7 14:18
 */
public interface CustomerService {

    List<String> getCustomerName(String name);

    PageVo<Customer> getCustomerPageVo(Map<String, Object> map);

    Customer getCustomerDetailById(String id);

    boolean saveCustomer(Customer customer) throws FailToSaveException;

    Customer getCustomerById(String id);

    boolean updateCustomerById(Customer customer) throws FailToUpdateException;

    boolean deleteCustomerByIds(String[] ids) throws FailToDeleteException;

    boolean saveCustomerRemark(CustomerRemark customerRemark) throws FailToSaveException;

    List<CustomerRemark> getCustomerRemarkListByCustomerId(String id);

    boolean deleteCustomerRemarkById(String id) throws FailToDeleteException;

    boolean updateCustomerRemark(CustomerRemark customerRemark) throws FailToUpdateException;

}
