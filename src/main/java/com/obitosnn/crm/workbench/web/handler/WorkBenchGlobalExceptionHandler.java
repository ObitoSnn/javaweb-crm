package com.obitosnn.crm.workbench.web.handler;

import com.obitosnn.crm.exception.FailToDeleteException;
import com.obitosnn.crm.exception.FailToSaveException;
import com.obitosnn.crm.exception.FailToUpdateException;
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
    public Map<String, Object> saveActivityOrActivityRemarkException(Exception e) {
        System.out.println("===================WorkBenchGlobalExceptionHandler.saveActivityOrActivityRemarkException()执行了===================\n");
        Map<String, Object> map = new HashMap<String, Object>();
        String errorMsg = e.getMessage();
        //将回传数据放入map中，解析成json
        map.put("success", false);
        map.put("errorMsg", errorMsg);
        return map;
    }

    @ExceptionHandler(value = {FailToDeleteException.class})
    @ResponseBody
    public Map<String, Object> deleteActivityOrActivityRemarkException(Exception e) {
        System.out.println("===================WorkBenchGlobalExceptionHandler.deleteActivityOrActivityRemarkException()执行了===================\n");
        Map<String, Object> map = new HashMap<String, Object>();
        String errorMsg = e.getMessage();
        //将回传数据放入map中，解析成json
        map.put("success", false);
        map.put("errorMsg", errorMsg);
        return map;
    }

    @ExceptionHandler(value = {FailToUpdateException.class})
    @ResponseBody
    public Map<String, Object> updateActivityException(Exception e) {
        System.out.println("===================WorkBenchGlobalExceptionHandler.updateActivityException()执行了===================\n");
        Map<String, Object> map = new HashMap<String, Object>();
        String errorMsg = e.getMessage();
        //将回传数据放入map中，解析成json
        map.put("success", false);
        map.put("errorMsg", errorMsg);
        return map;
    }

}
