package com.obitosnn.crm.workbench.service;

import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.settings.domain.User;
import com.obitosnn.crm.workbench.domain.Activity;

import java.util.List;

/**
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/26 13:58
 */
public interface ActivityService {

    List<User> getUserList();

    boolean saveActivity(Activity activity) throws FailToSaveException;

}
