package com.obitosnn.crm.workbench.service;

import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.settings.domain.User;
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

    List<User> getUserList();

    boolean saveActivity(Activity activity) throws FailToSaveException;

    PageVo<Activity> getActivityPageVo(Map<String, Object> map);

    boolean deleteActivity(String[] ids) throws FailToDeleteException;

    Activity getActivityById(String id);

    boolean updateActivity(Activity activity) throws FailToUpdateException;

    Activity getActivityDetailById(String id);

    List<ActivityRemark> getActivityRemarkListByActivityId(String id);

}
