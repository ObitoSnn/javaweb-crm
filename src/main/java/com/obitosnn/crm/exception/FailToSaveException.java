package com.obitosnn.crm.exception;

/**
 * 数据未保存成功异常类
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/26 22:02
 */
public class FailToSaveException extends Exception {

    public FailToSaveException() {
        super();
    }

    public FailToSaveException(String message) {
        super(message);
    }
}
