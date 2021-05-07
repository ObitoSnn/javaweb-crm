package com.obitosnn.crm.web.handler;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * 全局处理异常类，用来处理整个项目异常的
 * @author ObitoSnn
 * @Date 2021/3/2 14:34
 */
@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(value = {Exception.class})
    @ResponseBody
    public Map<String, Object> globalExceptionHandler(Exception e) {
        System.out.println("===================GlobalExceptionHandler.globalExceptionHandler()执行了===================\n");
        Map<String, Object> map = new HashMap<String, Object>();
        String errorMsg = e.getMessage();
        //将回传数据放入map中，解析成json
        map.put("success", false);
        map.put("errorMsg", errorMsg);
        return map;
    }

}
