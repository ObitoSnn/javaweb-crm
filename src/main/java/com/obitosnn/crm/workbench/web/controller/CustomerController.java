package com.obitosnn.crm.workbench.web.controller;

import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.settings.domain.User;
import com.obitosnn.crm.settings.service.UserService;
import com.obitosnn.crm.util.DateTimeUtil;
import com.obitosnn.crm.util.UUIDUtil;
import com.obitosnn.crm.vo.PageVo;
import com.obitosnn.crm.workbench.domain.Customer;
import com.obitosnn.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author ObitoSnn
 * @Date 2021/2/11 16:52
 */
@Controller
@RequestMapping(value = {"/workbench/customer"})
public class CustomerController {
    @Autowired
    private CustomerService customerService;
    @Autowired
    private UserService userService;

    @RequestMapping(value = {"/pageList"})
    @ResponseBody
    public PageVo<Customer> pageList(HttpServletRequest request) {
        Map<String, Object> map = new HashMap<String, Object>();
        String pageNo = request.getParameter("pageNo");
        String pageSize = request.getParameter("pageSize");
        String name = request.getParameter("name");
        String owner = request.getParameter("owner");
        String phone = request.getParameter("phone");
        String website = request.getParameter("website");
        map.put("pageNo", pageNo);
        map.put("pageSize", pageSize);
        map.put("name", name);
        map.put("owner", owner);
        map.put("phone", phone);
        map.put("website", website);
        return customerService.getCustomerPageVo(map);
    }

    @RequestMapping(value = {"/detail"})
    public ModelAndView getCustomerDetail(String id) {
        ModelAndView mv = new ModelAndView();
        Customer customer = customerService.getCustomerDetailById(id);
        mv.addObject("customer", customer);
        mv.setViewName("forward:/pages/workbench/customer/detail.jsp");
        return mv;
    }

    @RequestMapping(value = {"/getUserList"})
    @ResponseBody
    public List<User> getUserList() {
        return userService.getUserList();
    }

    @RequestMapping(value = {"/saveCustomer"})
    @ResponseBody
    public Map<String, Object> saveCustomer(HttpServletRequest request, Customer customer) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        customer.setId(UUIDUtil.getUUID());
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        customer.setCreateBy(createBy);
        customer.setCreateTime(DateTimeUtil.getSysTime());
        boolean success = false;
        try {
            success = customerService.saveCustomer(customer);
        } catch (FailToSaveException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        return map;
    }

    @RequestMapping(value = {"/getUserListAndCustomerById"})
    @ResponseBody
    public Map<String, Object> getUserListAndCustomerById(String id) {
        Map<String, Object> map = new HashMap<String, Object>();
        List<User> uList = userService.getUserList();
        Customer customer = customerService.getCustomerById(id);
        map.put("uList", uList);
        map.put("customer", customer);
        return map;
    }

    @RequestMapping(value = {"/updateCustomerById"})
    @ResponseBody
    public Map<String, Object> updateCustomerById(HttpServletRequest request, Customer customer) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        String editBy = ((User) request.getSession().getAttribute("user")).getName();
        customer.setEditBy(editBy);
        String editTime = DateTimeUtil.getSysTime();
        customer.setEditTime(editTime);
        boolean success = false;
        try {
            success = customerService.updateCustomerById(customer);
        } catch (FailToUpdateException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        return map;
    }

    @RequestMapping(value = {"/deleteCustomerByIds"})
    @ResponseBody
    public Map<String, Object> deleteCustomerByIds(HttpServletRequest request) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        String[] ids = request.getParameterValues("id");
        boolean success = false;
        try {
            success = customerService.deleteCustomerByIds(ids);
        } catch (FailToDeleteException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        return map;
    }

}
