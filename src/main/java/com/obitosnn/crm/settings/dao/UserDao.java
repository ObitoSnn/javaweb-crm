package com.obitosnn.crm.settings.dao;

import com.obitosnn.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

/**
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/18 14:06
 */
public interface UserDao {

    List<User> selectAll();

    User selectUserByUsernameAndPassword(User user);

    String selectUserLoginPwdById(String id);

    Integer updatePwd(User user);

    List<User> selectUserListForPageVo(Map<String, Object> map);

    Long selectUserTotalForPageVo(Map<String, Object> map);

    User selectUserDetailById(String id);

    Integer updateUserById(User user);

}
