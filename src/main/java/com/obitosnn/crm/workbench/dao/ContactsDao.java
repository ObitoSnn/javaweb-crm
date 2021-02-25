package com.obitosnn.crm.workbench.dao;

import com.obitosnn.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsDao {

    Integer insert(Contacts contacts);

    List<Contacts> selectContactByName(String contactName);

    Integer deleteContactsByIds(String[] ids);

    List<Contacts> selectContactsListByCustomerId(String customerId);

}
