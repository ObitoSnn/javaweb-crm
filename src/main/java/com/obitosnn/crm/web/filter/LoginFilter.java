package com.obitosnn.crm.web.filter;

import com.obitosnn.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 验证用户是否登录，拦截所有访问jsp页面的请求，未登录不能访问
 * @Author ObitoSnn
 * @Description:
 * @Date 2021/1/26 8:33
 */
public class LoginFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
        if (req instanceof HttpServletRequest && resp instanceof HttpServletResponse) {
            HttpServletRequest request = (HttpServletRequest) req;
            HttpServletResponse response = (HttpServletResponse) resp;
            String servletPath = request.getServletPath();
            System.out.println("==========LoginFilter.doFilter()执行了,拦截的路径是[" + servletPath + "]==========\n");
            if ("/index.jsp".equals(servletPath) || "/login.jsp".equals(servletPath)) {
                chain.doFilter(req, resp);
                System.out.println("==========[" + servletPath + "]该路径已放行==========\n");
            } else {
                //判断session域中是否有数据
                User user = (User) request.getSession().getAttribute("user");
                if (user == null) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    System.out.println("==========请求重定向至[" + request.getContextPath() + "/login.jsp" + "]==========\n");
                } else {
                    chain.doFilter(req, resp);
                    System.out.println("==========[" + servletPath + "]该路径已放行==========\n");
                }
            }
        }
    }

    @Override
    public void destroy() {

    }
}
