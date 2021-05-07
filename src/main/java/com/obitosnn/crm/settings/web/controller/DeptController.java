package com.obitosnn.crm.settings.web.controller;

import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.settings.domain.Dept;
import com.obitosnn.crm.settings.domain.User;
import com.obitosnn.crm.settings.service.DeptService;
import com.obitosnn.crm.settings.service.UserService;
import com.obitosnn.crm.util.DateTimeUtil;
import com.obitosnn.crm.util.UUIDUtil;
import com.obitosnn.crm.vo.PageVo;
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
 * @author ObitoSnn
 * @Date 2021/3/1 21:43
 */
@Controller
@RequestMapping(value = {"/settings/dept"})
public class DeptController {
    @Autowired
    private DeptService deptService;
    @Autowired
    private UserService userService;

    @RequestMapping(value = {"/deptManagement"})
    public ModelAndView deptManagement() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("forward:/pages/settings/dept/index.jsp");
        return mv;
    }

    @RequestMapping(value = {"/pageList"})
    @ResponseBody
    public PageVo<Dept> pageList(HttpServletRequest request) {
        String pageNo = request.getParameter("pageNo");
        String pageSize = request.getParameter("pageSize");
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("pageNo", pageNo);
        map.put("pageSize", pageSize);
        return  deptService.getDeptPageVo(map);
    }

    @RequestMapping(value = {"/getUserList"})
    @ResponseBody
    public List<User> getUserList() {
        return userService.getUserList();
    }

    @RequestMapping(value = {"/saveDept"})
    @ResponseBody
    public Map<String, Object> saveDept(HttpServletRequest request, Dept dept) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        dept.setId(UUIDUtil.getUUID());
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        dept.setCreateBy(createBy);
        String createTime = DateTimeUtil.getSysTime();
        dept.setCreateTime(createTime);
        System.out.println(dept);
        boolean success = false;
        try {
            success = deptService.saveDept(dept);
        } catch (FailToSaveException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        return map;
    }

    @RequestMapping(value = {"/getDeptByIdAndUserList"})
    @ResponseBody
    public Map<String, Object> getDeptByIdAndUserList(String id) {
        Map<String, Object> map = new HashMap<String, Object>();
        Dept dept = deptService.getDeptById(id);
        List<User> userList = userService.getUserList();
        map.put("dept", dept);
        map.put("userList", userList);
        return map;
    }

    @RequestMapping(value = {"/updateDept"})
    @ResponseBody
    public Map<String, Object> updateDept(HttpServletRequest request, Dept dept) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        String editBy = ((User) request.getSession().getAttribute("user")).getName();
        dept.setEditBy(editBy);
        String editTime = DateTimeUtil.getSysTime();
        dept.setEditTime(editTime);
        boolean success = false;
        try {
            success = deptService.updateDept(dept);
        } catch (FailToUpdateException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        return map;
    }

    @RequestMapping(value = {"/deleteDeptByIds"})
    @ResponseBody
    public Map<String, Object> deleteDeptByIds(String[] id) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        boolean success = false;
        try {
            success = deptService.deleteDeptByIds(id);
        } catch (FailToDeleteException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        return map;
    }

}
