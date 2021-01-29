package com.obitosnn.crm.settings.web.handler;

import com.obitosnn.crm.exception.LoginException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * 全局异常处理类，所有系统设置模块控制器方法抛出的异常在此类中的方法处理
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/25 14:39
 */
@ControllerAdvice
public class SettingsGlobalExceptionHandler {

    @ExceptionHandler(value = {LoginException.class})
    @ResponseBody
    public Map<String, Object> loginException(Exception e) {
        System.out.println("===================SettingsGlobalExceptionHandler.loginException()执行了===================\n");
        Map<String, Object> map = new HashMap<String, Object>();
        String errorMsg = e.getMessage();
        //将回传数据放入map中，解析成json
        map.put("success", false);
        map.put("errorMsg", errorMsg);
        return map;
    }

}
