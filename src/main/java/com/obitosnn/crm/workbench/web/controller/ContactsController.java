package com.obitosnn.crm.workbench.web.controller;

import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.settings.domain.User;
import com.obitosnn.crm.settings.service.UserService;
import com.obitosnn.crm.util.DateTimeUtil;
import com.obitosnn.crm.util.UUIDUtil;
import com.obitosnn.crm.vo.PageVo;
import com.obitosnn.crm.workbench.domain.Contacts;
import com.obitosnn.crm.workbench.domain.ContactsRemark;
import com.obitosnn.crm.workbench.domain.Tran;
import com.obitosnn.crm.workbench.service.ContactsService;
import com.obitosnn.crm.workbench.service.CustomerService;
import com.obitosnn.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

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
    @Autowired
    private TranService tranService;

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

    @RequestMapping(value = "/getUserListAndContactsById")
    @ResponseBody
    public Map<String, Object> getUserListAndContactsById(@RequestParam("contactsId") String id) {
        Map<String, Object> map = new HashMap<String, Object>();
        List<User> uList = userService.getUserList();
        Contacts contacts = contactsService.getContactsById(id);
        map.put("uList", uList);
        map.put("contacts", contacts);
        return map;
    }

    @RequestMapping("/updateContacts")
    @ResponseBody
    public Map<String, Object> updateContacts(HttpServletRequest request, Contacts contacts) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        String editBy = ((User) request.getSession().getAttribute("user")).getName();
        contacts.setEditBy(editBy);
        String editTime = DateTimeUtil.getSysTime();
        contacts.setEditTime(editTime);
        boolean success = false;
        try {
            success = contactsService.updateContacts(contacts);
        } catch (FailToUpdateException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        return map;
    }

    @RequestMapping("/deleteContacts")
    @ResponseBody
    public Map<String, Object> deleteContacts(String[] id) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        boolean success = false;
        try {
            success = contactsService.deleteContactsByIds(id);
        } catch (FailToDeleteException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        return map;
    }

    @RequestMapping("/detail")
    public ModelAndView detail(String id) {
        ModelAndView mv = new ModelAndView();
        Contacts contacts = contactsService.getContactsDetail(id);
        mv.addObject("contacts", contacts);
        mv.setViewName("forward:/pages/workbench/contacts/detail.jsp");
        return mv;
    }

    @RequestMapping("/getContactsRemarkList")
    @ResponseBody
    public List<ContactsRemark> getContactsRemarkList(@RequestParam("id") String contactsId) {
        return contactsService.getContactsRemarkList(contactsId);
    }

    @RequestMapping("/saveContactsRemark")
    @ResponseBody
    public Map<String, Object> saveContactsRemark(HttpServletRequest request, ContactsRemark contactsRemark) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        contactsRemark.setId(UUIDUtil.getUUID());
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        contactsRemark.setCreateBy(createBy);
        String createTime = DateTimeUtil.getSysTime();
        contactsRemark.setCreateTime(createTime);
        contactsRemark.setEditFlag("0");
        boolean success = false;
        try {
            success = contactsService.saveContactsRemark(contactsRemark);
        } catch (FailToSaveException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        map.put("contactsRemark", contactsRemark);
        return map;
    }

    @RequestMapping("/deleteContactsRemark")
    @ResponseBody
    public Map<String, Object> deleteContactsRemark(String id) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        boolean success = false;
        try {
            success = contactsService.deleteContactsRemark(id);
        } catch (FailToDeleteException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        return map;
    }

    @RequestMapping("updateContactsRemark")
    @ResponseBody
    public Map<String, Object> updateContactsRemark(HttpServletRequest request, ContactsRemark contactsRemark) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        String editBy = ((User) request.getSession().getAttribute("user")).getName();
        contactsRemark.setEditBy(editBy);
        String editTime = DateTimeUtil.getSysTime();
        contactsRemark.setEditTime(editTime);
        contactsRemark.setEditFlag("1");
        boolean success = false;
        try {
            success = contactsService.updateContactsRemark(contactsRemark);
        } catch (FailToUpdateException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        map.put("contactsRemark", contactsRemark);
        return map;
    }

    @RequestMapping("/getTranListByContactsId")
    @ResponseBody
    public List<Tran> getTranListByContactsId(String contactsId) {
        return tranService.getTranListByContactsId(contactsId);
    }

    @RequestMapping(value = {"/deleteTran"})
    @ResponseBody
    public Map<String, Object> deleteTranByIds(HttpServletRequest request) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        String[] ids = request.getParameterValues("id");
        boolean success = false;
        try {
            success = tranService.deleteTranByIds(ids);
        } catch (FailToDeleteException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        return map;
    }

}
