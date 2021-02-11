package com.obitosnn.crm.workbench.web.controller;

import com.obitosnn.crm.vo.PageVo;
import com.obitosnn.crm.workbench.domain.Customer;
import com.obitosnn.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
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

}
