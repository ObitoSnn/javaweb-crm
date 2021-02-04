package com.obitosnn.crm.workbench.web.controller;

import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.settings.domain.User;
import com.obitosnn.crm.settings.service.UserService;
import com.obitosnn.crm.util.DateTimeUtil;
import com.obitosnn.crm.util.UUIDUtil;
import com.obitosnn.crm.vo.PageVo;
import com.obitosnn.crm.workbench.domain.Activity;
import com.obitosnn.crm.workbench.domain.Clue;
import com.obitosnn.crm.workbench.service.ActivityService;
import com.obitosnn.crm.workbench.service.ClueService;
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
 * @Date 2021/2/1 17:59
 */
@Controller
@RequestMapping(value = {"/workbench/clue"})
public class ClueController {
    @Autowired
    private UserService userService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private ActivityService activityService;

    @RequestMapping(value = {"/getUserList"})
    @ResponseBody
    public List<User> getUserList() {
        return userService.getUserList();
    }

    @RequestMapping(value = {"/saveClue"})
    @ResponseBody
    public Map<String, Object> saveClue(HttpServletRequest request, Clue clue) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        //{"success":true/false}
//        id
        clue.setId(UUIDUtil.getUUID());
//        createBy
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        clue.setCreateBy(createBy);
//        createTime
        clue.setCreateTime(DateTimeUtil.getSysTime());
        boolean success = false;
        try {
            success = clueService.saveClue(clue);
        } catch (FailToSaveException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        return map;
    }

    @RequestMapping(value = {"/pageList"})
    @ResponseBody
    public PageVo<Clue> pageList(HttpServletRequest request, Clue clue) {
        String pageNo = request.getParameter("pageNo");
        String pageSize = request.getParameter("pageSize");
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("pageNo", pageNo);
        map.put("pageSize", pageSize);
        map.put("fullname", clue.getFullname());
        map.put("company", clue.getCompany());
        map.put("phone", clue.getPhone());
        map.put("source", clue.getSource());
        map.put("owner", clue.getOwner());
        map.put("mphone", clue.getMphone());
        map.put("state", clue.getState());
       return  clueService.getCluePageVo(map);
    }

    @RequestMapping(value = {"/getClueDetail"})
    public ModelAndView getClueDetailById(String id) {
        ModelAndView mv = new ModelAndView();
        Clue clue = clueService.getClueDetailById(id);
        mv.addObject("clue", clue);
        mv.setViewName("/pages/workbench/clue/detail.jsp");
        return mv;
    }

    @RequestMapping(value = {"/getUserListAndClueById"})
    @ResponseBody
    public Map<String, Object> getUserListAndClueById(String id) {
        Map<String, Object> map = new HashMap<String, Object>();
        List<User> uList = userService.getUserList();
        Clue clue = clueService.getClueById(id);
        map.put("uList", uList);
        map.put("clue", clue);
        return map;
    }

    @RequestMapping(value = {"/deleteClueByIds"})
    @ResponseBody
    public Map<String, Object> deleteClueByIds(HttpServletRequest request) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        String[] ids = request.getParameterValues("id");
        boolean success = false;
        try {
            success = clueService.deleteClueByIds(ids);
        } catch (FailToDeleteException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        return map;
    }

    @RequestMapping(value = {"/updateClueById"})
    @ResponseBody
    public Map<String, Object> updateClueById(HttpServletRequest request, Clue clue) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        //editBy
        String editBy = ((User) request.getSession().getAttribute("user")).getName();
        clue.setEditBy(editBy);
        //editTime
        clue.setEditTime(DateTimeUtil.getSysTime());
        boolean success = false;
        try {
            success = clueService.updateClueById(clue);
        } catch (FailToUpdateException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        return map;
    }

    @RequestMapping(value = {"/getActivityListByClueId"})
    @ResponseBody
    public List<Activity> getActivityListByClueId(String clueId) {
        return activityService.getActivityListByClueId(clueId);
    }

    @RequestMapping(value = {"/unBindCarByCarId"})
    @ResponseBody
    public Map<String, Object> unBindCarByCarId(String carId) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        boolean success = false;
        try {
            success = clueService.deleteCarByCarId(carId);
        } catch (FailToUpdateException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        return map;
    }

    @RequestMapping(value = {"/getNotBindActivityListByClueId"})
    @ResponseBody
    public List<Activity> getNotBindActivityListByClueId(String clueId) {
        return activityService.getNotBindActivityListByClueId(clueId);
    }

    @RequestMapping(value = {"/getNotBindActivityListByName"})
    @ResponseBody
    public List<Activity> getNotBindActivityListByName(String name, String clueId) {
        Map<String, String> map = new HashMap<String, String>();
        map.put("name", name);
        map.put("clueId", clueId);
        return activityService.getNotBindActivityListByName(map);
    }
}