package com.obitosnn.crm.workbench.dao;

import com.obitosnn.crm.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsDao {

    Integer insert(Contacts contacts);

    List<Contacts> selectContactByName(String contactName);

    Integer deleteContactsByIds(String[] ids);

    List<Contacts> selectContactsListByCustomerId(String customerId);

    List<Contacts> selectContactsListForPageVo(Map<String, Object> map);

    Long selectContactsTotalForPageVo(Map<String, Object> map);

    Contacts selectContactsById(String id);

    Integer updateContacts(Contacts contacts);

}
