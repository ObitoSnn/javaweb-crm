package com.obitosnn.crm.workbench.service.impl;

import com.github.pagehelper.PageHelper;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.settings.dao.UserDao;
import com.obitosnn.crm.settings.domain.User;
import com.obitosnn.crm.vo.PageVo;
import com.obitosnn.crm.workbench.dao.ActivityDao;
import com.obitosnn.crm.workbench.domain.Activity;
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
    private UserDao userDao;
    @Autowired
    private ActivityDao activityDao;

    @Override
    public List<User> getUserList() {
        return userDao.selectAll();
    }

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
        List<Activity> aList = activityDao.getActivityList(map);
        PageVo<Activity> pageVo = new PageVo<>();
        Long total = activityDao.getActivityTotal(map);
        pageVo.setTotal(total);
        pageVo.setDataList(aList);
        return pageVo;
    }
}
