package com.obitosnn.crm.aspect;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 给所有控制器方法输出日志
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/30 21:44
 */
@Aspect
public class ControllerAspect {

    @Before(value = "execution(* *..controller.*.*(..))")
    public void doLog(JoinPoint joinPoint) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        System.out.println("=====[" + format.format(new Date()) + "]\t" + joinPoint.getSignature().toShortString() + "执行了=====\n");
    }

}
