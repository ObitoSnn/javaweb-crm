package com.obitosnn.crm.workbench.dao;

import com.obitosnn.crm.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkDao {

    Integer insert(ContactsRemark contactsRemark);

    List<ContactsRemark> selectContactsRemarkList(String contactsId);

    Integer insertContactsRemark(ContactsRemark contactsRemark);

    Integer deleteContactsRemark(String id);

    Integer updateContactsRemark(ContactsRemark contactsRemark);

}
