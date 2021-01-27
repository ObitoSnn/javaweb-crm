package com.obitosnn.crm.settings.service;

import com.obitosnn.crm.exception.LoginException;
import com.obitosnn.crm.settings.domain.User;

/**
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/18 18:37
 */
public interface UserService {

    User login(String loginAct, String loginPwd, String allowIps) throws LoginException;

}
