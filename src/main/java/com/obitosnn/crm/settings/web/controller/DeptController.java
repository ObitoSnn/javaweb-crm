package com.obitosnn.crm.settings.web.controller;

import com.obitosnn.crm.settings.domain.Dept;
import com.obitosnn.crm.settings.service.DeptService;
import com.obitosnn.crm.vo.PageVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * @author ObitoSnn
 * @Date 2021/3/1 21:43
 */
@Controller
@RequestMapping(value = {"/settings/dept"})
public class DeptController {
    @Autowired
    private DeptService deptService;

    @RequestMapping(value = {"/deptManagement"})
    public ModelAndView deptManagement() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("forward:/pages/settings/dept/index.jsp");
        return mv;
    }

    @RequestMapping(value = {"/pageList"})
    @ResponseBody
    public PageVo<Dept> pageList(HttpServletRequest request) {
        String pageNo = request.getParameter("pageNo");
        String pageSize = request.getParameter("pageSize");
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("pageNo", pageNo);
        map.put("pageSize", pageSize);
        return  deptService.getDeptPageVo(map);
    }


}
