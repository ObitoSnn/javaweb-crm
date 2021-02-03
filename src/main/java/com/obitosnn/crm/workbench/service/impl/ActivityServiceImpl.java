package com.obitosnn.crm.workbench.service.impl;

import com.github.pagehelper.PageHelper;
import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.vo.PageVo;
import com.obitosnn.crm.workbench.dao.ActivityDao;
import com.obitosnn.crm.workbench.dao.ActivityRemarkDao;
import com.obitosnn.crm.workbench.domain.Activity;
import com.obitosnn.crm.workbench.domain.ActivityRemark;
import com.obitosnn.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/26 13:58
 */
@Service
public class ActivityServiceImpl implements ActivityService {
    @Autowired
    private ActivityDao activityDao;
    @Autowired
    private ActivityRemarkDao activityRemarkDao;


    @Override
    public boolean saveActivity(Activity activity) throws FailToSaveException {
        String startDate = activity.getStartDate();
        String endDate = activity.getEndDate();
        if (startDate.compareTo(endDate) > 0) {
            throw new FailToSaveException("非法的结束日期");
        }
        Integer count = activityDao.insertActivity(activity);
        if (count != 1) {
            //数据没有保存成功
            throw new FailToSaveException("服务器出现故障，数据未保存成功，请联系客服");
        }
        return true;
    }

    @Override
    public PageVo<Activity> getActivityPageVo(Map<String, Object> map) {
        int pageNo = Integer.parseInt((String) map.get("pageNo"));
        int pageSize =  Integer.parseInt((String) map.get("pageSize"));
        PageHelper.startPage(pageNo, pageSize);
        List<Activity> aList = activityDao.selectActivityList(map);
        PageVo<Activity> pageVo = new PageVo<>();
        Long total = activityDao.selectActivityTotal(map);
        pageVo.setTotal(total);
        pageVo.setDataList(aList);
        return pageVo;
    }

    @Override
    public boolean deleteActivity(String[] ids) throws FailToDeleteException {
        //查询所有要删除的市场活动备注(tbl_activity_remark)表中要删除的数据
        Integer selectActivityRemarkCount = activityRemarkDao.selectByIds(ids);
        //删除市场活动备注(tbl_activity_remark，实际删除条数)
        Integer deleteActivityRemarkCount = activityRemarkDao.deleteByIds(ids);
        if (!selectActivityRemarkCount.equals(deleteActivityRemarkCount)) {
            //要删除的市场活动备注数量与被删除的市场活动备注数量不相等，删除失败
            throw new FailToDeleteException("删除失败");
        }
        //删除市场活动(tbl_activity)
        Integer deleteActivityCount = activityDao.deleteByIds(ids);
        if (deleteActivityCount != ids.length) {
            //删除市场活动的数量与请求参数中id数组的长度不等，删除失败
            throw new FailToDeleteException("删除失败");
        }
        return true;
    }

    @Override
    public Activity getActivityById(String id) {
        return activityDao.selectActivityById(id);
    }

    @Override
    public boolean updateActivity(Activity activity) throws FailToUpdateException {
        String startDate = activity.getStartDate();
        String endDate = activity.getEndDate();
        if (startDate.compareTo(endDate) > 0) {
            throw new FailToUpdateException("非法的结束日期");
        }
        Integer count = activityDao.updateActivity(activity);
        if (count != 1) {
            //数据没有修改成功
            throw new FailToUpdateException("服务器出现故障，数据未修改成功，请联系客服");
        }
        return true;
    }

    @Override
    public Activity getActivityDetailById(String id) {
        return activityDao.selectActivityDetailById(id);
    }

    @Override
    public List<ActivityRemark> getActivityRemarkListByActivityId(String id) {
        return activityRemarkDao.selectActivityRemarkListByActivityId(id);
    }

    @Override
    public boolean deleteActivityRemarkById(String id) throws FailToDeleteException {
        Integer count = activityRemarkDao.deleteActivityRemarkById(id);
        if (count != 1) {
            throw new FailToDeleteException("删除失败");
        }
        return true;
    }

    @Override
    public boolean saveActivityRemark(ActivityRemark activityRemark) throws FailToSaveException {
        Integer count = activityRemarkDao.insertActivityRemark(activityRemark);
        if (count != 1) {
            throw new FailToSaveException("备注保存失败");
        }
        return true;
    }

    @Override
    public ActivityRemark getActivityRemarkById(String id) {
        return activityRemarkDao.selectActivityRemarkById(id);
    }

    @Override
    public boolean updateActivityRemark(ActivityRemark activityRemark) throws FailToUpdateException {
        Integer count = activityRemarkDao.updateActivityRemarkById(activityRemark);
        if (count != 1) {
            throw new FailToUpdateException("备注修改失败");
        }
        return true;
    }

    @Override
    public List<Activity> getActivityListByClueId(String clueId) {
        return activityDao.selectActivityListByClueId(clueId);
    }

    @Override
    public List<Activity> getNotBindActivityListByClueId(String clueId) {
        return activityDao.selectNotBindActivityListByClueId(clueId);
    }
}
