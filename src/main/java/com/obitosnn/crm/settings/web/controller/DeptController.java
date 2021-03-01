package com.obitosnn.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * @author ObitoSnn
 * @Date 2021/3/1 21:43
 */
@Controller
@RequestMapping(value = {"/settings/dept"})
public class DeptController {

    @RequestMapping(value = {"/deptManagement"})
    public ModelAndView deptManagement() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("forward:/pages/settings/dept/index.jsp");
        return mv;
    }


}
