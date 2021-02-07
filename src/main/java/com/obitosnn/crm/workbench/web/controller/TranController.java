package com.obitosnn.crm.workbench.web.controller;

import com.obitosnn.crm.settings.domain.User;
import com.obitosnn.crm.settings.service.UserService;
import com.obitosnn.crm.workbench.service.CustomerService;
import com.obitosnn.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

/**
 * @Author ObitoSnn
 * @Date 2021/2/7 11:52
 */
@Controller
@RequestMapping(value = {"/workbench/transaction"})
public class TranController {
    @Autowired
    private TranService tranService;
    @Autowired
    private UserService userService;
    @Autowired
    private CustomerService customerService;

    @RequestMapping(value = {"/add"})
    public ModelAndView add() {
        ModelAndView mv = new ModelAndView();
        List<User> uList = userService.getUserList();
        mv.addObject("uList", uList);
        mv.setViewName("forward:/pages/workbench/transaction/save.jsp");
        return mv;
    }

    @RequestMapping(value = {"/getCustomerName"})
    @ResponseBody
    public List<String> getCustomerName(String name) {
        return customerService.getCustomerName(name);
    }

}
