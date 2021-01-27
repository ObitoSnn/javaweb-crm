package com.obitosnn.crm.exception;

/**
 * 用户登录操作异常类
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/25 14:36
 */
public class LoginException extends Exception {

    public LoginException() {
        super();
    }

    public LoginException(String message) {
        super(message);
    }

}
