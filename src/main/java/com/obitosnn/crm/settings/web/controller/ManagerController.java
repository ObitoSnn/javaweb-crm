package com.obitosnn.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * @author ObitoSnn
 * @Date 2021/2/27 15:04
 */
@Controller
@RequestMapping(value = {"/manager"})
public class ManagerController {

    @RequestMapping(value = {"/permissionManagement"})
    public ModelAndView permissionManagement() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("forward:/pages/settings/qx/index.jsp");
        return mv;
    }

    @RequestMapping(value = {"/deptManagement"})
    public ModelAndView deptManagement() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("forward:/pages/settings/dept/index.jsp");
        return mv;
    }

    @RequestMapping(value = {"/dicManagement"})
    public ModelAndView dicManagement() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("forward:/pages/settings/dictionary/index.jsp");
        return mv;
    }

}
