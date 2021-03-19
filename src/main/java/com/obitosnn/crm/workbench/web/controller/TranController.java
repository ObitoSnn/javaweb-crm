package com.obitosnn.crm.workbench.web.controller;

import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.settings.domain.User;
import com.obitosnn.crm.settings.service.UserService;
import com.obitosnn.crm.util.DateTimeUtil;
import com.obitosnn.crm.util.UUIDUtil;
import com.obitosnn.crm.vo.PageVo;
import com.obitosnn.crm.workbench.domain.*;
import com.obitosnn.crm.workbench.service.ActivityService;
import com.obitosnn.crm.workbench.service.ContactsService;
import com.obitosnn.crm.workbench.service.CustomerService;
import com.obitosnn.crm.workbench.service.TranService;
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
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ContactsService contactsService;

    @RequestMapping(value = {"/add"})
    public ModelAndView add(HttpServletRequest request) {
        ModelAndView mv = new ModelAndView();
        String intent = request.getParameter("intent");
        if ("getCustomerName".equals(intent)) {
            Customer cust = customerService.getCustomerById(request.getParameter("customerId"));
            mv.addObject("customerName", cust.getName());
        }
        if ("getContactsFullname".equals(intent)) {
            Contacts contacts = contactsService.getContactsById(request.getParameter("contactsId"));
            mv.addObject("contacts", contacts);
        }
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

    @RequestMapping(value = {"/getActivityByName"})
    @ResponseBody
    public List<Activity> getActivityByName(String activityName) {
        return activityService.getActivityByName(activityName);
    }

    @RequestMapping(value = {"/getContactByName"})
    @ResponseBody
    public List<Contacts> getContactByName(String contactName) {
        return contactsService.getContactByName(contactName);
    }

    @RequestMapping(value = {"/saveTran"})
    @ResponseBody
    public Map<String, Object> saveTran(HttpServletRequest request, Tran tran, String customerName) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        tran.setId(UUIDUtil.getUUID());
        tran.setCreateBy(createBy);
        tran.setCreateTime(DateTimeUtil.getSysTime());
        boolean success = false;
        try {
            success = tranService.saveTran(tran, customerName);
        } catch (FailToSaveException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        return map;
    }

    @RequestMapping(value = "/pageList")
    @ResponseBody
    public PageVo<Tran> pageList(HttpServletRequest request) {
        Map<String, Object> map = new HashMap<String, Object>();
        String pageNo = request.getParameter("pageNo");
        String pageSize = request.getParameter("pageSize");
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String customerName = request.getParameter("customerName");
        String stage = request.getParameter("stage");
        String transactionType = request.getParameter("transactionType");
        String source = request.getParameter("source");
        String contactsFullName = request.getParameter("contactsFullName");
        map.put("pageNo", pageNo);
        map.put("pageSize", pageSize);
        map.put("owner", owner);
        map.put("name", name);
        map.put("customerName", customerName);
        map.put("stage", stage);
        map.put("transactionType", transactionType);
        map.put("source", source);
        map.put("contactsFullName", contactsFullName);
        return tranService.getTranPageVo(map);
    }

    @RequestMapping(value = {"/getUserListAndTranById"})
    @ResponseBody
    public Map<String, Object> getUserListAndTranById(String id) {
        Map<String, Object> map = new HashMap<String, Object>();
        List<User> uList = userService.getUserList();
        map.put("uList", uList);
        Tran tran = tranService.getTranById(id);
        map.put("tran", tran);
        return map;
    }

    @RequestMapping(value = {"/getActivityIdAndContactsIdByTranId"})
    @ResponseBody
    public Tran getActivityIdAndContactsIdByTranId(String id) {
        return tranService.getActivityIdAndContactsIdByTranId(id);
    }

    @RequestMapping(value = {"/updateTran"})
    @ResponseBody
    public Map<String, Object> updateTran(HttpServletRequest request, Tran tran, String customerName) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        String editBy = ((User) request.getSession().getAttribute("user")).getName();
        boolean success = false;
        try {
            success = tranService.updateTran(tran, customerName, editBy);
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        return map;
    }

    @RequestMapping(value = {"/deleteTranByIds"})
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

    @RequestMapping(value = {"/detail"})
    public ModelAndView getTranDetail(String id) {
        ModelAndView mv = new ModelAndView();
        Tran tran = tranService.getTranDetailById(id);
        mv.addObject("tran", tran);
        mv.setViewName("forward:/pages/workbench/transaction/detail.jsp");
        return mv;
    }

    @RequestMapping(value = {"/getTranHistoryListByTranId"})
    @ResponseBody
    public List<TranHistory> getTranHistoryListByTranId(String tranId) {
        return tranService.getTranHistoryListByTranId(tranId);
    }

    @RequestMapping(value = {"/saveTranRemark"})
    @ResponseBody
    public Map<String, Object> saveTranRemark(HttpServletRequest request, TranRemark tranRemark) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        //设置id
        String id = UUIDUtil.getUUID();
        tranRemark.setId(id);
        //设置createTime
        tranRemark.setCreateTime(DateTimeUtil.getSysTime());
        //设置createBy
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        tranRemark.setCreateBy(createBy);
        //设置editFlag
        tranRemark.setEditFlag("0");
        boolean success = false;
        try {
            success = tranService.saveTranRemark(tranRemark);
            tranRemark = tranService.getTranRemarkById(id);
        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = e.getMessage();
            //抛出异常，给WorkBenchGlobalExceptionHandler处理
            throw new Exception(errorMsg);
        }
        map.put("success", success);
        map.put("tranRemark", tranRemark);
        return map;
    }

    @RequestMapping(value = {"/getTranRemarkList"})
    @ResponseBody
    public Map<String, Object> getTranRemarkList(String id) {
        Map<String, Object> map = new HashMap<String, Object>();
        List<TranRemark> tranRemarkList = tranService.getTranRemarkListByTranId(id);
        map.put("tranRemarkList", tranRemarkList);
        return map;
    }

    @RequestMapping(value = {"/deleteTranRemark"})
    @ResponseBody
    public Map<String, Object> deleteTranRemark(String id) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        //{"success":true/false,"errorMsg":错误信息}
        boolean success = false;
        try {
            success = tranService.deleteTranRemarkById(id);
        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = e.getMessage();
            //抛出异常，给WorkBenchGlobalExceptionHandler处理
            throw new Exception(errorMsg);
        }
        map.put("success", success);
        return map;
    }

    @RequestMapping(value = {"/updateTranRemark"})
    @ResponseBody
    public Map<String, Object> updateTranRemark(HttpServletRequest request, TranRemark tranRemark, String id) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        //设置editTime
        String editTime = DateTimeUtil.getSysTime();
        tranRemark.setEditTime(editTime);
        //设置editBy
        String editBy = ((User) request.getSession().getAttribute("user")).getName();
        tranRemark.setEditBy(editBy);
        //设置editFlag为1
        tranRemark.setEditFlag("1");
        //获取的请求参数即为备注信息的id
        tranRemark.setId(id);
        boolean success = false;
        try {
            success = tranService.updateTranRemark(tranRemark);
        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = e.getMessage();
            //抛出异常，给WorkBenchGlobalExceptionHandler处理
            throw new Exception(errorMsg);
        }
        map.put("success", success);
        map.put("tranRemark", tranRemark);
        return map;
    }

    @RequestMapping(value = {"/changeTranStage"})
    @ResponseBody
    public Map<String, Object> changeTranStage(HttpServletRequest request, Tran tran) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        String editBy = ((User) request.getSession().getAttribute("user")).getName();
        String editTime = DateTimeUtil.getSysTime();
        tran.setEditBy(editBy);
        tran.setEditTime(editTime);
        System.out.println(tran);
        boolean success = false;
        try {
            success = tranService.updateTranStage(tran);
            map.put("tran", tran);
        } catch (FailToUpdateException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        return map;
    }

    @RequestMapping(value = {"/getCharts"})
    @ResponseBody
    public List<Map<String, Object>> getCharts() {
        return tranService.getCharts();
    }

}
