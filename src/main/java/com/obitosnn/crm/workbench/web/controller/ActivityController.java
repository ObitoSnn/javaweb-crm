package com.obitosnn.crm.workbench.web.controller;

import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.settings.domain.User;
import com.obitosnn.crm.util.DateTimeUtil;
import com.obitosnn.crm.util.UUIDUtil;
import com.obitosnn.crm.vo.PageVo;
import com.obitosnn.crm.workbench.domain.Activity;
import com.obitosnn.crm.workbench.domain.ActivityRemark;
import com.obitosnn.crm.workbench.service.ActivityService;
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
 * 市场活动模块
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/26 13:58
 */
@Controller
@RequestMapping(value = {"/workbench/activity"})
public class ActivityController {
    @Autowired
    private ActivityService activityService;

    @RequestMapping(value = {"/ajaxGetUserList"})
    @ResponseBody
    public List<User> ajaxGetUserList() {
        System.out.println("==========ActivityController.ajaxGetUserList()执行了==========\n");
        return activityService.getUserList();
    }

    @RequestMapping(value = {"/saveActivity"})
    @ResponseBody
    public Map<String, Object> saveActivity(HttpServletRequest request, Activity activity) throws FailToSaveException {
        System.out.println("==========ActivityController.saveActivity()执行了==========\n");
        Map<String, Object> map = new HashMap<String, Object>();
        //设置主键
        activity.setId(UUIDUtil.getUUID());
        //设置创建时间
        activity.setCreateTime(DateTimeUtil.getSysTime());
        //设置创建人
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        activity.setCreateBy(createBy);
        try {
            activityService.saveActivity(activity);
        } catch (FailToSaveException e) {
            e.printStackTrace();
            String errorMsg = e.getMessage();
            throw new FailToSaveException(errorMsg);
        }
        map.put("success", true);
        System.out.println("==========数据保存成功==========");
        return map;
    }


    @RequestMapping(value = {"/pageList"})
    @ResponseBody
    public PageVo<Activity> pageList(HttpServletRequest request, Activity activity) {
        System.out.println("==========ActivityController.pageList()执行了==========\n");
        Map<String, Object> map = new HashMap<String, Object>();
         /*

            pageNo
            pageSize
            name
            owner
            startDate
            endDate

            {"total":总记录数,"dataList":[{市场活动},{}...]}

         */
        String pageNo = request.getParameter("pageNo");
        String pageSize = request.getParameter("pageSize");
        //添加请求参数pageNo
        map.put("pageNo", pageNo);
        //添加请求参数pageSize
        map.put("pageSize", pageSize);
        //添加请求参数name
        map.put("name", activity.getName());
        //添加请求参数owner
        map.put("owner", activity.getOwner());
        //添加请求参数startDate
        map.put("startDate", activity.getStartDate());
        //添加请求参数endDate
        map.put("endDate", activity.getEndDate());
        //将PageVo传给页面
        return activityService.getActivityPageVo(map);
    }

    @RequestMapping(value = {"/deleteActivity"})
    @ResponseBody
    public Map<String, Object> deleteActivity(HttpServletRequest request) throws FailToDeleteException {
        System.out.println("==========ActivityController.deleteActivity()执行了==========\n");
        Map<String, Object> map = new HashMap<String, Object>();
        String[] ids = request.getParameterValues("id");
        try {
            activityService.deleteActivity(ids);
        } catch (FailToDeleteException e) {
            e.printStackTrace();
            String errorMsg = e.getMessage();
            //抛出异常，给WorkBenchGlobalExceptionHandler处理
            throw new FailToDeleteException(errorMsg);
        }
        map.put("success", true);
        System.out.println("==========数据删除成功==========");
        return map;
    }

    @RequestMapping(value = {"/getUserListAndActivity"})
    @ResponseBody
    public Map<String, Object> getUserListAndActivity(String id) {
        System.out.println("==========ActivityController.getUserListAndActivity()执行了==========\n");
        Map<String, Object> map = new HashMap<String, Object>();
        /*
            {"uList":[{用户1},{用户2},...],"activity":"{市场活动}"}
         */
        List<User> uList = activityService.getUserList();
        Activity activity = activityService.getActivityById(id);
        map.put("uList", uList);
        map.put("activity", activity);
        return map;
    }

    @RequestMapping(value = {"/updateActivity"})
    @ResponseBody
    public Map<String, Object> updateActivity(HttpServletRequest request, Activity activity) throws FailToUpdateException {
        System.out.println("==========ActivityController.updateActivity()执行了==========\n");
        Map<String, Object> map = new HashMap<String, Object>();
        //设置修改时间
        activity.setEditTime(DateTimeUtil.getSysTime());
        //设置修改人
        String editBy = ((User) request.getSession().getAttribute("user")).getName();
        activity.setEditBy(editBy);
        try {
            activityService.updateActivity(activity);
        } catch (FailToUpdateException e) {
            e.printStackTrace();
            String errorMsg = e.getMessage();
            throw new FailToUpdateException(errorMsg);
        }
        map.put("success", true);
        System.out.println("==========数据修改成功==========");
        return map;
    }

    @RequestMapping(value = {"/getActivityDetail"})
    public ModelAndView getActivityDetail(String id) {
        System.out.println("==========ActivityController.getActivityDetail()执行了==========\n");
        ModelAndView mv = new ModelAndView();
        Activity activity = activityService.getActivityDetailById(id);
        mv.addObject("activity", activity);
        //请求转发至 pages/workbench/activity/detail.jsp
        mv.setViewName("/pages/workbench/activity/detail.jsp");
        return mv;
    }

    @RequestMapping(value = {"/getActivityRemarkList"})
    @ResponseBody
    public Map<String, Object> getActivityRemarkList(String id) {
        System.out.println("==========ActivityController.getActivityRemarkList()执行了==========\n");
        Map<String, Object> map = new HashMap<String, Object>();
        //{"activityRemarkList":[{"市场活动备注1"},...]}
        List<ActivityRemark> activityRemarkList = activityService.getActivityRemarkListByActivityId(id);
        map.put("activityRemarkList", activityRemarkList);
        return map;
    }

    @RequestMapping(value = {"/deleteActivityRemark"})
    @ResponseBody
    public Map<String, Object> deleteActivityRemarkById(String id) throws FailToDeleteException {
        System.out.println("==========ActivityController.deleteActivityRemarkById()执行了==========\n");
        Map<String, Object> map = new HashMap<String, Object>();
        //{"success":true/false,"errorMsg":错误信息}
        try {
            activityService.deleteActivityRemarkById(id);
        } catch (FailToDeleteException e) {
            e.printStackTrace();
            String errorMsg = e.getMessage();
            //抛出异常，给WorkBenchGlobalExceptionHandler处理
            throw new FailToDeleteException(errorMsg);
        }
        map.put("success", true);
        return map;
    }
}
