package com.obitosnn.crm.exception;

/**
 * 数据未修改成功异常类
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/29 13:43
 */
public class FailToUpdateException extends Exception {
    public FailToUpdateException() {
        super();
    }

    public FailToUpdateException(String message) {
        super(message);
    }
}
