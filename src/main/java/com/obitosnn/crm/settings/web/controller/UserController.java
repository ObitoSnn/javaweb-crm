package com.obitosnn.crm.settings.web.controller;

import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.exception.LoginException;
import com.obitosnn.crm.settings.domain.User;
import com.obitosnn.crm.settings.service.UserService;
import com.obitosnn.crm.util.MD5Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

/**
 * 用户模块
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/18 16:51
 */
@RequestMapping(value = {"/settings/user"})
@Controller
public class UserController {
    @Autowired
    private UserService userService;

    @RequestMapping("/login")
    @ResponseBody
    public Map<String, Object> login(HttpServletRequest request, User user) throws Exception {
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
        } catch (LoginException e) {
            e.printStackTrace();
            String errorMag = e.getMessage();
            throw new Exception(errorMag);
        }
    }

    @RequestMapping(value = {"/logout"})
    public ModelAndView logout(HttpServletRequest request) {
        ModelAndView mv = new ModelAndView();
        HttpSession session = request.getSession();
        session.invalidate();
        mv.setViewName("redirect:/login.jsp");
        return mv;
    }

    @RequestMapping(value = {"/checkPwd"}, produces = {"text/plain;charset=UTF-8"})
    @ResponseBody
    public String checkPwd(String id, String oldPwd) {
        return userService.checkPwd(id, oldPwd);
    }

    @RequestMapping(value = {"/updatePwd"})
    @ResponseBody
    public Map<String, Object> updatePwd(HttpServletRequest request, User user) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        boolean success = false;
        try {
            success = userService.updatePwd(user);
            request.getSession().invalidate();
        } catch (FailToUpdateException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        return map;
    }

}
