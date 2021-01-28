package com.obitosnn.crm.exception;

/**
 * 数据删除失败异常类
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/28 20:16
 */
public class FailToDeleteException extends Exception {

    public FailToDeleteException() {
        super();
    }

    public FailToDeleteException(String message) {
        super(message);
    }
}
