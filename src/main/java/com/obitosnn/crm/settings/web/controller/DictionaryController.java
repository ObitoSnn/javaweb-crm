package com.obitosnn.crm.settings.web.controller;

import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.exception.FailToUpdateException;
import com.obitosnn.crm.settings.domain.DicType;
import com.obitosnn.crm.settings.service.DicService;
import com.obitosnn.crm.vo.PageVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.Map;

/**
 * @author ObitoSnn
 * @Date 2021/3/1 21:52
 */
@Controller
@RequestMapping(value = {"/settings/dictionary"})
public class DictionaryController {
    @Autowired
    private DicService dicService;

    @RequestMapping(value = {"/dicManagement"})
    public ModelAndView dicManagement() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("forward:/pages/settings/dictionary/index.jsp");
        return mv;
    }

    @RequestMapping("/type/pageList")
    @ResponseBody
    public PageVo<DicType> getDicTypePageList(String pageNo, String pageSize) {
        return dicService.getDicTypePageVo(pageNo, pageSize);
    }

    @RequestMapping("/saveDicType")
    @ResponseBody
    public Map<String, Object> saveDicType(DicType dicType) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        boolean success = false;
        try {
            success = dicService.saveDicType(dicType);
        } catch (FailToSaveException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        return map;
    }

    @RequestMapping("/getDicTypeDetailByCode")
    @ResponseBody
    public DicType getDicTypeDetailByCode(String code) {
        return dicService.getDicTypeDetailByCode(code);
    }

    @RequestMapping("/updateDicType")
    @ResponseBody
    public Map<String, Object> updateDicType(DicType dicType) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        boolean success = false;
        try {
            success = dicService.updateDicType(dicType);
        } catch (FailToUpdateException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        return map;
    }

    @RequestMapping("/deleteDicTypeByCodes")
    @ResponseBody
    public Map<String, Object> deleteDicTypeByCodes(String[] code) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        boolean success = false;
        try {
            success = dicService.deleteDicTypeByCodes(code);
        } catch (FailToDeleteException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        map.put("success", success);
        return map;
    }

}
