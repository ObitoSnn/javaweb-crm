package com.obitosnn.crm.workbench.web.controller;

import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.settings.domain.User;
import com.obitosnn.crm.util.DateTimeUtil;
import com.obitosnn.crm.util.UUIDUtil;
import com.obitosnn.crm.vo.PageVo;
import com.obitosnn.crm.workbench.domain.Activity;
import com.obitosnn.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

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
        String id = ((User) request.getSession().getAttribute("user")).getId();
        //设置主键
        activity.setId(UUIDUtil.getUUID());
        //设置所有者，即tbl_user中的id字段
        activity.setOwner(id);
        //设置创建时间
        activity.setCreateTime(DateTimeUtil.getSysTime());
        //设置创建人
        String createBy = ((User) request.getSession().getAttribute("user")).getCreateBy();
        activity.setCreateBy(createBy);
        try {
            activityService.saveActivity(activity);
        } catch (FailToSaveException e) {
            e.printStackTrace();
            String errorMsg = e.getMessage();
            if ("非法的结束日期".equals(errorMsg)) {
                request.setAttribute("activity", activity);
            }
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

}
