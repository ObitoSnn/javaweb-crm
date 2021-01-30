package com.obitosnn.crm.workbench.dao;

import com.obitosnn.crm.workbench.domain.ActivityRemark;

import java.util.List;

/**
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/26 13:55
 */
public interface ActivityRemarkDao {

    Integer selectByIds(String[] ids);

    Integer deleteByIds(String[] ids);

    List<ActivityRemark> selectActivityRemarkListByActivityId(String id);

    Integer deleteActivityRemarkById(String id);

    Integer insertActivityRemark(ActivityRemark activityRemark);

    ActivityRemark selectActivityRemarkById(String id);
}
