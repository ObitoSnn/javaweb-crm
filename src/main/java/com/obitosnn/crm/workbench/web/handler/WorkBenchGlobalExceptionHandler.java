package com.obitosnn.crm.workbench.web.handler;

import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.workbench.domain.Activity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * 全局异常处理类，所有工作区模块控制器方法抛出的异常在此类中的方法处理
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/26 22:07
 */
@ControllerAdvice
public class WorkBenchGlobalExceptionHandler {

    @ExceptionHandler(value = {FailToSaveException.class})
    @ResponseBody
    public Map<String, Object> saveActivityException(Exception e) {
        System.out.println("===================WorkBenchGlobalExceptionHandler.saveActivityException()执行了===================\n");
        Map<String, Object> map = new HashMap<String, Object>();
        String errorMsg = e.getMessage();
        /*if ("非法的结束日期".equals(errorMsg)) {

        }*/
        //将回传数据放入map中，解析成json
        map.put("success", false);
        map.put("errorMsg", errorMsg);
        return map;
    }

}
