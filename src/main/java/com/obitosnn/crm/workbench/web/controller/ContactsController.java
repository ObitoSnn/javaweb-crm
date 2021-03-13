package com.obitosnn.crm.workbench.web.controller;

import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.settings.domain.User;
import com.obitosnn.crm.settings.service.UserService;
import com.obitosnn.crm.util.DateTimeUtil;
import com.obitosnn.crm.util.UUIDUtil;
import com.obitosnn.crm.vo.PageVo;
import com.obitosnn.crm.workbench.domain.Contacts;
import com.obitosnn.crm.workbench.service.ContactsService;
import com.obitosnn.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author ObitoSnn
 * @Date 2021/3/11 13:05
 */
@Controller
@RequestMapping("/workbench/contacts")
public class ContactsController {
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private UserService userService;
    @Autowired
    private CustomerService customerService;

    @RequestMapping(value = {"/pageList"})
    @ResponseBody
    public PageVo<Contacts> pageList(HttpServletRequest request) {
        Map<String, Object> map = new HashMap<String, Object>();
        String pageNo = request.getParameter("pageNo");
        map.put("pageNo", pageNo);
        String pageSize = request.getParameter("pageSize");
        map.put("pageSize", pageSize);
        String fullname = request.getParameter("fullname");
        map.put("fullname", fullname);
        String customerName = request.getParameter("customerId");
        map.put("customerName", customerName);
        String ownerName = request.getParameter("owner");
        map.put("ownerName", ownerName);
        String source = request.getParameter("source");
        map.put("source", source);
        String birth = request.getParameter("birth");
        map.put("birth", birth);
        return contactsService.getContactsPageVo(map);
    }

    @RequestMapping(value = {"/getUserList"})
    @ResponseBody
    public List<User> getUserList() {
        return userService.getUserList();
    }

    @RequestMapping(value = {"/getCustomerName"})
    @ResponseBody
    public List<String> getCustomerName(String name) {
        return customerService.getCustomerName(name);
    }

    @RequestMapping(value = {"/saveContacts"})
    @ResponseBody
    public Map<String, Object> saveContacts(HttpServletRequest request, Contacts contacts, String customerName) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        contacts.setId(UUIDUtil.getUUID());
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        contacts.setCreateBy(createBy);
        String createTime = DateTimeUtil.getSysTime();
        contacts.setCreateTime(createTime);
        boolean success = false;
        try {
            success = contactsService.saveContacts(contacts, customerName);
        } catch (FailToSaveException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        return map;
    }

}
