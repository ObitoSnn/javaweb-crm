package com.obitosnn.crm.workbench.service;

import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.vo.PageVo;
import com.obitosnn.crm.workbench.domain.Activity;
import com.obitosnn.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

/**
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/26 13:58
 */
public interface ActivityService {

    boolean saveActivity(Activity activity) throws FailToSaveException;

    PageVo<Activity> getActivityPageVo(Map<String, Object> map);

    boolean deleteActivity(String[] ids) throws FailToDeleteException;

    Activity getActivityById(String id);

    boolean updateActivity(Activity activity) throws FailToUpdateException;

    Activity getActivityDetailById(String id);

    List<ActivityRemark> getActivityRemarkListByActivityId(String id);

    boolean deleteActivityRemarkById(String id) throws FailToDeleteException;

    boolean saveActivityRemark(ActivityRemark activityRemark) throws FailToSaveException;

    ActivityRemark getActivityRemarkById(String id);

    boolean updateActivityRemark(ActivityRemark activityRemark) throws FailToUpdateException;
}
