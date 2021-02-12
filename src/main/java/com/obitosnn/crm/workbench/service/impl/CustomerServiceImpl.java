package com.obitosnn.crm.workbench.service.impl;

import com.github.pagehelper.PageHelper;
import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.vo.PageVo;
import com.obitosnn.crm.workbench.dao.CustomerDao;
import com.obitosnn.crm.workbench.dao.CustomerRemarkDao;
import com.obitosnn.crm.workbench.domain.Customer;
import com.obitosnn.crm.workbench.domain.CustomerRemark;
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
    @Autowired
    private CustomerRemarkDao customerRemarkDao;

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

    @Override
    public Customer getCustomerDetailById(String id) {
        return customerDao.selectCustomerDetailById(id);
    }

    @Override
    public boolean saveCustomer(Customer customer) throws FailToSaveException {
        Integer count = customerDao.insertCustomer(customer);
        if (count != 1) {
            throw new FailToSaveException("客户保存失败");
        }
        return true;
    }

    @Override
    public Customer getCustomerById(String id) {
        return customerDao.selectCustomerById(id);
    }

    @Override
    public boolean updateCustomerById(Customer customer) throws FailToUpdateException {
        Integer count = customerDao.updateCustomerById(customer);
        if (count.compareTo(1) != 0) {
            throw new FailToUpdateException("客户信息更新失败");
        }
        return true;
    }

    @Override
    public boolean deleteCustomerByIds(String[] ids) throws FailToDeleteException {
        Integer count = customerDao.deleteCustomerByIds(ids);
        if (count.compareTo(ids.length) != 0) {
            throw new FailToDeleteException("删除失败");
        }
        return true;
    }

    @Override
    public boolean saveCustomerRemark(CustomerRemark customerRemark) throws FailToSaveException {
        Integer count = customerRemarkDao.insert(customerRemark);
        if (count.compareTo(1) != 0) {
            throw new FailToSaveException("保存备注失败");
        }
        return true;
    }

    @Override
    public List<CustomerRemark> getCustomerRemarkListByCustomerId(String id) {
        return customerRemarkDao.selectCustomerRemarkListByCustomerId(id);
    }

    @Override
    public boolean deleteCustomerRemarkById(String id) throws FailToDeleteException {
        Integer count = customerRemarkDao.deleteCustomerRemarkById(id);
        if (count != 1) {
            throw new FailToDeleteException("删除失败");
        }
        return true;
    }

    @Override
    public boolean updateCustomerRemark(CustomerRemark customerRemark) throws FailToUpdateException {
        Integer count = customerRemarkDao.updateCustomerRemarkById(customerRemark);
        if (count != 1) {
            throw new FailToUpdateException("备注修改失败");
        }
        return true;
    }


}
