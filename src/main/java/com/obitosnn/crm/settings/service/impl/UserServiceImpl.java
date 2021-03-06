package com.obitosnn.crm.settings.service.impl;

import com.github.pagehelper.PageHelper;
import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.exception.LoginException;
import com.obitosnn.crm.settings.dao.DeptDao;
import com.obitosnn.crm.settings.dao.UserDao;
import com.obitosnn.crm.settings.domain.Dept;
import com.obitosnn.crm.settings.domain.User;
import com.obitosnn.crm.settings.service.UserService;
import com.obitosnn.crm.util.DateTimeUtil;
import com.obitosnn.crm.util.MD5Util;
import com.obitosnn.crm.vo.PageVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/18 18:41
 */
@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserDao userDao;
    @Autowired
    private DeptDao deptDao;

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
        if ("root".equals(loginUser.getLoginAct())) {
            return loginUser;
        }
        String deptno = loginUser.getDeptno();
        Dept dept = deptDao.selectDeptByDeptno(deptno);
        loginUser.setDeptno(dept.getDeptno() + "，" + dept.getName());
        return loginUser;
    }

    @Override
    public List<User> getUserList() {
        return userDao.selectAll();
    }

    @Override
    public String checkPwd(String id, String oldPwd) {
        String loginPwd = userDao.selectUserLoginPwdById(id);
        oldPwd = MD5Util.getMD5(oldPwd);
        if (!loginPwd.equals(oldPwd)) {
            return "原密码错误";
        }
        return "";
    }

    @Override
    public boolean updatePwd(User user) throws FailToUpdateException {
        String newLoginPwd = MD5Util.getMD5(user.getLoginPwd());
        user.setLoginPwd(newLoginPwd);
        Integer count = userDao.updatePwd(user);
        if (count.compareTo(1) != 0) {
            throw new FailToUpdateException("修改失败");
        }
        return true;
    }

    @Override
    public PageVo<User> getUserPageVo(Map<String, Object> map) {
        PageVo<User> pageVo = new PageVo<User>();
        int pageNo = Integer.parseInt((String) map.get("pageNo"));
        int pageSize = Integer.parseInt((String) map.get("pageSize"));
        PageHelper.startPage(pageNo, pageSize);
        List<User> dataList = userDao.selectUserListForPageVo(map);
        for (User user : dataList) {
            if ("0".equals(user.getLockState())) {
                user.setLockState("锁定");
            }
            if ("1".equals(user.getLockState())) {
                user.setLockState("启用");
            }
        }
        pageVo.setDataList(dataList);
        Long total = userDao.selectUserTotalForPageVo(map);
        pageVo.setTotal(total);
        return pageVo;
    }

    @Override
    public User getUserDetail(String id) {
        User user = userDao.selectUserDetailById(id);
        if ("0".equals(user.getLockState())) {
            user.setLockState("锁定");
        }
        if ("1".equals(user.getLockState())) {
            user.setLockState("启用");
        }
        return user;
    }

    @Override
    public boolean updateUserById(User user) throws FailToUpdateException {
        user.setDeptno(deptDao.selectDeptnoByName(user.getDeptno()));
        user.setLoginPwd(MD5Util.getMD5(user.getLoginPwd()));
        Integer count = userDao.updateUserById(user);
        if (count.compareTo(1) != 0) {
            throw new FailToUpdateException("修改失败");
        }
        return true;
    }

}
