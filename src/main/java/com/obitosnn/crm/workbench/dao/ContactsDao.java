package com.obitosnn.crm.workbench.dao;

import com.obitosnn.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsDao {

    Integer insert(Contacts contacts);

    List<Contacts> selectContactByName(String contactName);

    List<Contacts> selectContactsList();

    Integer deleteContactsByIds(String[] ids);

}
