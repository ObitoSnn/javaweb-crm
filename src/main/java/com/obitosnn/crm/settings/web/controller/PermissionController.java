package com.obitosnn.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * @author ObitoSnn
 * @Date 2021/3/1 21:51
 */
@Controller
@RequestMapping(value = {"/settings/permission"})
public class PermissionController {

    @RequestMapping(value = {"/permissionManagement"})
    public ModelAndView permissionManagement() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("forward:/pages/settings/qx/index.jsp");
        return mv;
    }

}
