package com.obitosnn.crm.web.handler;

import com.obitosnn.crm.settings.domain.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author ObitoSnn
 * @Date 2021/3/1 14:37
 */
public class ManagerInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String servletPath = request.getServletPath();
        System.out.println("==========ManagerInterceptor.preHandler()执行了,拦截的路径是[" + servletPath + "]==========\n");
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            //请求重定向至登录页面
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            System.out.println("==========请求重定向至[" + request.getContextPath() + "/login.jsp" + "]\n");
            return false;
        }
        if (!"root".equals(user.getLoginAct())) {
            //登录账户不是管理员账户
            request.setAttribute("errorMsg", "权限不足！");
            request.getRequestDispatcher("/pages/settings/index.jsp").forward(request, response);
            System.out.println("==========[" + user.getName() + "]用户权限不足，已拦截该用户的请求==========");
            return false;
        }
        return true;
    }

}
