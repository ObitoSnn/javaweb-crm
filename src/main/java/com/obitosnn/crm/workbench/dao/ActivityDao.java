package com.obitosnn.crm.workbench.dao;

import com.obitosnn.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

/**
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/26 13:55
 */
public interface ActivityDao {

    Integer insertActivity(Activity activity);

    Long getActivityTotal(Map<String, Object> map);

    List<Activity> getActivityList(Map<String, Object> map);

    Integer deleteByIds(String[] ids);

    Activity getActivityById(String id);

    Integer updateActivity(Activity activity);

    Activity getActivityDetailById(String id);
    
}
