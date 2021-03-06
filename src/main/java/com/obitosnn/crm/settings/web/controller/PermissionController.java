package com.obitosnn.crm.settings.web.controller;

import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.settings.domain.User;
import com.obitosnn.crm.settings.service.DeptService;
import com.obitosnn.crm.settings.service.UserService;
import com.obitosnn.crm.util.DateTimeUtil;
import com.obitosnn.crm.vo.PageVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author ObitoSnn
 * @Date 2021/3/1 21:51
 */
@Controller
@RequestMapping(value = {"/settings/permission"})
public class PermissionController {
    @Autowired
    private UserService userService;
    @Autowired
    private DeptService deptService;

    @RequestMapping(value = {"/permissionManagement"})
    public ModelAndView permissionManagement() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("forward:/pages/settings/qx/index.jsp");
        return mv;
    }

    @RequestMapping(value = {"/user/pageList"})
    @ResponseBody
    public PageVo<User> pageList(HttpServletRequest request, User user) {
        String pageNo = request.getParameter("pageNo");
        String pageSize = request.getParameter("pageSize");
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("pageNo", pageNo);
        map.put("pageSize", pageSize);
        map.put("name", user.getName());
        map.put("deptno", user.getDeptno());
        map.put("lockState", user.getLockState());
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        return  userService.getUserPageVo(map);
    }

    @GetMapping("/user/detail")
    public ModelAndView detail(String id) {
        ModelAndView mv = new ModelAndView();
        User user = userService.getUserDetail(id);
        mv.addObject("user", user);
        mv.setViewName("forward:/pages/settings/qx/user/detail.jsp");
        return mv;
    }

    @GetMapping("/user/getDeptNameList")
    @ResponseBody
    public List<String> getDeptNameList() {
        return deptService.getDeptNameList();
    }

    @PostMapping("/user/updateUserById")
    @ResponseBody
    public Map<String, Object> updateUserById(HttpServletRequest request, User user) {
        Map<String, Object> map = new HashMap<String, Object>();
        String editBy = ((User) request.getSession().getAttribute("user")).getName();
        user.setEditBy(editBy);
        String editTime = DateTimeUtil.getSysTime();
        user.setEditTime(editTime);
        boolean success = false;
        try {
            success = userService.updateUserById(user);
        } catch (FailToUpdateException e) {
            e.printStackTrace();
        }
        map.put("success", success);
        return map;
    }

}
