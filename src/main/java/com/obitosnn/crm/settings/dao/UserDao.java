package com.obitosnn.crm.settings.dao;

import com.obitosnn.crm.settings.domain.User;

import java.util.List;

/**
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/18 14:06
 */
public interface UserDao {

    List<User> selectAll();

    User selectUserByUsernameAndPassword(User user);

}
