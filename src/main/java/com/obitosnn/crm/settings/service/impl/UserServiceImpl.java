package com.obitosnn.crm.settings.service.impl;

import com.obitosnn.crm.exception.LoginException;
import com.obitosnn.crm.settings.dao.UserDao;
import com.obitosnn.crm.settings.domain.User;
import com.obitosnn.crm.settings.service.UserService;
import com.obitosnn.crm.util.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/18 18:41
 */
@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserDao userDao;

    @Override
    public User login(String loginAct, String loginPwd, String allowIps) throws LoginException {
        User user = new User();
        user.setLoginAct(loginAct);
        user.setLoginPwd(loginPwd);
        User loginUser = userDao.selectUserByUsernameAndPassword(user);
        if (loginUser == null) {
            //账号和密码输入错误
            throw new LoginException("账号或密码错误");
        }
        if (!"".equals(loginUser.getEditTime()) &&
                (loginUser.getExpireTime().compareTo(DateTimeUtil.getSysTime())) < 0) {
            //用户允许登录的时间已过期
            throw new LoginException("账号已失效");
        }
        if ("0".equals(loginUser.getLockState())) {
            //账号为已锁定状态
            throw new LoginException("账号已锁定");
        }
        if (!loginUser.getAllowIps().contains(allowIps)) {
            //不允许该用户ip访问系统
            throw new LoginException("ip地址受限");
        }
        return loginUser;
    }

}
