package com.obitosnn.crm.workbench.service.impl;

import com.obitosnn.crm.workbench.dao.ContactsDao;
import com.obitosnn.crm.workbench.domain.Contacts;
import com.obitosnn.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Author ObitoSnn
 * @Date 2021/2/7 17:44
 */
@Service
public class ContactsServiceImpl implements ContactsService {
    @Autowired
    private ContactsDao contactsDao;

    @Override
    public List<Contacts> getContactByName(String contactName) {
        return contactsDao.selectContactByName(contactName);
    }

}
