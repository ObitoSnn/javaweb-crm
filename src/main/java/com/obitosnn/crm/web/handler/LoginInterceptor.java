package com.obitosnn.crm.web.handler;

import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 专门做预处理，检验用户是否登录
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/25 18:26
 */
public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response,
                             Object handler) throws Exception {
        String servletPath = request.getServletPath();
        System.out.println("==========LoginInterceptor.preHandler()执行了,拦截的路径是[" + servletPath + "]==========\n");
        //判断session域中是否有数据
        Object user = request.getSession().getAttribute("user");
        if (user == null) {
            //请求重定向至登录页面
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            System.out.println("==========请求重定向至[" + request.getContextPath() + "/login.jsp" + "]\n");
            return false;
        }
        return true;
    }

}