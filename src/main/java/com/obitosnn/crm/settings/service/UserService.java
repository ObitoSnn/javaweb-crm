package com.obitosnn.crm.settings.service;

import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.exception.LoginException;
import com.obitosnn.crm.settings.domain.User;
import com.obitosnn.crm.vo.PageVo;

import java.util.List;
import java.util.Map;

/**
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/18 18:37
 */
public interface UserService {

    User login(String loginAct, String loginPwd, String allowIps) throws LoginException;

    List<User> getUserList();

    String checkPwd(String id, String oldPwd);

    boolean updatePwd(User user) throws FailToUpdateException;

    PageVo<User> getUserPageVo(Map<String, Object> map);

    User getUserDetail(String id);

    boolean updateUserById(User user) throws FailToUpdateException;

}
