package com.obitosnn.crm.workbench.service;

import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.workbench.domain.Contacts;

import java.util.List;

/**
 * @Author ObitoSnn
 * @Date 2021/2/7 17:43
 */
public interface ContactsService {

    List<Contacts> getContactByName(String contactName);

    List<Contacts> getContactsList();

    boolean deleteContactsByIds(String[] ids) throws FailToDeleteException;

    boolean saveContacts(Contacts contacts, String customerName) throws FailToSaveException;

}
