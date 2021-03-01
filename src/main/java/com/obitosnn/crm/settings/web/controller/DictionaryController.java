package com.obitosnn.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * @author ObitoSnn
 * @Date 2021/3/1 21:52
 */
@Controller
@RequestMapping(value = {"/settings/dictionary"})
public class DictionaryController {

    @RequestMapping(value = {"/dicManagement"})
    public ModelAndView dicManagement() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("forward:/pages/settings/dictionary/index.jsp");
        return mv;
    }

}
