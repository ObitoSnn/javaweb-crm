package com.obitosnn.crm.workbench.web.controller;

import com.obitosnn.crm.settings.domain.User;
import com.obitosnn.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * @Author ObitoSnn
 * @Date 2021/2/1 17:59
 */
@Controller
@RequestMapping(value = {"/workbench/clue"})
public class ClueController {
    @Autowired
    private UserService userService;

    @RequestMapping(value = {"/getUserList"})
    @ResponseBody
    public List<User> getUserList() {
        return userService.getUserList();
    }

}