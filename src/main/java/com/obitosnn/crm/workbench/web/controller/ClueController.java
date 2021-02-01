package com.obitosnn.crm.workbench.web.controller;

import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.settings.domain.User;
import com.obitosnn.crm.settings.service.UserService;
import com.obitosnn.crm.util.DateTimeUtil;
import com.obitosnn.crm.util.UUIDUtil;
import com.obitosnn.crm.workbench.domain.Clue;
import com.obitosnn.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author ObitoSnn
 * @Date 2021/2/1 17:59
 */
@Controller
@RequestMapping(value = {"/workbench/clue"})
public class ClueController {
    @Autowired
    private UserService userService;
    @Autowired
    private ClueService clueService;

    @RequestMapping(value = {"/getUserList"})
    @ResponseBody
    public List<User> getUserList() {
        return userService.getUserList();
    }

    @RequestMapping(value = {"/saveClue"})
    @ResponseBody
    public Map<String, Object> saveClue(HttpServletRequest request, Clue clue) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        //{"success":true/false}
//        id
        clue.setId(UUIDUtil.getUUID());
//        createBy
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        clue.setCreateBy(createBy);
//        createTime
        clue.setCreateTime(DateTimeUtil.getSysTime());
        boolean success = false;
        try {
            success = clueService.saveClue(clue);
        } catch (FailToSaveException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        return map;
    }

}