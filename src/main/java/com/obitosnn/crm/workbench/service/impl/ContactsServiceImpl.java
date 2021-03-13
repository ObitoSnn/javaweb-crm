package com.obitosnn.crm.workbench.service.impl;

import com.github.pagehelper.PageHelper;
import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.util.DateTimeUtil;
import com.obitosnn.crm.util.UUIDUtil;
import com.obitosnn.crm.vo.PageVo;
import com.obitosnn.crm.workbench.dao.ContactsDao;
import com.obitosnn.crm.workbench.dao.CustomerDao;
import com.obitosnn.crm.workbench.domain.Contacts;
import com.obitosnn.crm.workbench.domain.Customer;
import com.obitosnn.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @Author ObitoSnn
 * @Date 2021/2/7 17:44
 */
@Service
public class ContactsServiceImpl implements ContactsService {
    @Autowired
    private ContactsDao contactsDao;
    @Autowired
    private CustomerDao customerDao;

    @Override
    public List<Contacts> getContactByName(String contactName) {
        return contactsDao.selectContactByName(contactName);
    }

    @Override
    public boolean deleteContactsByIds(String[] ids) throws FailToDeleteException {
        Integer count = contactsDao.deleteContactsByIds(ids);
        if (count.compareTo(ids.length) != 0) {
            throw new FailToDeleteException("删除失败");
        }
        return true;
    }

    @Override
    public boolean saveContacts(Contacts contacts, String customerName) throws FailToSaveException {
        Customer customer = customerDao.selectByName(customerName);
        if (customer == null) {
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(contacts.getOwner());
            customer.setName(customerName);
            customer.setCreateBy(contacts.getCreateBy());
            customer.setCreateTime(DateTimeUtil.getSysTime());
            Integer insertCustomerCount = customerDao.insert(customer);
            if (insertCustomerCount.compareTo(1) != 0) {
                throw new FailToSaveException("客户保存失败");
            }
        }
        //客户存在
        contacts.setCustomerId(customer.getId());
        Integer count = contactsDao.insert(contacts);
        if (count.compareTo(1) != 0) {
            throw new FailToSaveException("联系人保存失败");
        }
        return true;
    }

    @Override
    public List<Contacts> getContactsListByCustomerId(String customerId) {
        return contactsDao.selectContactsListByCustomerId(customerId);
    }

    @Override
    public PageVo<Contacts> getContactsPageVo(Map<String, Object> map) {
        int pageNo = Integer.parseInt((String) map.get("pageNo"));
        int pageSize =  Integer.parseInt((String) map.get("pageSize"));
        PageHelper.startPage(pageNo, pageSize);
        List<Contacts> aList = contactsDao.selectContactsListForPageVo(map);
        PageVo<Contacts> pageVo = new PageVo<>();
        Long total = contactsDao.selectContactsTotalForPageVo(map);
        pageVo.setTotal(total);
        pageVo.setDataList(aList);
        return pageVo;
    }

    @Override
    public Contacts getContactsById(String id) {
        return contactsDao.selectContactsById(id);
    }

    @Override
    public boolean updateContacts(Contacts contacts) throws FailToUpdateException {
        Customer cust = customerDao.selectByName(contacts.getCustomerId());
        if (cust == null) {
            cust = new Customer();
            cust.setId(UUIDUtil.getUUID());
            cust.setOwner(contacts.getOwner());
            cust.setName(contacts.getCustomerId());
            cust.setCreateBy(contacts.getEditBy());
            cust.setCreateTime(DateTimeUtil.getSysTime());
            Integer custCount = customerDao.insert(cust);
            if (custCount.compareTo(1) != 0) {
                throw new FailToUpdateException("更新失败");
            }
        }
        contacts.setCustomerId(cust.getId());
        Integer count = contactsDao.updateContacts(contacts);
        if (count.compareTo(1) != 0) {
            throw new FailToUpdateException("更新失败");
        }
        return true;
    }

}
