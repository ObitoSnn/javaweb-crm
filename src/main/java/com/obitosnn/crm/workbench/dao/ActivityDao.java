package com.obitosnn.crm.workbench.dao;

import com.obitosnn.crm.workbench.domain.Activity;

import java.util.List;

/**
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/26 13:55
 */
public interface ActivityDao {

    Integer insertActivity(Activity activity);

    Long getActivityTotal();

    List<Activity> getActivityList();

}
