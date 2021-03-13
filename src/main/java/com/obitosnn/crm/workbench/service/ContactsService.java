package com.obitosnn.crm.workbench.service;

import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.vo.PageVo;
import com.obitosnn.crm.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

/**
 * @Author ObitoSnn
 * @Date 2021/2/7 17:43
 */
public interface ContactsService {

    List<Contacts> getContactByName(String contactName);

    boolean deleteContactsByIds(String[] ids) throws FailToDeleteException;

    boolean saveContacts(Contacts contacts, String customerName) throws FailToSaveException;

    List<Contacts> getContactsListByCustomerId(String customerId);

    PageVo<Contacts> getContactsPageVo(Map<String, Object> map);

    Contacts getContactsById(String id);

    boolean updateContacts(Contacts contacts) throws FailToUpdateException;

}
