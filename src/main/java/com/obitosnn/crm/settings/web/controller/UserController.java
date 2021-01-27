package com.obitosnn.crm.settings.web.controller;

import com.obitosnn.crm.exception.LoginException;
import com.obitosnn.crm.settings.domain.User;
import com.obitosnn.crm.settings.service.UserService;
import com.obitosnn.crm.util.MD5Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * 用户模块
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/18 16:51
 */
@RequestMapping(value = {"/user"})
@Controller
public class UserController {
    @Autowired
    private UserService userService;

    @RequestMapping("/ajaxLogin")
    @ResponseBody
    public Map<String, Object> AjaxLogin(HttpServletRequest request, User user) throws LoginException {
        System.out.println("==========UserController.AjaxLogin()执行了==========\n");
        Map<String, Object> map = new HashMap<String, Object>();
        //客户端ip
        String allowIps = request.getRemoteAddr();
        System.out.println("allowIps：" + allowIps + ",  账号：" + user.getLoginAct()
        + ",  密码：" + user.getLoginPwd());
        try {
            User loginUser = userService.login(user.getLoginAct(),
                    MD5Util.getMD5(user.getLoginPwd()), allowIps);
            //将用户信息保存至Session域中
            request.getSession().setAttribute("user", loginUser);
            map.put("success", true);
            System.out.println("==========用户名为[" + loginUser.getLoginAct() + "]的用户登录成功==========\n");
            return map;
        } catch (Exception e) {
            e.printStackTrace();
            String errorMag = e.getMessage();
            throw new LoginException(errorMag);
        }
    }

}
